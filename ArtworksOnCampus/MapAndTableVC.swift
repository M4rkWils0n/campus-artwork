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
    
    var selectedArtworkCollection: [Artworks]?
    
    // Array of Artworks
    var annotations: [Artworks] = {

        var artworksData = CoreDataRequests.getArtworks()    // Request from CoreData
        var assignedAnnotations: [Artworks] = []
        
        for artwork in artworksData {
            
            //ToDo: Check how many of these i will need
            let annotation = Artworks(id: artwork.id, title: artwork.title, artist: artwork.artist, yearOfWork: artwork.yearOfWork, information: artwork.information, locationNotes: artwork.locationNotes, fileName: artwork.fileName, latString: artwork.location?.lat ,lonString: artwork.location?.lon, locationIdentifier: artwork.location?.uuid!, image: artwork.image)   // Assign to Artwoks
            
            assignedAnnotations.append(annotation)
        }
        
        return assignedAnnotations
    }()
    
    
    // Create a location manager to trigger user tracking
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        Artworks.userLocation = manager.location
        return manager
    }()
    
    
    @IBOutlet weak var map: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        map.delegate = self
        map.register(MarkerAnnotationView.self,forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        map.addAnnotations(annotations)
        
        locationManager.delegate = self
    }


    
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    
    
    //Sorts annotations by distance from location
    func sortAnnotationsByDistance() {
        
        annotations = annotations.sorted(by: { $0.distanceFromLocation() < $1.distanceFromLocation() })
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
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        sortAnnotationsByDistance()
        table.reloadData()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        map.setRegion(region, animated: true)
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        
        let cluster = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        
        cluster.title = nil
        cluster.subtitle = nil
        
        return cluster
    }
    

    
    // Annotation clicked method
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return annotations.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "tableCell")
        cell.textLabel!.text = annotations[indexPath.item].title
        
        return cell
    }
}

