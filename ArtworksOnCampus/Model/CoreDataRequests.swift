//
//  CoreDataRequests.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 23/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.

import Foundation
import CoreData
import UIKit

let artworkImageAddress = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/artwork_images/"
let artworkWebAddress = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/artworksOnCampus/data.php?class=artworks"

class CoreDataRequests {
  
    // Retrives, decodes and saves artwork
    // Completion handler to inform calling method when finished
    // Completiom handler will return true if data is retrieved
    // Completion handler will return false if either url is not correct, no connection to download data or JSON nor decoded
    static func getDecodeAndSaveArtworkData(urlString: String, completion: @escaping (_ success:Bool) -> Void ) {
        
        guard let url = URL(string: urlString)
            else {
                completion(false)
                return
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: url){ (data, response, err) in
    
            guard let data = data else {
                completion(false)
                return
            }
         
            do{
                let downloadedArtworkItems = try JSONDecoder().decode(ArtworkItems.self, from: data)
                
                let theArtworks = downloadedArtworkItems.artworks
                
                for artwork in theArtworks! {
                    
                    // Check to see if specific artwork exists
                    if(!doesArkworkExistWith(id: artwork.id!)) {
                        
                        print("Downloading \(String(describing: artwork.title!))")
                        
                        if let existingStoredLocation = doesLocationExistWithCoOrds(lat: artwork.lat!, lon: artwork.long!) {
                            
                            let newArtwork = CoreArtwork(context: PersistenceService.context)
                            newArtwork.id = Int16(artwork.id!)!
                            newArtwork.title = artwork.title
                            newArtwork.artist = artwork.artist
                            newArtwork.yearOfWork = artwork.yearOfWork
                            newArtwork.information = artwork.Information
                            newArtwork.locationNotes = artwork.locationNotes
                            
                            let stringConcat = artworkImageAddress + artwork.fileName!
                            let urlString = stringConcat.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            newArtwork.fileName = urlString
                            newArtwork.lastModified = artwork.lastModified
                            existingStoredLocation.addToArtworks(newArtwork)
                            
                            do {
                                PersistenceService.saveContext()
                            }
                            
                            do{
                                try PersistenceService.context.save()
                            } catch {
                                print("error")
                            }
                            
                        } else {
                         
                            let newLocation = CoreLocations(context: PersistenceService.context)
                            newLocation.lat = artwork.lat
                            newLocation.lon = artwork.long
                            newLocation.uuid = NSUUID().uuidString
                      
                            if let rawLocationNotes = artwork.locationNotes {
                                let index = rawLocationNotes.index(of: ",") ?? rawLocationNotes.endIndex
                                newLocation.locationNotes = String(rawLocationNotes[..<index])
                            }
                            
                            let newArtwork = CoreArtwork(context: PersistenceService.context)
                            newArtwork.id = Int16(artwork.id!)!
                            newArtwork.title = artwork.title
                            newArtwork.artist = artwork.artist
                            newArtwork.yearOfWork = artwork.yearOfWork
                            newArtwork.information = artwork.Information
                            newArtwork.locationNotes = artwork.locationNotes
                            
                            let stringConcat = artworkImageAddress + artwork.fileName!
                            let urlString = stringConcat.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            newArtwork.fileName = urlString
                            newArtwork.lastModified = artwork.lastModified
                            
                            newLocation.addToArtworks(newArtwork)
                            
                            do {
                                PersistenceService.saveContext()
                            }
                            
                            do{
                                try PersistenceService.context.save()
                            } catch {
                                print("error")
                            }
                        }
                    }
                }
            
            completion(true)
                
            } catch let jsonErr {
                
                completion(false)
                print("Error decoding JSON", jsonErr)
            }
        }.resume()
    }
    
    
    static func getDecodeSaveAndUpdateLastUpdateDataFrom(urlString: String, completion: @escaping (_ success: Bool) -> Void ) {
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else {
                completion(false)
                return }

            do{
                let downloadedArtworkItems = try JSONDecoder().decode(ArtworkItems.self, from: data)
                if let theArtworks = downloadedArtworkItems.artworks {
                    
                    for artwork in theArtworks {
                        
                        if doesArkworkExistWith(id: artwork.id!) {
                            
                            if let existingArtwork = self.getArtworkFrom(id: Int16(artwork.id!)!) {
                                
                                // This means that artwork needs updating
                                existingArtwork.title = artwork.title
                                existingArtwork.artist = artwork.artist
                                existingArtwork.yearOfWork = artwork.yearOfWork
                                existingArtwork.information = artwork.Information
                                existingArtwork.locationNotes = artwork.locationNotes
                                
                                let stringConcat = artworkImageAddress + artwork.fileName!
                                let urlString = stringConcat.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                existingArtwork.fileName = urlString
                                existingArtwork.lastModified = artwork.lastModified
                                
                                // Need to delete image just incase that has changed
                                existingArtwork.image = nil
                                
                                do{
                                    try PersistenceService.context.save()
                                } catch {
                                    print("error")
                                }
                            }
                            
                            // New artwork
                        } else {
                            
                            // Check to see if location exists
                            if let existingStoredLocation = doesLocationExistWithCoOrds(lat: artwork.lat!, lon: artwork.long!) {
                                
                                let newArtwork = CoreArtwork(context: PersistenceService.context)
                                newArtwork.id = Int16(artwork.id!)!
                                newArtwork.title = artwork.title
                                newArtwork.artist = artwork.artist
                                newArtwork.yearOfWork = artwork.yearOfWork
                                newArtwork.information = artwork.Information
                                newArtwork.locationNotes = artwork.locationNotes
                                
                                let stringConcat = artworkImageAddress + artwork.fileName!
                                let urlString = stringConcat.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                newArtwork.fileName = urlString
                                newArtwork.lastModified = artwork.lastModified
                                existingStoredLocation.addToArtworks(newArtwork)
                                
                                do {
                                    PersistenceService.saveContext()
                                }
                                
                                do{
                                    try PersistenceService.context.save()
                                } catch {
                                    print("error")
                                }
                               
                                // location does not exist
                            } else {
                                
                                let newLocation = CoreLocations(context: PersistenceService.context)
                                newLocation.lat = artwork.lat
                                newLocation.lon = artwork.long
                                newLocation.uuid = NSUUID().uuidString
                                
                                if let rawLocationNotes = artwork.locationNotes {
                                    let index = rawLocationNotes.index(of: ",") ?? rawLocationNotes.endIndex
                                    newLocation.locationNotes = String(rawLocationNotes[..<index])
                                }
                                
                                let newArtwork = CoreArtwork(context: PersistenceService.context)
                                newArtwork.id = Int16(artwork.id!)!
                                newArtwork.title = artwork.title
                                newArtwork.artist = artwork.artist
                                newArtwork.yearOfWork = artwork.yearOfWork
                                newArtwork.information = artwork.Information
                                newArtwork.locationNotes = artwork.locationNotes
                                
                                let stringConcat = artworkImageAddress + artwork.fileName!
                                let urlString = stringConcat.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                newArtwork.fileName = urlString
                                newArtwork.lastModified = artwork.lastModified
                                
                                newLocation.addToArtworks(newArtwork)
                                
                                do {
                                    PersistenceService.saveContext()
                                }
                                
                                do{
                                    try PersistenceService.context.save()
                                } catch {
                                    print("error")
                                }
                            }
                        }
                    }
                }
                
            completion(true)
                
            } catch let jsonErr {
                
                print("Error decoding JSON", jsonErr)
            }
        }.resume()
    }
    
    
    // Checks to see if Artwork Exists in core data
    private static func doesArkworkExistWith(id: String) -> Bool {
        
        let fetchRequest: NSFetchRequest<CoreArtwork> = CoreArtwork.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        var results: [CoreArtwork] = []
        
        do {
            results = try PersistenceService.context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    // Check to see if location exists from co-ordinates if so returns the Optional CoreLocations
    private static func doesLocationExistWithCoOrds(lat: String, lon: String) -> CoreLocations? {
        
        let fetchRequest: NSFetchRequest<CoreLocations> = CoreLocations.fetchRequest()
    
        fetchRequest.predicate = NSPredicate(format: "lat = %@ AND lon = %@", lat, lon)
        
        var result: [CoreLocations] = []
        
        do {
            result = try PersistenceService.context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return result.first
    }
    
    static func getArtworks() -> [CoreArtwork] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreArtwork")
        var results: [CoreArtwork] = []
        
        do {
            results = try PersistenceService.context.fetch(fetchRequest) as! [CoreArtwork]
        }
        catch {
            print("error Fetcing data")
        }
        
        return results
    }
    
    static func getLocations() -> [CoreLocations] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreLocations")
        var results: [CoreLocations] = []
        
        do {
            results = try PersistenceService.context.fetch(fetchRequest) as! [CoreLocations]
        }
        catch {
            print("error Fetcing data")
        }
        
        return results
    }
    
    
    static func downloadImageNeededForCollection(source: Any, indexPath: IndexPath, annotation: Artworks) {
        
            let source = source as! UICollectionView
            let url = URL(string: annotation.fileName!)
            var imageData: NSData?
        
            let session = URLSession.shared
            session.downloadTask(with: url!, completionHandler: { (location, response, error) in
                
                if let data = try? Data(contentsOf: url!) {
                    
                    DispatchQueue.main.async(execute: {
                        
                        let updateCell = source.cellForItem(at: indexPath) as? CollectionVCell
                        let img = UIImage(data: data)
                        updateCell?.cellImage.image = img
                        
                        let artwork = getArtworkFrom(id: annotation.id!)
                        imageData = UIImagePNGRepresentation(img!)! as NSData
                        artwork?.image = imageData as Data?
                        
                        do{
                            try PersistenceService.context.save()
                        } catch {
                            print("error")
                        }
                    })
                }
            }).resume()
    }
    
    
    static func downloadImageNeededForDesription(source: UIButton, annotation: Artworks) {
        
        let updateItem = source
        
        let url = URL(string: annotation.fileName!)
        
        var imageData: NSData?
        
        let session = URLSession.shared
        session.downloadTask(with: url!, completionHandler: { (location, response, error) in
            
            if let data = try? Data(contentsOf: url!) {
                
                DispatchQueue.main.async(execute: {
                    
                    let img = UIImage(data: data)
                    updateItem.setImage(img, for: .normal)
                    let artwork = getArtworkFrom(id: annotation.id!)
                    imageData = UIImagePNGRepresentation(img!)! as NSData
                    artwork?.image = imageData as Data?
                    
                    do{
                        try PersistenceService.context.save()
                    } catch {
                        print("error")
                    }
                })
            }
        }).resume()
    }
    
    static func getArtworkFrom(id: Int16) -> CoreArtwork? {
        
        let fetchRequest: NSFetchRequest<CoreArtwork> = CoreArtwork.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id = %i",id)
        
        var result: [CoreArtwork] = []
        
        do {
            result = try PersistenceService.context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return result.first
    }
}
