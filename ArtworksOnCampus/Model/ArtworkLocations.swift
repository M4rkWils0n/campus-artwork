//
//  ArtworkLocations.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 30/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import Foundation
import MapKit

class ArtworkLocation {
    
    let loctionNote: String?
    let coordinateForDistance: CLLocation
    static var userLocation: CLLocation?
    let artworks: [CoreArtwork]?
    
    init(locationNote: String, latString: String?, lonString: String?, artworks: [CoreArtwork]?) {
        
        self.loctionNote = locationNote
        
        let lat: Double
        let lon: Double
        
        lat = Double(latString!)!
        lon = Double(lonString!)!
        
        self.coordinateForDistance = CLLocation(latitude: lat, longitude: lon)
        self.artworks = artworks!
    }
    
    func distanceFromLocation() -> Double{
        
        let distanceCCL = ArtworkLocation.userLocation?.distance(from: self.coordinateForDistance)
        
        return distanceCCL!
    }
}
