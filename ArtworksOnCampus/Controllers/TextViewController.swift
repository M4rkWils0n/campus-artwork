//
//  TextViewController.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 05/12/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    var artwork: CoreArtwork?
    
    @IBOutlet weak var artworkLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var textInformationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "About"
        
        if let artwork = self.artwork {
            
            artworkLabel.text = artwork.title
            artistLabel.text = artwork.artist
            yearLabel.text = artwork.yearOfWork
            textInformationLabel.text = artwork.information
        }
    }
}
