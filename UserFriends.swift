//
//  FriendsVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/18/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.


import UIKit

class Tracking: SearchUsers {
 
    var key:String? = String()
    
    override func getAllUsers() {
        
        if let userKey = key {
            
            Users.getFriendsFromFB(userKey, friends: "Tracking") { (users) in
                
                if users.count == 0 {
                    self.handleErrorWhenNoUsers()
                    
                } else {
                    self.allUsers = users
                }
            }
        }
    }
}

class Trackers: SearchUsers {
    
    var key:String? = String()
    
    override func getAllUsers() {
        
        if let userKey = key {
            
            Users.getFriendsFromFB(userKey, friends: "Trackers") { (users) in
                
                if users.count == 0 {
                    self.handleErrorWhenNoUsers()
                    
                } else {
                    self.allUsers = users
                }
            }
        }
    }
}