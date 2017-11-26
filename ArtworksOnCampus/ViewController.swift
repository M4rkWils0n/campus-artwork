//
//  ViewController.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 23/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataRequests.getDecodeAndSaveArtworks(urlString: "http://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/artworksOnCampus/data.php?class=artworks&last")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

