//
//  Location+CoreDataClass.swift
//  
//
//  Created by Kiarash Teymoury on 6/27/17.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject {

    convenience init(placeID:String, locationInfo:NSDictionary, insertInto context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
        
        self.init(entity: entity!, insertInto: context)
        
        guard let name = locationInfo["name"] as? String else { return }
        
        self.placeID = placeID
        self.place_name = name
        
        guard let locationData = locationInfo["location"] as? NSDictionary else {return}
        
        guard let street = locationData["street"] as? String else { return }
        guard let city = locationData["city"] as? String else { return }
        guard let state = locationData["state"] as? String else { return }
        guard let zip = locationData["zip"] as? String else { return }
        guard let latitude = locationData["latitude"] as? Double else { return }
        guard let longtitude = locationData["longitude"] as? Double else { return }
        
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        self.latitude = latitude
        self.longtitude = longtitude
    }
}
