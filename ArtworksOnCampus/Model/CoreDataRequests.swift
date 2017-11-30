//
//  CoreDataRequests.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 23/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.

import Foundation
import CoreData
import UIKit

class CoreDataRequests {
  
    static func getDecodeAndSaveArtworkData(urlString: String, completion: @escaping (_ success:Bool) -> Void ) {
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url){ (data, response, err) in
    
            guard let data = data else { return }
         
            do{
                let downloadedArtworkItems = try JSONDecoder().decode(ArtworkItems.self, from: data)
                
                let theArtworks = downloadedArtworkItems.artworks
                
                for artwork in theArtworks! {
                    
                    // Check to see if specific artwork exists
                    if(!doesArkworkExistWith(id: artwork.id!)) {
                        
                        if let existingStoredLocation = doesLocationExistWithCoOrds(lat: artwork.lat!, lon: artwork.long!) {
                        
                            let newArtwork = CoreArtwork(context: PersistenceService.context)
                            newArtwork.id = Int16(artwork.id!)!
                            newArtwork.title = artwork.title
                            newArtwork.artist = artwork.artist
                            newArtwork.yearOfWork = artwork.yearOfWork
                            newArtwork.information = artwork.Information
                            newArtwork.locationNotes = artwork.locationNotes
                
                            let stringConcat = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/artwork_images/" + artwork.fileName!
                            let urlString = stringConcat.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            newArtwork.fileName = urlString
                            newArtwork.lastModified = artwork.lastModified
                           
                            existingStoredLocation.addToArtworks(newArtwork)
                            
                        } else {
                         
                            let newLocation = CoreLocations(context: PersistenceService.context)
                            newLocation.lat = artwork.lat
                            newLocation.lon = artwork.long
                      
                            if let rawLocationNotes = artwork.locationNotes {
                                let index = rawLocationNotes.index(of: ",") ?? rawLocationNotes.endIndex
                                newLocation.locationNotes = String(rawLocationNotes[..<index])
                            }
                            newLocation.uuid = NSUUID().uuidString
                            
                            let newArtwork = CoreArtwork(context: PersistenceService.context)
                            newArtwork.id = Int16(artwork.id!)!
                            newArtwork.title = artwork.title
                            newArtwork.artist = artwork.artist
                            newArtwork.yearOfWork = artwork.yearOfWork
                            newArtwork.information = artwork.Information
                            newArtwork.locationNotes = artwork.locationNotes
                            
                            let stringConcat = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/artwork_images/" + artwork.fileName!
                            let urlString = stringConcat.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            newArtwork.fileName = urlString
                            newArtwork.lastModified = artwork.lastModified
                            newLocation.addToArtworks(newArtwork)
                        }
                    }
                }
                
                do {
                    PersistenceService.saveContext()
                }
                
                do{
                    try PersistenceService.context.save()
                } catch {
                    print("error")
                }
                
                completion(true)
                
            } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
            }
        }.resume()
    }
    
    
    private static func getImageFrom(urlString: String, artwork: CoreArtwork) {
        
        if let url = URL(string: urlString){
        
            var imageData: NSData?
            
            let session = URLSession.shared
            
            session.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else { return }
                
                if let image = UIImage(data: data) {
                    
                    imageData = UIImagePNGRepresentation(image)! as NSData
                    artwork.image = imageData as Data?
                    
                    do{
                        try PersistenceService.context.save()
                    } catch {
                        print("error")
                    }
                }
                
            }.resume()
        }
    }
    
    static func getImagesForArtworks(){
        
        let artworks = getArtworks()
        
        for artwork in artworks {
         
            if artwork.image == nil {
            
                if let url = artwork.fileName {
                    
                    getImageFrom(urlString: url, artwork: artwork)
                }
            }
        }
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
    
}
