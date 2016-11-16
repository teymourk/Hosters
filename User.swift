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
        
        FirebaseRef.database.REF_USERS.observe(.value, with: {
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
        
        if let likes = userDictionary["likes"] as? Int {
            users.likes = Int16(likes)
        }
    
        do {
            try(context.save())
            
        } catch let err {
            print(err)
        }
    }
}

