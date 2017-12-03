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
    
    var annotations: [Artworks] = {

        var artworksData = CoreDataRequests.getArtworks()    // Request from CoreData
        var assignedAnnotations: [Artworks] = []
        
        for artwork in artworksData {
            
            //ToDo: Check how many of these i will need
            let annotation = Artworks(id: artwork.id, title: artwork.title, artist: artwork.artist, yearOfWork: artwork.yearOfWork, information: artwork.information, locationNotes: artwork.locationNotes, fileName: artwork.fileName, latString: artwork.location?.lat ,lonString: artwork.location?.lon, locationIdentifier: artwork.location?.uuid!, image: artwork.image, groupLocation: artwork.location?.locationNotes)
            
            assignedAnnotations.append(annotation)
        }
        
        return assignedAnnotations
    }()
    
    
    var tableContents: [ArtworkLocation] = {
        
        var locationData = CoreDataRequests.getLocations()
        var locationsForTableContents: [ArtworkLocation] = []
        
        for location in locationData {
    
            let artworkArray = Array(location.artworks!) as? Array<CoreArtwork>
            let artworkLocation = ArtworkLocation(locationNote: location.locationNotes!, latString: location.lat, lonString: location.lon, artworks: artworkArray)
            locationsForTableContents.append(artworkLocation)
        }
        
        return locationsForTableContents
    }()
    
    
    // Create a location manager to trigger user tracking
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        Artworks.userLocation = manager.location
        return manager
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        map.delegate = self
        locationManager.delegate = self
        table.dataSource = self
        table.delegate = self
        
        map.register(MarkerAnnotationView.self,forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        
    }


    override func viewDidAppear(_ animated: Bool) {
        
        map.deselectAnnotation(currentlySelectedAnnotation, animated: true)
        map.addAnnotations(annotations)
        table.reloadData()
    }
    
    
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

    
    
    func getArtworkDataBy(selectedLocationIdentifier: String) -> [Artworks]? {
        
        var artworkArry: [Artworks] = []
        // Filters array with items of same selectedLocationIdentifier
        artworkArry = annotations.filter { $0.locationIdentifier == selectedLocationIdentifier }
        return artworkArry
    }
    
    
    func sortTableContentsByDistance() {
        
        tableContents = tableContents.sorted(by: { $0.distanceFromLocation() < $1.distanceFromLocation() })
    }
}


/*
 *
 *  Class Extension for Map and Location Functions
 *  MapView Delegate
 *  Location Manager Delegate
 */
extension MapAndTableVC: MKMapViewDelegate, CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        Artworks.userLocation = userLocation
        ArtworkLocation.userLocation = userLocation

        sortTableContentsByDistance()
        table.reloadData()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        map.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        
        let itemFromMemberAnnotations = memberAnnotations.first as! Artworks
        
        let cluster = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        
        cluster.title = itemFromMemberAnnotations.groupLocation
        
        cluster.subtitle = nil
        
        return cluster
    }
    
    
    // Annotation clicked
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
}



// Class extension for table
extension MapAndTableVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableContents[section].loctionNote
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableContents.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContents[section].artworks!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "tableCell")
        cell.textLabel!.text = tableContents[indexPath.section].artworks![indexPath.row].title
        cell.detailTextLabel?.text = tableContents[indexPath.section].artworks![indexPath.row].artist
        return cell
    }
}

