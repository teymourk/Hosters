//
//  FriendsVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/18/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.


import UIKit
import CoreData

class Tracking: SearchUsers {
 
    var key:String? = String()
    
    override func viewDidLoad() {
        
        if let userKey = key {
            setupTableView()
            
            let predicate = NSPredicate(format: "userKey == %@", userKey)
            fetchUsersFromData(userPredicate: predicate)
        }
    }
}

class Trackers: SearchUsers {
    
    var key:String? = String()
    
    override func viewDidLoad() {
        
        if let userKey = key {
            
            setupTableView()
            let predicate = NSPredicate(format: "userKey == %@", userKey)
            fetchUsersFromData(userPredicate: predicate)
        }
    }
}
