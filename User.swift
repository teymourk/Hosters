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
    private var _userKey:String?
    private var _trackers:[String:AnyObject]?
    private var _tracking:[String:AnyObject]?
        
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
    
    var userKey:String? {
        return _userKey
    }
    
    var trackers:[String:AnyObject]? {
        return _trackers
    }
    
    var tracking:[String:AnyObject]? {
        return _tracking
    }
    
    class func getUsersDataFromFB(_ userData: AnyObject, completion: @escaping ([Users]) -> ()){
        
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
            
            DispatchQueue.main.async(execute: {
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
        
        if let tracking = userDictionary["Friends"]?["Trackers"] as? [String:AnyObject] {
            self._trackers = tracking
        }
        
        if let tracking = userDictionary["Friends"]?["Tracking"] as? [String:AnyObject]? {
            self._tracking = tracking
        }
    }
    
    class func getFriendsFromFB(_ userKey:String, friends:String, completion: @escaping ([Users])->()) {
        
        var usersArray = [Users]()
        
        FirebaseRef.database.REF_USERS.child("\(userKey)/user/Friends/\(friends)").observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let userDic = snapshot.value as? [String:AnyObject] {
                for key in userDic.keys {
                    
                    FirebaseRef.database.REF_USERS.child(key).observeSingleEvent(of: .childAdded, with: {
                        snapshot in
                        
                        if let usersDic = snapshot.value as? [String:AnyObject] {
                            
                            let users = Users(userKey: key, userDictionary: usersDic)
                            usersArray.append(users)
                            
                            DispatchQueue.main.async(execute: {
                                completion(usersArray)
                            })
                        }
                    })
                }
                
            } else {
                
                DispatchQueue.main.async(execute: {
                    completion(usersArray)
                    
                    
                })
            }
        })
    }
}
