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

    var artworkLocations = [Dictionary<String,String>()]
    var artworksData: [CoreArtwork]?
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artworksData = CoreDataRequests.getArtworks()
        
        addAnnotations()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



// Class extension for Map
extension MapAndTableVC: MKMapViewDelegate {

    func addAnnotations(){
        
        if let artworkData = artworksData {
            
            for artwork in artworkData {
                
                let annotation = MKPointAnnotation()
                
                var lat = 0.0
                var long = 0.0
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

