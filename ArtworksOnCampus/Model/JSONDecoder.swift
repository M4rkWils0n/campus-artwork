//
//  JSONDecoder.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 23/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import Foundation
import UIKit

struct ArtworkItems: Decodable {
    let artworks: [Artwork]?
}

// May not need this, check before submitting
struct Locations: Decodable {
    let id: Int16?
    let lat: String?
    let lon: String?
}

struct Artwork: Decodable {
    let id: String?
    let title: String?
    let artist: String?
    let yearOfWork: String?
    let Information: String?
    let lat: String?
    let long: String?
    let locationNotes: String?
    let fileName: String?
    let lastModified: String?
}


