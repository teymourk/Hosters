//
//  FirebaseRef.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/13/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

let URL_BASE = Database.database().reference()

class FirebaseRef {
    
    static let database = FirebaseRef()
    
    fileprivate var _REF_BASE  = URL_BASE
    fileprivate var _REF_USERS = URL_BASE.child("users")
    fileprivate var _REF_POSTS = URL_BASE.child("posts")
    fileprivate var _REF_PHOTO = URL_BASE.child("Photos")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
        
    }
    
    var REF_USERS: DatabaseReference {
     return _REF_USERS
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_PHOTO: DatabaseReference {
        return _REF_PHOTO
    }

    var currentUser: DatabaseReference {
        get {
            
            if let userID = FBSDKAccessToken.current().userID {
             
                let user = FirebaseRef.database.REF_USERS.child(userID)
                
                return user
            }
            
            return DatabaseReference()
        }
    }
    
    func createFireBaseUser(_ uid:String, user: Dictionary<String, AnyObject>) {
        
        REF_USERS.child("\(uid)/user").setValue(user)
    }
}
