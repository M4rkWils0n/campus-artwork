//
//  ViewController.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 23/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var subView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataRequests.getDecodeAndSaveArtworkData(urlString: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/artworksOnCampus/data.php?class=artworks&last", completion: { (success) in
            
            CoreDataRequests.getImagesForArtworks()
            
        })
    }
    

    
    



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

