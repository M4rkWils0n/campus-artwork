//
//  ArtworkDescriptionChildVC.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 27/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class ArtworkDescriptionChildVC: UIViewController {

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    
    var artworkData: CoreArtwork?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let artwork = artworkData {
            artistLabel.text = artwork.artist
            yearLabel.text = artwork.yearOfWork
            informationLabel.text = artwork.information
        } 
    }
}
