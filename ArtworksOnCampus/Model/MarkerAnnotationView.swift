//
//  MarkerAnnotationView.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 28/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit
import MapKit

class MarkerAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? CustomPointAnnotation else { return }
            clusteringIdentifier = String(describing: annotation.locationGroupIndex)
        }
    }
}
