//
//  Posts.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/14/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class Posts {
    
    private var _postDescription:String!
    private var _address:String!
    private var _location:String!
    private var _backGround:String!
    private var _postKey:String!
    private var _statusLight:Bool!
    private var _poster:String!
    private var _privacy:String!
    private var _tagged:[String:AnyObject]!
    private var _latitude:CLLocationDegrees!
    private var _longtitude:CLLocationDegrees!
    
    
    var user: Users!
    
    var postDescription: String {
        return _postDescription
    }
    
    var address: String? {
        return _address
    }
    
    var location: String?{
        return _location
    }
    
    var backGround: String? {
        return _backGround
    }
    
    var statusLight: Bool? {
        return _statusLight
    }
    
    var postKey: String? {
        return _postKey
    }
    
    var poster: String? {
        return _poster
    }
    
    var privacy:String? {
        return _privacy
    }
    
    var tagged:[String:AnyObject]? {
        return _tagged
    }
    
    var latitude:CLLocationDegrees? {
        return _latitude
    }
    
    var longitude:CLLocationDegrees? {
        return _longtitude
    }
    
    init(postKeys:String, dictionary: Dictionary<String, AnyObject>) {
        
        self._postKey = postKeys
        
        if let activityDescription = dictionary["Description"] as? String {
            self._postDescription = activityDescription
        }
        
        if let location = dictionary["Location"] as? String {
            self._location = location
        }
        
        if let address = dictionary["Address"] as? String {
            self._address = address
        }
        
        if let latitude = dictionary["Latitude"] as? CLLocationDegrees {
            self._latitude = latitude
        }
        
        if let longtitude = dictionary["Longtitude"] as? CLLocationDegrees {
            self._longtitude = longtitude
        }
        
        if let imageURL = dictionary["ImgURL"] as? String {
            self._backGround = imageURL
        }
        
        if let statusLight = dictionary["Status"] as? Bool {
            self._statusLight = statusLight
        }
        
        if let poster = dictionary["Poster"] as? String {
            self._poster = poster
        }
        
        if let privacy = dictionary["Privacy"] as? String {
            self._privacy = privacy
        }
        
        if let tagged = dictionary["Tagged"] as? [String:AnyObject] {
            self._tagged = tagged
        }
    }
    
    class func getFeedPosts(data:AnyObject?, completion: ([Posts],[Posts]) -> ()) {
        
        var feedPosts = [Posts]()
        var activePosts = [Posts]()
        
        if let datas = data as? [String:AnyObject] {
            
            for(key, userPosts) in datas {
                
                let feedPostsDic = userPosts as! [String:AnyObject]
                let posts = Posts(postKeys: key, dictionary: feedPostsDic)
                
                FirebaseRef.Fb.REF_USERS.childByAppendingPath(posts.poster).observeSingleEventOfType(.Value, withBlock: {
                    snapshot in
                    
                    Users.getUsersDataFromFB(snapshot.value, completion: { (users) in
                        
                        for user in users {
                            
                            posts.user = user
                            feedPosts.append(posts)
                        }
                        
                        activePosts = feedPosts.filter({$0.poster == currentUser.key})
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(feedPosts,activePosts)
                            
                        })
                    })
                })
            }
        }
    }
    
    class func getTaggedUsers(data:[String:AnyObject] ,completion: ([Users]) -> ()) {
        
        var usersWith = [Users]()
        for key in data.keys {
            
            FirebaseRef.Fb.REF_USERS.childByAppendingPath(key).observeSingleEventOfType(.ChildAdded, withBlock: {
                snapshot in
                
                let usersDic = snapshot.value as! [String:AnyObject]
                
                let users = Users(userKey: key, userDictionary: usersDic)
                
                usersWith.append(users)
                
                dispatch_async(dispatch_get_main_queue(), {
                    completion(usersWith)
                })
            })
        }
    }
}
