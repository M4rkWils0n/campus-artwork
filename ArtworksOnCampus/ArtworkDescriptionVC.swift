//
//  ArtworkDescriptionVC.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 27/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class ArtworkDescriptionVC: UIViewController {

    @IBAction func doneButtonClicked(_ sender: Any) {
    
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    @IBOutlet weak var subView: UIView!
    
    var artworkData: CoreArtwork?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.title = artworkData?.title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Passes data to subView
        let nextViewController = segue.destination as! ArtworkDescriptionChildVC
        nextViewController.artworkData = self.artworkData
    }
}
