//
//  EventFetch.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/22/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import FBSDKLoginKit

class Facebook_MyEvents: NSObject {

    static let facebookFetch = Facebook_MyEvents()
    
    internal func loadDataFromFacebook(nearOrmeFor event:String) {
        
        let parameters = ["fields": "cover, attending_count, can_guests_invite, description, name, id, maybe_count, noreply_count, interested_count, start_time , end_time, declined_count, owner, place, rsvp_status, guest_list_enabled", "limit": "10"]
        
        var types:[Events_Entities_Types] = [.not_replied, .attending, .maybe]
        
        for i in 0..<types.count {
        
            let type = types[i]
            
            let graphPath  = "/\(event)/events/\(type.rawValue)"
            
        
            FBSDKGraphRequest(graphPath: graphPath, parameters: parameters).start { (connection, results, error) in
                
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                if let result = results as? NSDictionary, let dataArray = result["data"] as? NSArray {
            
                    for arrayObj in dataArray {
                    
                        if let eventsDic = arrayObj as? NSDictionary {
                            
                            let eventsObj = Events(dictionary: eventsDic, insertIntoManagedObjectContext: context)
                            
                            let users = Users(dictionary: eventsDic, insertIntoManagedObjectContext: context)
                            
                            guard let event_id = eventsObj.event_id, let startTime = eventsObj.start_time as Date?, let endTime = eventsObj.end_time as Date? else {return}
                            
                            //Set event isLive Status
                            self.handleSettingEventLiveStatus(event: eventsObj, startTime: startTime, endTime: endTime)
                            
                            FirebaseRef.database.REF_PHOTO.child(event_id).observeSingleEvent(of: .value, with: {
                                snapshot in
                                
                                if let snapData = snapshot.value as? [String:AnyObject] {
                                    
                                    for(key, imageObj) in snapData  {
                                        
                                        if let imageObjDic = imageObj as? NSDictionary {
                                            
                                            let imgObj = PostImages(imageKey: key, dictionary: imageObjDic, insertIntoManagedObjectContext: context)
                                            
                                            eventsObj.addToPostImages(imgObj)
                                            eventsObj.addToUsers(users)
                                        }
                                    }
                                }
                            })
                        }
                    }
                        
                    CoreDataStack.coreData.saveContext()
                }
            }
        }
    }
    
    fileprivate func handleSettingEventLiveStatus(event:Events,startTime:Date, endTime:Date) {
        
        //Event Hasnt Happend
        if Date() < startTime {
            event.isLive = 1
        }
        
        //Event Endded
        if Date() > endTime {
            
            event.isLive = 2
            
        //Event Is Live
        } else if Date() > startTime && Date() < endTime {
            
            event.isLive = 3
        }
    }
}
