//
//  CollectionVC.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 30/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController {
    
    var annotationData: [Artworks]?
    var selectedArtwork: Artworks?
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let groupLocation = annotationData?.first?.groupLocation {
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
        
        if let artwork = CoreDataRequests.getArtworkFrom(id: annotationData![indexPath.item].id!) {
            if let image = artwork.image {
                cell.cellImage.image = UIImage(data: image)
                
            } else {
                cell.cellImage.image = UIImage(named: "placeholder")
                CoreDataRequests.downloadImageNeededForCollection(source: collection, indexPath: indexPath, annotation: annotationData![indexPath.item])
            }
        } else {
           cell.cellImage.image = UIImage(named: "placeholder")
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedArtwork = annotationData?[indexPath.item]
        performSegue(withIdentifier: "collectionToDescription", sender: nil)
    }

}
