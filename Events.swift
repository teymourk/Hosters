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
import FBSDKCoreKit

class Events: NSObject {
    
    private var _event_id:String?
    private var _name:String?
    private var _description:String?
    private var _coverURL:String?
    private var _ownr_name:String?
    private var _start_time:Date?
    private var _rsvp_status:String?
    
    var name:String? {
        return _name
    }
    
    var descriptions:String? {
        return _description
    }
    
    var coverURL:String? {
        return _coverURL
    }
    
    var owner_name:String? {
        return _ownr_name
    }
    
    var start_time:Date? {
        return _start_time
    }
    
    var rsvp_status:String? {
        return _rsvp_status
    }
    
    init(event_id:String, dictionary:NSDictionary) {
        
        
        self._event_id = event_id
        
        if let name = dictionary["name"] as? String {
            self._name = name
        }
        
        if let description = dictionary["description"] as? String {
            self._description = description
        }
        
        if let coverDic = dictionary["cover"] as? NSDictionary, let coverSource = coverDic["source"] as? String {
            self._coverURL = coverSource
        }
        
        if let ownerDic = dictionary["owner"] as? NSDictionary, let owner_name = ownerDic["name"] as? String {
            self._ownr_name = owner_name
        }
        
        if let start_time = dictionary["start_time"] as? String {
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
            
            if let date = dateFormatter.date(from: start_time) {
             
                self._start_time = date
            }
        }
    }
    
    class func fetchEventsFromFacebook(refresher:UIRefreshControl, type:String, completion: @escaping ([[Events]]) -> ()) {

        refresher.beginRefreshing()
        var eventsArray:[[Events]] = [[Events]]()

        let parameters = ["fields": "cover, attending_count, can_guests_invite, description, name, id, maybe_count, noreply_count, interested_count, start_time, declined_count, owner, place, rsvp_status"]
        
        FBSDKGraphRequest(graphPath: "/me/events/\(type)", parameters: parameters).start { (connection, results, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            if let result = results as? NSDictionary, let dataArray = result["data"] as? NSArray {
                
                var i = 0
                let currentDate = Date()
                
                for arrayObj in dataArray {
                    
                    i = i + 1
                    
                    if let dataDic = arrayObj as? NSDictionary, let id = dataDic["id"] as? String {
                        
                        let eventsObj = Events(event_id: id, dictionary: dataDic)
                        
                        if currentDate < eventsObj.start_time! {
                            
                            eventsArray.insert([eventsObj], at: 0)
                    
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(eventsArray)
                    refresher.endRefreshing()
                }
            }
        }
    }
}

