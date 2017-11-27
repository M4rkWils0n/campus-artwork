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
    
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        map.delegate = self
        artworksData = CoreDataRequests.getArtworks()
        addAnnotations()
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

// Class extension for Map
extension MapAndTableVC: MKMapViewDelegate {

    // Adds annotations of stored locations to map
    func addAnnotations() {
        
        if let artworkData = artworksData {
            
            for artwork in artworkData {
                
                // Creates an annotation object and assigns the artwork title and location notes
                let annotation = MKPointAnnotation()
                annotation.title = artwork.title
                annotation.subtitle = artwork.locationNotes
                
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
    
    // Annotation clicked method
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        artworkTransferData = artworksData?.first(where: { $0.title == (view.annotation!.title)! })
        performSegue(withIdentifier: "toDescription", sender: nil)
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

