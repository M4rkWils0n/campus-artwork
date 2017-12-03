//
//  CollectionVC.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 30/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController {

    
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
    
        self.dismiss(animated: true)
    }
    
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    var annotationData: [Artworks]?
    
    var selectedArtwork: Artworks?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let groupLocation = annotationData?.first?.groupLocation {
//          titleLabel.title = groupLocation
            title = groupLocation
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextViewController = segue.destination as! ArtworkDescriptionVC
        nextViewController.annotationData = selectedArtwork
    }
}



extension CollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {



    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return annotationData!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionVCell
        
        cell.textLabel.text = annotationData![indexPath.item].artist!
        
        if let image = annotationData![indexPath.item].image {
            
            cell.cellImage.image = UIImage(data: image)
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedArtwork = annotationData?[indexPath.item]
        
        performSegue(withIdentifier: "collectionToDescription", sender: nil)
    }

}
