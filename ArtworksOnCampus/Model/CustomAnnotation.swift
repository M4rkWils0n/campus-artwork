//
//  CustomPointAnnotation.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 28/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit
import MapKit

final class Artworks: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let coordinateForDistance: CLLocation
    let id: Int16?
    let title: String?
    let artist: String?
    let yearOfWork: String?
    let information: String?
    let locationNotes: String?
    let fileName: String?
    let locationIdentifier: String
    let groupLocation: String?
    var distanceFromUser = 0.0
    static var userLocation: CLLocation? 
    
    init(artwork: CoreArtwork) {
                        
        let lat = Double(artwork.location!.lat!)!
        let long = Double(artwork.location!.lon!)!
        
        self.coordinate = CLLocationCoordinate2DMake(lat,long)
        self.coordinateForDistance = CLLocation(latitude: lat, longitude: long)
        self.id = artwork.id
        self.title = artwork.title
        self.artist = artwork.artist
        self.yearOfWork = artwork.yearOfWork
        self.information = artwork.information
        self.locationNotes = artwork.locationNotes
        self.fileName = artwork.fileName
        self.locationIdentifier = artwork.location!.uuid!
        self.groupLocation = artwork.location?.locationNotes
    }
    
    
    func distanceFromLocation() -> Double {
      
        let distanceCCL = Artworks.userLocation?.distance(from: self.coordinateForDistance)
        
        return distanceCCL!
    }
}
