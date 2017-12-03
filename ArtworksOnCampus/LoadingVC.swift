//
//  LoadingVC.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 01/12/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        CoreDataRequests.getDecodeAndSaveArtworkData(urlString: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/artworksOnCampus/data.php?class=artworks", completion: { (success) in


            
            self.performSegue(withIdentifier: "toStart", sender: nil)
        })

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        performSegue(withIdentifier: "toStart", sender: nil)
    }
}
