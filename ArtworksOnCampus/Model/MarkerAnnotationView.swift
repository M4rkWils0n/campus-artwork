//
//  MarkerAnnotationView.swift
//  ArtworksOnCampus
//
//
//  Created by Mark Wilson on 28/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit
import MapKit

// Annotation class - Clusters annotations by location identifier
class MarkerAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? Artworks else { return }
            clusteringIdentifier = String(describing: annotation.locationIdentifier)
        }
    }
}
