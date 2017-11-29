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
    
    var selectedAnnotation: CustomPointAnnotation?
    
    let annotations: [CustomPointAnnotation] = {
        
        var assignedAnnotations: [CustomPointAnnotation] = []
        var artworksData = CoreDataRequests.getArtworks()
        
        for artwork in artworksData {
        
            let lat: Double?
            let long: Double?
            
            if let latString = artwork.location?.lat, let lonString = artwork.location?.lon {
                
                lat = Double(latString)
                long = Double(lonString)
                
                let coordinates = CLLocationCoordinate2DMake(lat!,long!)
                
                let annotation = CustomPointAnnotation(id: artwork.id, title: artwork.title, artist: artwork.artist, yearOfWork: artwork.yearOfWork, information: artwork.information, locationNotes: artwork.locationNotes, fileName: artwork.fileName,coordinate: coordinates, locationGroupIndex: artwork.location?.index(ofAccessibilityElement: self))
                
                assignedAnnotations.append(annotation)
            }
        }

        return assignedAnnotations
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        let nextViewController = segue.destination as! ArtworkDescriptionVC
        nextViewController.annotationData = selectedAnnotation
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
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
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
        
            selectedAnnotation = view.annotation as? CustomPointAnnotation
            performSegue(withIdentifier: "toDescription", sender: nil)
        }
    }
}

//// Class extension for table
//extension MapAndTableVC: UITableViewDelegate, UITableViewDataSource {
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }
//}

