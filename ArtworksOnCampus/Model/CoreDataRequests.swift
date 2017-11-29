//
//  CoreDataRequests.swift
//  ArtworksOnCampus
//
//  Created by Mark Wilson on 23/11/2017.
//  Copyright © 2017 Mark Wilson. All rights reserved.
//  https://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http

import Foundation
import CoreData
import UIKit

class CoreDataRequests {
  
    static func getDecodeAndSaveArtworks(urlString: String) {
        
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
                            newArtwork.fileName = artwork.fileName
                            newArtwork.lastModified = artwork.lastModified
                           
                            existingStoredLocation.addToArtworks(newArtwork)
                            
                        } else {
                         
                            let newLocation = CoreLocations(context: PersistenceService.context)
                            newLocation.lat = artwork.lat
                            newLocation.lon = artwork.long
                            newLocation.locationNotes = artwork.locationNotes
                            
                            let newArtwork = CoreArtwork(context: PersistenceService.context)
                            newArtwork.id = Int16(artwork.id!)!
                            newArtwork.title = artwork.title
                            newArtwork.artist = artwork.artist
                            newArtwork.yearOfWork = artwork.yearOfWork
                            newArtwork.information = artwork.Information
                            newArtwork.locationNotes = artwork.locationNotes
                            newArtwork.fileName = artwork.fileName
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
                
            } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
            }
        }.resume()
    }
    
    // Checks to see if Artwork Exists in core data
    static func doesArkworkExistWith(id: String) -> Bool {
        
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
    
    // Check to see if location exists from co-ordinates if so retuens the Optional CoreLocations
    static func doesLocationExistWithCoOrds(lat: String, lon: String) -> CoreLocations? {
        
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
