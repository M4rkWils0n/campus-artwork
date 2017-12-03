//
//  ArtworkDescriptionChildVC.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 27/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class ArtworkDescriptionChildVC: UIViewController {

    @IBOutlet weak var artworkLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var imagePanel: UIImageView!
    
    
    var annotationData: Artworks?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        artworkLabel.text = annotationData?.title
        yearLabel.text = annotationData?.yearOfWork
        informationLabel.text = annotationData?.information
        
        if let image = annotationData?.image {
            imagePanel.image = UIImage(data: image)
        }
    }
}
