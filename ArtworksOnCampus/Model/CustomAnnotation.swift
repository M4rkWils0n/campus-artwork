//
//  CustomPointAnnotation.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 28/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit
import MapKit

final class CustomPointAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    let id: Int16?
    let title: String?
    let artist: String?
    let yearOfWork: String?
    let information: String?
    let locationNotes: String?
    let fileName: String?
    let locationGroupIndex: Int?

    
    init(id: Int16?, title: String?, artist: String?, yearOfWork: String?, information: String?, locationNotes: String?, fileName: String?, coordinate: CLLocationCoordinate2D, locationGroupIndex: Int?) {
        
        self.id = id
        self.title = title
        self.artist = artist
        self.yearOfWork = yearOfWork
        self.information = information
        self.locationNotes = locationNotes
        self.fileName = locationNotes
        self.coordinate = coordinate
        self.locationGroupIndex = locationGroupIndex
    }
}
