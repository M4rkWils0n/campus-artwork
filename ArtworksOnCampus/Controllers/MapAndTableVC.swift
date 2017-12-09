//
//  MapAndTableVC.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 26/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit
import MapKit

class MapAndTableVC: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    var selectedArtworkCollection: [Artworks]?
    var currentlySelectedAnnotation: Artworks?
    var annotations: [Artworks]?
    var tableContents: [ArtworkLocation]?
    
    // Create a location manager to trigger user tracking
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        Artworks.userLocation = manager.location
        return manager
    }()
    
    
    func setAnnotations() {
    
        let artworksData = CoreDataRequests.getArtworks()    // Request from CoreData
        var assignedAnnotations: [Artworks] = []
        
        for artwork in artworksData {
            
            let annotation = Artworks(artwork: artwork)
            assignedAnnotations.append(annotation)
        }
        
        annotations =  assignedAnnotations
    }
    
    
    func setTableContents() {
        let locationData = CoreDataRequests.getLocations()
        var locationsForTableContents: [ArtworkLocation] = []
        
        for location in locationData {
            
            let artworkArray = Array(location.artworks!) as? Array<CoreArtwork>
            let artworkLocation = ArtworkLocation(location: location, artworks: artworkArray)
            locationsForTableContents.append(artworkLocation)
        }
        
        tableContents = locationsForTableContents
    }
    
    
    @IBAction func focusOnUserClick(_ sender: UIButton) {
        focusOnUserLocation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        var urlString = ""
        
        // Check for updates
        if let lastUpdate = UserDefaults.standard.value(forKey: "last_update") {
            urlString = artworkWebAddress + "&lastUpdate=\(lastUpdate)"
            getArtworkFromLastUpdate(urlString: urlString)

        // First ever system run
        } else {
            urlString = artworkWebAddress
            getArtwork(urlString: urlString)
        }
        
        map.delegate = self
        locationManager.delegate = self
        table.dataSource = self
        table.delegate = self
        
        map.register(MarkerAnnotationView.self,forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        focusOnUserLocation()
    }

    // Get artwork data - initial request
    private func getArtwork(urlString: String) {
    
        CoreDataRequests.getDecodeAndSaveArtworkData(urlString: urlString, completion: { (success) in
            
            self.setAnnotations()
            self.setTableContents()
            
            DispatchQueue.main.async {
                self.table.reloadData()
                if let annotations = self.annotations {
                    self.map.addAnnotations(annotations)
                }
            }
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = formatter.string(from: date)
            
            UserDefaults.standard.setValue(formattedDate, forKey: "last_update")
        })
    }
    
    // Get new amended artwork data
    private func getArtworkFromLastUpdate(urlString: String) {
        
        CoreDataRequests.getDecodeSaveAndUpdateLastUpdateDataFrom(urlString: urlString, completion: { (success) in
            
            self.setAnnotations()
            self.setTableContents()
            
            DispatchQueue.main.async {
                self.table.reloadData()
                if let annotations = self.annotations {
                    self.map.addAnnotations(annotations)
                }
            }
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = formatter.string(from: date)
            
            UserDefaults.standard.setValue(formattedDate, forKey: "last_update")
        })
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    
        map.deselectAnnotation(currentlySelectedAnnotation, animated: true)
        
        if let annotations = self.annotations {
           map.addAnnotations(annotations)
        }
        
        table.reloadData()
    }
    

    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "toDescription" {
            
            let nextViewController = segue.destination as! ArtworkDescriptionVC
            nextViewController.annotationData = selectedArtworkCollection?.first
        
        } else if segue.identifier == "toCollection" {
            
            let nextViewController = segue.destination as! CollectionVC
            if let artworkCollection = selectedArtworkCollection {
                nextViewController.annotationData = artworkCollection
            }
        }
    }
}


/*
 *  Class Extension for Map and Location Functions
 *  MapView Delegate
 *  Location Manager Delegate
 */
extension MapAndTableVC: MKMapViewDelegate, CLLocationManagerDelegate {

    // When location updates, Artworks and Locations are updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        Artworks.userLocation = userLocation
        ArtworkLocation.userLocation = userLocation

        sortTableContentsByDistance()
        table.reloadData()
    }
    
    //  returns cluster of Annotations based on location
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        
        let itemFromMemberAnnotations = memberAnnotations.first as! Artworks
        let cluster = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        cluster.title = itemFromMemberAnnotations.groupLocation
        cluster.subtitle = nil
        
        return cluster
    }
    
    
    // gets annotation clicked and performs segue to relevant view
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        currentlySelectedAnnotation = view.annotation as? Artworks
        
        if let locationIndentifier = view.clusteringIdentifier {
            
            if let artworkCollection = getArtworkDataBy(selectedLocationIdentifier: locationIndentifier) {
                
                selectedArtworkCollection = artworkCollection
                
                if(artworkCollection.count > 1) {
                   performSegue(withIdentifier: "toCollection", sender: nil)
                
                } else {
                    performSegue(withIdentifier: "toDescription", sender: nil)
                }
            }
        }
    }
    
    // Focuses on user location
    func focusOnUserLocation() {
        
        if let userLocation:CLLocation = locationManager.location {
            
            let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            map.setRegion(region, animated: true)
        }
    }
    
    // gets array of Artwork data from locationIdentifier
    func getArtworkDataBy(selectedLocationIdentifier: String) -> [Artworks]? {
        
        var artworkArry: [Artworks] = []
        // Filters array with items of same selectedLocationIdentifier
        if let annotations = self.annotations {
            artworkArry = annotations.filter { $0.locationIdentifier == selectedLocationIdentifier }
        }
        
        return artworkArry
    }
}



/*
 *  Class Extension for Table
 *  TableView Delegate
 *  TableView DataSource
 */
extension MapAndTableVC: UITableViewDelegate, UITableViewDataSource {
    
    // sets the title for specfic header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableContents![section].loctionNote
    }
    
    // Sets number of sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let tableContents = self.tableContents {
            return tableContents.count
        }
        
        return 0
    }
    
    // Sets number of rows in specific section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tableContents = self.tableContents {
            return tableContents[section].artworks!.count
        }
        
        return 0
    }
    
    // Sets cell for table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "tableCell")
        cell.textLabel!.text = tableContents![indexPath.section].artworks![indexPath.row].title
        cell.detailTextLabel?.text = tableContents![indexPath.section].artworks![indexPath.row].artist
        return cell
    }
    
    // when row of table is clicked data from row is converted to the connected Artwork and segue performed
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
            // gets annonation by id for selected artwork
            if let selectedArtwork = annotations?.first(where: {$0.id == tableContents![indexPath.section].artworks![indexPath.row].id}) {
                
                var selectedArtworkArray: [Artworks] = []
                selectedArtworkArray.append(selectedArtwork)
                selectedArtworkCollection = selectedArtworkArray
                performSegue(withIdentifier: "toDescription", sender: nil)
            }

        return indexPath
    }
    
    // Sorts table by section from closest to user to furthest
    func sortTableContentsByDistance() {
        
        if let tableContents = self.tableContents {
            self.tableContents = tableContents.sorted(by: { $0.distanceFromLocation() < $1.distanceFromLocation() })
        }
    }
}

