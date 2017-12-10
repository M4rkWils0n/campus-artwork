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
    
    let locationNote: String?
    let coordinateForDistance: CLLocation
    static var userLocation: CLLocation?
    let artworks: [CoreArtwork]?
    
    
    init(location: CoreLocations, artworks: [CoreArtwork]?) {
        
        self.locationNote = location.locationNotes
        let lat = Double(location.lat!)!
        let lon = Double(location.lon!)!
        self.coordinateForDistance = CLLocation(latitude: lat, longitude: lon)
        self.artworks = artworks!
    }
    
    
    func distanceFromLocation() -> Double{
        
        let distanceCCL = ArtworkLocation.userLocation?.distance(from: self.coordinateForDistance)
        
        return distanceCCL!
    }
}
