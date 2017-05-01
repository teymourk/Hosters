//
//  Users.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/26/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class Users: NSObject {

    private var _id:String?
    private var _profile_name:String?
    private var _profile_picture:String?
    private var _rsvp_status:String?
    
    var id:String? {
        return _id
    }
    
    var profile_name:String? {
        return _profile_name
    }
    
    var profile_pricture:String? {
        return _profile_picture
    }
    
    var rsvp_status:String? {
        return _rsvp_status
    }
    
    init(dictionary:NSDictionary) {
        
        if let id = dictionary["id"] as? String {
            self._id = id
        }
        
        if let name = dictionary["name"] as? String {
            self._profile_name = name
        }
        
        if let pictureDic = dictionary["picture"] as? NSDictionary, let data = pictureDic["data"] as? NSDictionary, let imageURL = data["url"] as? String {
            
            self._profile_picture = imageURL
        }
        
        if let rsvp_status = dictionary["rsvp_status"] as? String {
            self._rsvp_status = rsvp_status
        }
    }
}
