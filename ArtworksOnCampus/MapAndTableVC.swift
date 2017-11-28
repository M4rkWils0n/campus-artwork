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

    var artworksData: [CoreArtwork]?
    var artworkTransferData: CoreArtwork?
    
    var locationManager:CLLocationManager!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        map.delegate = self
        
        artworksData = CoreDataRequests.getArtworks()
        addAnnotations()
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
        nextViewController.artworkData = artworkTransferData
    }
}

/*
 *
 *  Class Extension for Map and Location Functions
 *  MapView Delegate
 *  Location Manager Delegate
 */
extension MapAndTableVC: MKMapViewDelegate, CLLocationManagerDelegate {

    // Adds annotations of stored locations to map
    func addAnnotations() {
        
        if let artworkData = artworksData {
            
            for artwork in artworkData {
                
                // Creates an annotation object and assigns the artwork title and location notes
                let annotation = MKPointAnnotation()
                annotation.title = artwork.title
                annotation.subtitle = artwork.artist
                
                var lat: Double
                var long: Double
                let lattitude = artwork.lat
                let longitude = artwork.long
                
                if let strLat = lattitude {
                    lat = Double(strLat)!
                    
                    if let strLon = longitude {
                        long = Double(strLon)!
                        annotation.coordinate = CLLocationCoordinate2DMake(lat,long)
                        map.addAnnotation(annotation)
                    }
                }
            }
        }
    }
    
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
    
    // Annotation clicked method
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // returns if annotation contains no title
        guard let annotationTitle = view.annotation?.title! else { return }
        
        // Stops My Location causing a segue
        if annotationTitle != "My Location" {
            
            // Gets correct artworksData from selected annotation
            artworkTransferData = artworksData?.first(where: { $0.title == annotationTitle })
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

