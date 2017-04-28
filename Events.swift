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
    private var _place_name:String?
    private var _latitude:Double?
    private var _longtitude:Double?
    private var _state:String?
    private var _city:String?
    private var _street:String?
    private var _zip:String?
    private var _interested_count:Int?
    private var _declined_count:Int?
    private var _attending_count:Int?
    
    var event_id:String? {
        return _event_id
    }
    
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
    
    var place_name:String? {
        return _place_name
    }
    
    var latitude:Double? {
        return _latitude
    }
    
    var longtitude:Double? {
        return _longtitude
    }
    
    var state:String? {
        return _state
    }
    
    var city:String? {
        return _city
    }
    
    var street:String? {
        return _street
    }
    
    var zip:String? {
        return _zip
    }
    
    var interested_count:Int? {
        return _interested_count
    }
    
    var declined_count:Int? {
        return _declined_count
    }
    
    var attending_count:Int? {
        return _attending_count
    }
    
    init(dictionary:NSDictionary) {
        
        
        if let id = dictionary["id"] as? String {
            self._event_id = id
        }
        
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
        
        if let rsvp_status = dictionary["rsvp_status"] as? String {
            
            self._rsvp_status = rsvp_status
        }
        
        if let interestedCount = dictionary["interested_count"] as? Int, let declinedCount = dictionary["declined_count"] as? Int, let attendingCount = dictionary["attending_count"] as? Int {
            
            self._interested_count = interestedCount
            self._declined_count = declinedCount
            self._attending_count = attendingCount
        }
        
        
        if let start_time = dictionary["start_time"] as? String {
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
            
            if let date = dateFormatter.date(from: start_time) {
             
                self._start_time = date
            }
        }
        
        if let place = dictionary["place"] as? NSDictionary, let location = place["location"] as? NSDictionary, let place_name = place["name"] as? String, let state = location["state"] as? String, let city = location["city"] as? String {
            
            self._place_name = place_name
            self._state = state
            self._city = city
        }
    }
    
    class func fetchEventsFromFacebook(refresher:UIRefreshControl, type:String, completion: @escaping ([Events]) -> ()) {

        refresher.beginRefreshing()
        var eventsArray:[Events] = [Events]()
        
        let parameters = ["fields": "cover, attending_count, can_guests_invite, description, name, id, maybe_count, noreply_count, interested_count, start_time, declined_count, owner, place, rsvp_status"]
        
        FBSDKGraphRequest(graphPath: "/me/events/\(type)", parameters: parameters).start { (connection, results, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            if let result = results as? NSDictionary, let dataArray = result["data"] as? NSArray {
                
                let currentDate = Date()
                
                for arrayObj in dataArray {
                    
                    if let dataDic = arrayObj as? NSDictionary, let event_id = dataDic["id"] as? String {
                        
                        let eventsObj = Events(dictionary: dataDic)
                        
                        if currentDate < eventsObj.start_time! {
                            
                            eventsArray.append(eventsObj)
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(eventsArray)
                refresher.endRefreshing()
            }
        }
    }
    
    class func fetchGuestlist(eventId:String, type:String, completion: @escaping (NSDictionary) -> ()) {
        
        let parameters = ["fields": "name, picture, rsvp_status"]
        
        FBSDKGraphRequest(graphPath: "/\(eventId)/\(type)", parameters: parameters).start { (connection, results, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            if let result = results as? NSDictionary, let guestArray = result["data"] as? NSArray {
                
                for arrayObj in guestArray {
                    
                    if let guestDic = arrayObj as? NSDictionary {
                        
                        completion(guestDic)
                    }
                }
            }
        }
    }
}

