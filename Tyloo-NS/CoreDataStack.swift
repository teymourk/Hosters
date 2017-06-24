//
//  CoreData.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData

import Foundation
import CoreData

class CoreDataStack {
    
    static let coreData = CoreDataStack()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TylooModels")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    internal func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    internal func deleteRecords() {
        
        let eventsRequest:NSFetchRequest<Events> = Events.fetchRequest()
        let imagesRequest:NSFetchRequest<PostImages> = PostImages.fetchRequest()
        
        var deleteRequest:NSBatchDeleteRequest
        var deleteResults:NSPersistentStoreResult
        
        do {
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: eventsRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try context.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: imagesRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try context.execute(deleteRequest)
            
        } catch {
            fatalError("Failed To Remove Existing Record")
        }
    }
}
