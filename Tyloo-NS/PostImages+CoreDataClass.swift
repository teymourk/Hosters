//
//  PostImages+CoreDataClass.swift
//  
//
//  Created by Kiarash Teymoury on 6/18/17.
//
//

import Foundation
import CoreData
import Firebase

@objc(PostImages)
public class PostImages: NSManagedObject {

    convenience init(imageKey:String, dictionary:NSDictionary, insertIntoManagedObjectContext context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "PostImages", in: context)
        
        self.init(entity: entity!, insertInto: context)
        
        self.imageKey = imageKey
        
        if let ImgURL = dictionary["ImgURL"] as? String { self.imageURL = ImgURL}
    }
    
    class func fetchEventImages(event:Events) -> [PostImages] {
        
        let imagesRequest:NSFetchRequest<PostImages> = PostImages.fetchRequest()
            imagesRequest.predicate = NSPredicate(format: "events.event_id = %@", event.event_id!)
        
        do {
            
            let images = try context.fetch(imagesRequest)
            
            return images
            
        } catch {
            fatalError("Error Fetching Sale History")
        }
    }
}
