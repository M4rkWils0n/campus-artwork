//
//  ArtLocations.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 29/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class ArtLocations {

    let loctionNote: String?
    let lat: String?
    let lon: String?
    let building: String?

    init(locationNote: String, lat: String, lon:String) {
        
        self.loctionNote = locationNote
        self.lat = lat
        self.lon = lon
        
        let rawLocationNotes = locationNote
        let index = rawLocationNotes.index(of: ",") ?? rawLocationNotes.endIndex
        self.building = String(rawLocationNotes[..<index])
    }
}
