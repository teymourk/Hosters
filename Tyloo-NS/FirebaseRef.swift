//
//  FirebaseRef.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/13/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase

let URL_BASE = Firebase(url: "https://tyloo.firebaseio.com")

class FirebaseRef {
    
    static let Fb = FirebaseRef()
    
    private var _REF_BASE  = Firebase(url: "\(URL_BASE)")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_PHOTO = Firebase(url: "\(URL_BASE)/Photos")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_USERS: Firebase {
     return _REF_USERS
    }
    
    var REF_POSTS: Firebase {
        return _REF_POSTS
    }
    
    var REF_PHOTO: Firebase {
        return _REF_PHOTO
    }

    var currentUser: Firebase {
        get {
            
            let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
            let user = FirebaseRef.Fb.REF_USERS.childByAppendingPath(uid)
            
            return user
        }
    }
    
    func createFireBaseUser(uid:String, user: Dictionary<String, String>) {
        
        REF_USERS.childByAppendingPath("\(uid)/user").setValue(user)
    }
}