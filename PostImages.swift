//
//  PostImages.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/19/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData


class getImagesData: NSObject {
    
    class func getImagesFromFireBase(_ postKey:String?) {
        
        appDelegate.clearCoreData(entity: "PostImages")
        
        guard let postKey = postKey else {return}
        
        FirebaseRef.database.REF_PHOTO.child(postKey).observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let snapData = snapshot.value as? [String:AnyObject] {
                
                for(key, imageObj) in snapData  {
                    
                    if let imageObjDic = imageObj as? [String:AnyObject] {
                      
                        _ = getImagesData(postKey: postKey, imageKey: key, postImagesDic: imageObjDic)
                    }
                }
            }
        })
    }
    
    class func fetchUsers(poster:String, postImages:PostImages) {
        
        do {
            
            let request:NSFetchRequest<Users> = Users.fetchRequest()
            //request.predicate = NSPredicate(format: "posts.poster = %@", "FQiVFkjSDTb5FjJF1YdGjOl7uAy2")
            
            let usersArray = try(context.fetch(request))
            
            let f = usersArray.filter({$0.userKey == poster})
            
            for user in f {
                
                postImages.users = user
            }
            
        } catch let err {
            print(err)
        }
    }

    init(postKey:String, imageKey:String, postImagesDic:Dictionary<String,AnyObject>) {
        
        let images = PostImages(context: context)
        
        images.imageKey = imageKey
        images.postKey = postKey
        
        if let imageURL = postImagesDic["ImgURL"] as? String {
            
            images.imageURL = imageURL
        }
        
        if let poster = postImagesDic["poster"] as? String {
            images.poster = poster
            
            getImagesData.fetchUsers(poster: poster, postImages: images)
        }
        
        if let caption = postImagesDic["description"] as? String {
            images.caption = caption
        }
        
        if let timePosted = postImagesDic["timePosted"] as? Double {
            images.timePosted = timePosted
        }
        
        do {
            
            try(context.save())
            
        } catch let err {
            print(err)
        }
    }
}
