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
    
    class func handleInitzialingEventsData(dictionary: NSDictionary) -> Events {
        
        var events:Events?
        
        if let rsvp_status = dictionary["rsvp_status"] as? String {
            
            switch rsvp_status {
            case "unsure":
                events = Maybe(context: context)
                events?.rsvp_status = rsvp_status
                break
            case "attending":
                events = Attending(context: context)
                events?.rsvp_status = rsvp_status
                break
            case "not_replied":
                events = Invited(context: context)
                events?.rsvp_status = rsvp_status
                break
            default: break
    
            }
        }
        
        if let id = dictionary["id"] as? String {events?.event_id = id}
        
        if let name = dictionary["name"] as? String {events?.name = name}

        if let description = dictionary["description"] as? String {events?.details = description}
        
        if let coverDic = dictionary["cover"] as? NSDictionary, let coverSource = coverDic["source"] as? String {events?.coverURL = coverSource}
        
        if let rsvp_status = dictionary["rsvp_status"] as? String {events?.rsvp_status = rsvp_status}
        
        if let guest_enabled = dictionary["guest_list_enabled"] as? Bool {events?.guest_list_enabled = guest_enabled}
        
        if let interestedCount = dictionary["interested_count"] as? Int16, let declinedCount = dictionary["declined_count"] as? Int16, let attendingCount = dictionary["attending_count"] as? Int16 {
            
            events?.interested_count = interestedCount
            events?.declined_count = declinedCount
            events?.attending_count = attendingCount
        }
        
        if let start_time = dictionary["start_time"] as? String {
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
            
            if let date = dateFormatter.date(from: start_time) as NSDate? {
                
                events?.start_time = date
            }
        }
        
        if let end_time = dictionary["end_time"] as? String {
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
            
            if let date = dateFormatter.date(from: end_time) as NSDate? {
                
                events?.end_time = date
            }
            
        } else {
            
            //CustomeEnd Time by 10 hrs
            let end_time = events?.start_time?.AddEndTime()
            events?.end_time = end_time as NSDate?
        }
        
        CoreDataStack.coreData.saveContext()
        
        return events!
    }
    
    class func clearCoreData(entity:String) -> [Events] {
        
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                fetchRequest.predicate = NSPredicate(format: "start_time > %@", Date() as CVarArg)
            
            let objects = try(context.fetch(fetchRequest)) as? [Events]
                
            return objects!
            
        } catch {
            
            fatalError("Error Fetching \(entity)")
        }
    }
}
