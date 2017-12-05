//
//  ArtworkDescriptionVC.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 27/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class ArtworkDescriptionVC: UIViewController {

    var annotationData: Artworks?
    
    @IBOutlet weak var subView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = annotationData?.artist
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Passes data to subView
        let nextViewController = segue.destination as! ArtworkDescriptionChildVC
        nextViewController.annotationData = self.annotationData
    }
}
