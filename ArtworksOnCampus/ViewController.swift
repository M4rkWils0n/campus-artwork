//
//  ViewController.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 23/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var artworkLocations = [Dictionary<String,String>()]
    
    @IBOutlet weak var subView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataRequests.getDecodeAndSaveArtworks(urlString: "http://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/artworksOnCampus/data.php?class=artworks&last")
        
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "toChild") {
//            let mapAndTableView = segue.destination  as! MapAndTableVC
//            
//            
//        }
//    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

