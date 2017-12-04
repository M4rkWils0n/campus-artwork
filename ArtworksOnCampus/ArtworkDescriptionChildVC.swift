//
//  ArtworkDescriptionChildVC.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 27/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class ArtworkDescriptionChildVC: UIViewController {

    var annotationData: Artworks?
    
    @IBOutlet weak var artworkLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    
    var viewArtwork: CoreArtwork?
    
    @IBAction func imageButtonClick(_ sender: Any) {
    
        performSegue(withIdentifier: "toImage", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        artworkLabel.text = annotationData?.title
        yearLabel.text = annotationData?.yearOfWork
        informationLabel.text = annotationData?.information
        
        if let artwork = CoreDataRequests.getArtworkFrom(id: annotationData!.id!) {
            
            viewArtwork = artwork
            
            if let image = artwork.image {

                imageButton.setImage(UIImage(data: image), for: .normal)
            } else {
                
                imageButton.imageView?.image = UIImage(named: "placeholder")
                CoreDataRequests.downloadImageNeededForDesription(source: imageButton, annotation: annotationData!)
            }
        
        } else {
            
            imageButton.setImage(UIImage(named: "placeholder"), for: .normal)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextViewController = segue.destination as! ImageViewController
        
        nextViewController.passedImage = UIImage(data: (viewArtwork?.image!)!)
        
        nextViewController.imageName = viewArtwork?.title
        

    }
}
