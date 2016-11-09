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
    
    private var _postDescription:String?
    private var _address:String?
    private var _location:String?
    private var _postKey:String?
    private var _statusLight:Bool?
    private var _poster:String?
    private var _privacy:String?
    private var _tagged:[String:AnyObject]?
    private var _latitude:CLLocationDegrees?
    private var _longtitude:CLLocationDegrees?
    private var _timeStamp:NSNumber?
    private var _timeEnded:NSNumber?
    
    var user: Users!
    
    var postDescription: String? {
        return _postDescription
    }
    
    var address: String? {
        return _address
    }
    
    var location: String? {
        return _location
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
    
    var timeStamp:NSNumber? {
        return _timeStamp
    }
    
    var timeEnded:NSNumber? {
        return _timeEnded
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
        
        if let timePosted = dictionary["Time"] as? NSNumber {
            self._timeStamp = timePosted
        }
        
        if let timeEnded = dictionary["TimeEnded"] as? NSNumber {
            self._timeEnded = timeEnded
        }
    }
    
    
    class func getFeedPosts(_ refresher:UIRefreshControl ,completion: @escaping ([Posts], [PostImages]?) -> ()) {
        
        refresher.beginRefreshing()
        
        
        var usersPosts = [Posts]()
        FirebaseRef.database.REF_POSTS.observe(.value, with: {
            snapshot in
    
            usersPosts.removeAll()
            if let datas = snapshot.value as? [String:AnyObject] {
                
                for(key, userPosts) in datas {

                    let feedPostsDic = userPosts as! [String:AnyObject]
                    let posts = Posts(postKeys: key, dictionary: feedPostsDic)
                    
                    if posts.privacy == "Private" && posts.poster != FirebaseRef.database.currentUser.key {
                        
                        if let tagged = posts.tagged {
                            
                            if tagged[FirebaseRef.database.currentUser.key] != nil {
                                
                                usersPosts.append(posts)
                            }
                        }
                        
                    } else if posts.privacy == "Public" {
                        
                        usersPosts.append(posts)
                        
                    } else if posts.poster == FirebaseRef.database.currentUser.key {
                        
                        usersPosts.append(posts)
                    }
                    
                    guard let poster = posts.poster else {return}
                    
                    FirebaseRef.database.REF_USERS.child(poster).observe(.value, with: {
                        snapshot in
                        
                        if let snapData = snapshot.value {
                           
                            Users.getUsersDataFromFB(snapData as AnyObject, completion: { (users) in
                                
                                for user in users {
                                    
                                    posts.user = user
                                }
                                
                                if posts.privacy == "Friends" && posts.poster != FirebaseRef.database.currentUser.key {
                                    
                                    if let trackers = posts.user?.trackers {
                                        
                                        if trackers[FirebaseRef.database.currentUser.key] != nil {
                                            
                                            usersPosts.append(posts)
                                        }
                                    }
                                }
                                
                                guard let postKey = posts.postKey else {return}
                                
                                PostImages.getPostImagesData(postKey, completion: { (postImages) in
                                    
                                    let sortedPosts = usersPosts.sorted(by: { (post1, post2) -> Bool in
                                        
                                        return (post1.timeStamp?.int32Value)! > (post2.timeStamp?.int32Value)!
                                    })
                                    
                                    let sortedImages = postImages.sorted(by: { (image1, image2) -> Bool in
                                        
                                        return (image1.timePosted?.int32Value)! > (image2.timePosted?.int32Value)!
                                    })
                                    
                                    DispatchQueue.main.async(execute: {
                                        completion(sortedPosts, sortedImages)
                                        
                                        refresher.endRefreshing()
                                    })
                                })
                            })
                        }
                    })
                }
                
            } else {
                
                DispatchQueue.main.async(execute: {
                    completion(usersPosts, nil)
                    
                    refresher.endRefreshing()
                })
            }
        })
    }
    
    class func getTaggedUsers(_ data:[String:AnyObject] ,completion: @escaping ([Users]) -> ()) {
        
        var usersWith = [Users]()
        for key in data.keys {
            
            FirebaseRef.database.REF_USERS.child(key).observe(.childAdded, with: {
                snapshot in
                
                let usersDic = snapshot.value as! [String:AnyObject]
                
                let users = Users(userKey: key, userDictionary: usersDic)
                
                usersWith.append(users)
                
                DispatchQueue.main.async(execute: {
                    completion(usersWith)
                })
            })
        }
    }
}
