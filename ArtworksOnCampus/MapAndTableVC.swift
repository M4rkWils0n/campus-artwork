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
    
    // Annotation Selected on Map
    var selectedAnnotation: Artworks?
    
    
    // Array of Artworks
    var annotations: [Artworks] = {

        var artworksData = CoreDataRequests.getArtworks()    // Request from CoreData
        var assignedAnnotations: [Artworks] = []
        
        for artwork in artworksData {
            
            let annotation = Artworks(id: artwork.id, title: artwork.title, artist: artwork.artist, yearOfWork: artwork.yearOfWork, information: artwork.information, locationNotes: artwork.locationNotes, fileName: artwork.fileName, latString: artwork.location?.lat ,lonString: artwork.location?.lon,locationGroupIndex: artwork.location?.index(ofAccessibilityElement: self))   // Assign to Artwoks
            
            assignedAnnotations.append(annotation)
        }
        
        return assignedAnnotations
    }()
    
    // TODO: Need to check if this will be used, if not delete and delete the Model ArtLocations
    let locations: [ArtLocations] = {
        
        let retrievedLocations = CoreDataRequests.getLocations()
        var locationsArray: [ArtLocations] = []
        
        for location in retrievedLocations {
            
            let retrivedLocation = ArtLocations(locationNote: location.locationNotes!, lat: location.lat!, lon: location.lon!)
            locationsArray.append(retrivedLocation)
        }
        
        return locationsArray
    }()
    
    
    
    var locationManager:CLLocationManager!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        map.delegate = self
        map.register(MarkerAnnotationView.self,forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        map.addAnnotations(annotations)
    }

    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
        table.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        let nextViewController = segue.destination as! ArtworkDescriptionVC
        nextViewController.annotationData = selectedAnnotation
    }
    
    func sortAnnotationsByDistance() {
    
        annotations = annotations.sorted(by: { $0.distanceFromLocation() < $1.distanceFromLocation() })

        table.reloadData()
    }
}

/*
 *
 *  Class Extension for Map and Location Functions
 *  MapView Delegate
 *  Location Manager Delegate
 */
extension MapAndTableVC: MKMapViewDelegate, CLLocationManagerDelegate {

    
    // get Current Location
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        Artworks.userLocation = locationManager.location
        
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        Artworks.userLocation = userLocation
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        sortAnnotationsByDistance()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        map.setRegion(region, animated: true)
        
    }
    
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        
        let cluster = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        
        cluster.title = "Artworks"
        cluster.subtitle = nil
        
        return cluster
    }
    
    
    
    // Annotation clicked method
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // returns if annotation contains no title
        guard let annotationTitle = view.annotation?.title! else { return }
        
        // Stops My Location causing a segue
        if annotationTitle != "My Location" {
        
            selectedAnnotation = view.annotation as? Artworks
            performSegue(withIdentifier: "toDescription", sender: nil)
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

