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
    let locationGroupIndex: Int?
    var distanceFromUser = 0.0
    static var userLocation: CLLocation? 
    
    init(id: Int16?, title: String?, artist: String?, yearOfWork: String?, information: String?, locationNotes: String?, fileName: String?,latString: String?, lonString: String?, locationGroupIndex: Int?) {
        
        let lat: Double
        let long: Double
        
        lat = Double(latString!)!
        long = Double(lonString!)!
        
        self.coordinate = CLLocationCoordinate2DMake(lat,long)
        self.coordinateForDistance = CLLocation(latitude: lat, longitude: long)
        self.id = id
        self.title = title
        self.artist = artist
        self.yearOfWork = yearOfWork
        self.information = information
        self.locationNotes = locationNotes
        self.fileName = locationNotes
        
        self.locationGroupIndex = locationGroupIndex
    }
    
    

    func distanceFromLocation() -> Double{
      
        let distanceCCL = Artworks.userLocation?.distance(from: self.coordinateForDistance)
        
        return distanceCCL!
    }
}
