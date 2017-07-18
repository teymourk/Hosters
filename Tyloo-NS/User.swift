//
//  CurrentUser.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/14/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase

class Users {

    private var _name: String?
    private var _userName:String?
    private var _profileImage:String?
    private var _likes:Int?
    private var _bio:String?
    private var _userKey:String?
        
    var name:String? {
        return _name
    }
    
    var username:String? {
        return _userName
    }
    
    var profileImage:String? {
        return _profileImage
    }
    
    var likes:Int? {
        return _likes
    }
    
    var bio:String? {
        return _bio
    }
    
    var userKey:String? {
        return _userKey
    }
    
    class func getUsersDataFromFB(userData: AnyObject, completion: ([Users]) -> ()){
        
        var usersArray = [Users]()
        
        if let users = userData as? [String:AnyObject] {
            
            for (key, userObj) in users {
                
                if key == "user" {
                    let users = Users(userKey: key, userDictionary: userObj as! [String:AnyObject])
                    usersArray.append(users)
                    
                } else {
                    
                    let dic = userObj["user"] as! [String:AnyObject]
                    let users = Users(userKey: key, userDictionary: dic)
                    usersArray.append(users)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completion(usersArray)
            })
        }
    }

    init(userKey:String, userDictionary: Dictionary<String,AnyObject>) {
        
        self._userKey = userKey
        
        if let name = userDictionary["name"] as? String {
            self._name = name
        }
        
        if let username = userDictionary["username"] as? String {
            self._userName = username
        }
        
        if let profileImage = userDictionary["profileImage"] as? String {
            self._profileImage = profileImage
        }
        
        if let likes = userDictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let bio = userDictionary["bio"] as? String {
            self._bio = bio
        }
    }
}