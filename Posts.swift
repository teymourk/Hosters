//
//  Posts.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/14/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import Firebase

class getPostsData: NSObject {
    
    class func getPostsFromFireBase() {
        
        appDelegate.clearCoreData(entity: "Posts")
        
        FirebaseRef.database.REF_POSTS.observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let snapData = snapshot.value as? [String:AnyObject] {
                
                for(key, postObj) in snapData {
                    
                    if let postObjDic = postObj as? [String:AnyObject] {
                        
                        _ = getPostsData(postKeys: key, dictionary: postObjDic)
                        _ = getImagesData.getImagesFromFireBase(key)
                    }
                }
            }
        })
    }
    
    class func fetchUsers(poster:String, post:Posts) {
        
        do {
            let request:NSFetchRequest<Users> = Users.fetchRequest()
                //request.predicate = NSPredicate(format: "posts.poster = %@", "FQiVFkjSDTb5FjJF1YdGjOl7uAy2")
            
            let usersArray = try(context.fetch(request))
            
            let filteredUsers = usersArray.filter({$0.userKey == poster})
            
            for user in filteredUsers {
                
                post.users = user
            }
            
        } catch let err {
            print(err)
        }
    }

    init(postKeys:String, dictionary: Dictionary<String, AnyObject>) {
        
        let posts = Posts(context: context)
        let taggedUsers = TaggedUsers(context: context)
        
        posts.postKey = postKeys
        taggedUsers.postKey = postKeys
        
        if let description = dictionary["Description"] as? String {
            posts.postDescription = description
        }
        
        if let location = dictionary["Location"] as? String {
            posts.location = location
        }
        
        if let address = dictionary["Address"] as? String {
            posts.address = address
        }
    
        if let status = dictionary["Status"] as? Bool {
            posts.status = status
        }
        
        if let poster = dictionary["Poster"] as? String {
            posts.poster = poster
            
            getPostsData.fetchUsers(poster: poster, post: posts)
        }
        
        if let privacy = dictionary["Privacy"] as? String {
            posts.privacy = privacy
        }
        
        if let timePosted = dictionary["Time"] as? Double {
            posts.timePosted = timePosted
        }
        
        if let timeEnded = dictionary["TimeEnded"] as? Double {
            posts.timeEnded = timeEnded
        }
        
        if let latitude = dictionary["Latitude"] as? Double {
            posts.latitude = latitude
        }
        
        if let longtitude = dictionary["Longtitude"] as? Double {
            posts.longtitude = longtitude
        }
        
        let tagUsers = TaggedUsers(context: context)
        var tag = Set<TaggedUsers>()
        
        if let tagedUsers = dictionary["Tagged"] as? [String:AnyObject] {
         
            for key in tagedUsers.keys {
                
                tagUsers.postKey = postKeys
                tagUsers.userKey = key
                
                tag.insert(tagUsers)
                
                posts.tagged = tag as NSSet?
            }
        }
        
        do {
            
            try(context.save())
            
        } catch let err {
            print(err)
        }
    }
}

