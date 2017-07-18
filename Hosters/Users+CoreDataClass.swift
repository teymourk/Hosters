//
//  Users+CoreDataClass.swift
//  
//
//  Created by Kiarash Teymoury on 6/20/17.
//
//

import Foundation
import CoreData

@objc(Users)
public class Users: NSManagedObject {

    convenience init(dictionary:NSDictionary, insertIntoManagedObjectContext context: NSManagedObjectContext) {
    
        let entityName = NSEntityDescription.entity(forEntityName: "Users", in: context)
        
        self.init(entity: entityName!, insertInto: context)
        
    }
    
    class func fetchUsersForEvent(event:Events) -> Users {
        
        let usersRequest: NSFetchRequest<Users> = Users.fetchRequest()
            usersRequest.predicate = NSPredicate(format: "events.event_id = %@", event.event_id!)
        
        do {
            let users = try context.fetch(usersRequest)
            
            for user in users {
                
                print(user.owner_name ?? "")
                
                return user
            }
            
        } catch {
            fatalError("Error Fetching Users")
        }
        
        return Users(context: context)
    }
}
