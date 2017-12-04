//
//  ImageViewController.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 03/12/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    var passedImage: UIImage?
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = imageName
        image.image = passedImage
    }
}
