//
//  Events+CoreDataClass.swift
//  
//
//  Created by Kiarash Teymoury on 6/17/17.
//
//

import Foundation
import CoreData

@objc(Events)
public class Events: NSManagedObject {
    
    convenience init(dictionary: NSDictionary, insertIntoManagedObjectContext context: NSManagedObjectContext) {
        
        var entityName = String()
    
        if let rsvp_status = dictionary["rsvp_status"] as? String {
        
            switch rsvp_status {
            case "unsure":
                entityName = "Maybe"
                break
            case "attending":
                entityName = "Attending"
                break
            case "not_replied":
                entityName = "Invited"
                break
            default: break
                
            }
        }
        
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        self.init(entity: entity!, insertInto: context)
        
        if let id = dictionary["id"] as? String {self.event_id = id}
        
        if let name = dictionary["name"] as? String {self.name = name}
        
        if let description = dictionary["description"] as? String {self.details = description}
        
        if let rsvp_status = dictionary["rsvp_status"] as? String {self.rsvp_status = rsvp_status}
        
        if let coverDic = dictionary["cover"] as? NSDictionary, let coverSource = coverDic["source"] as? String {self.coverURL = coverSource}
    
        if let guest_enabled = dictionary["guest_list_enabled"] as? Bool {self.guest_list_enabled = guest_enabled}
        
        if let interestedCount = dictionary["interested_count"] as? Int16, let declinedCount = dictionary["declined_count"] as? Int16, let attendingCount = dictionary["attending_count"] as? Int16 {
            
            self.interested_count = interestedCount
            self.declined_count = declinedCount
            self.attending_count = attendingCount
        }
        
        if let ownerDic = dictionary["owner"] as? NSDictionary, let owner_name = ownerDic["name"] as? String, let owner_id = ownerDic["id"] as? String {
            
            self.owner_name = owner_name
            self.owner_id = owner_id
        }
    
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
        
        guard let start_time = dictionary["start_time"] as? String, let Startdate = dateFormatter.date(from: start_time) as NSDate? else {return}
    
        self.start_time = Startdate
        
        if let end_time = dictionary["end_time"] as? String {
         
            if let endDate = dateFormatter.date(from: end_time) as NSDate? {
                
                self.end_time = endDate
            }
            
        } else {
            
            //CustomeEnd Time by 10 hrs
            let end_time = self.start_time?.AddEndTime()
            
            self.end_time = end_time as NSDate?
        }
    }
    
    internal class func FetchData(predicate:NSPredicate ,entity:String) -> [Events] {
        
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                fetchRequest.predicate = predicate
    
            let sortByTime = NSSortDescriptor(key: "end_time", ascending: false)
                fetchRequest.sortDescriptors = [sortByTime]
            
            guard let objects = try(context.fetch(fetchRequest)) as? [Events] else {return []}
            
            return objects
            
        } catch {
            
            fatalError("Error Fetching \(entity)")
        }
    }
}
