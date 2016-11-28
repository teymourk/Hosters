//
//  CurrentUser.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/14/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class getUsersData: NSObject {
    
    class func getUsersFromFireBase() {
        
        appDelegate.clearCoreData(entity: "Users")
        
        FirebaseRef.database.REF_USERS.observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let snapData = snapshot.value as? [String:AnyObject] {
             
                for(key, userObj) in snapData {
                    
                    if let userObjDic = userObj["user"] as? [String:AnyObject] {
                        
                       _ = getUsersData(userKey: key, userDictionary: userObjDic)
                    }
                }
            }
        })
    }
    
    init(userKey:String, userDictionary: Dictionary<String,AnyObject>) {
        
        let users = Users(context: context)
        
        users.userKey = userKey
        
        if let name = userDictionary["name"] as? String {
            users.name = name
        }
        
        if let username = userDictionary["username"] as? String {
            users.username = username
        }
        
        if let profileImage = userDictionary["profileImage"] as? String {
            users.profileImage = profileImage
        }
        
        let usersFollowers = Followers(context: context)
        var followersSet: Set<Followers> = Set<Followers>()
        
        if let trackers = userDictionary["Friends"]?["Trackers"] as? [String:AnyObject] {
            
            for userKey in trackers.keys {
                
                usersFollowers.userKey = userKey
                followersSet.insert(usersFollowers)
            }
            
            users.followers = followersSet as NSSet?
        }
        
        let usersFollowing = Following(context: context)
        var followingSet: Set<Following> = Set<Following>()
        
        if let tracking = userDictionary["Friends"]?["Tracking"] as? [String:AnyObject] {
            
            for key in tracking.keys {
                
                usersFollowing.userKey = key
                followingSet.insert(usersFollowing)
            }
            
            users.following = followingSet as NSSet?
        }
        
        do {
            try(context.save())
            
        } catch let err {
            print(err)
        }
    }
}

