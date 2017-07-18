//
//  PostImages.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/19/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit


class PostImages {
    
    private var _poster:String?
    private var _imageURL:String?
    private var _likes:[String:AnyObject]?
    private var _ImagesKey:String?
    private var _description:String?
    
    var user:Users!
    
    var poster:String? {
        return _poster
    }
    
    var imageURL:String? {
        return _imageURL
    }
    
    var imageKey:String? {
        return _ImagesKey
    }
    
    var likes:[String:AnyObject]? {
        return _likes
    }
    
    var description:String? {
        return _description
    }
    
    init(imageKey:String, postImagesDic:Dictionary<String,AnyObject>) {
        
        self._ImagesKey = imageKey
        
        if let imageURL = postImagesDic["ImgURL"] as? String {
            self._imageURL = imageURL
        }
        
        if let likes = postImagesDic["likes"] as? [String:AnyObject] {
            self._likes = likes
        }
        
        if let poster = postImagesDic["poster"] as? String {
            self._poster = poster
        }
        
        if let description = postImagesDic["description"] as? String {
            self._description = description
        }
    }
    
    class func getAllPhotos(completion: ([PostImages])-> ()) {
    
        var imagesArray = [PostImages]()
        
        FirebaseRef.Fb.REF_PHOTO.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            if let images = snapshot.value as? [String:AnyObject] {
                
                for imagesData in images.values {
                    
                    for(key, imagesDic) in imagesData as! [String:AnyObject] {
                        
                        let images = PostImages(imageKey: key, postImagesDic: imagesDic as! [String:AnyObject])
                        
                        imagesArray.append(images)
                        
                        //FilterOut the ones that arent the current users
                        let filteredImages = imagesArray.filter({$0._poster != currentUser.key})
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(filteredImages)
                        })
                    }
                }
            }
        })
    }
    
    class func getPostImagesData(postKey:String, completion: (([PostImages]) -> Void)) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            FirebaseRef.Fb.REF_PHOTO.childByAppendingPath(postKey).observeEventType(.Value, withBlock: {
                snapshot in
                
                let postDic = snapshot.value as? [String:AnyObject]
                var imagesArray = [PostImages]()
                
                if let postsDic = postDic {
                    
                    for(key, posts) in postsDic {
                        
                        let images = PostImages(imageKey: key, postImagesDic: posts as! [String:AnyObject])
                        
                        FirebaseRef.Fb.REF_USERS.childByAppendingPath(images.poster).observeSingleEventOfType(.Value, withBlock: {
                            snapshot in
                            
                            Users.getUsersDataFromFB(snapshot.value, completion: { (users) in
                                
                                for user in users {
                                    
                                    images.user = user
                                    imagesArray.append(images)
                                }
                            })
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                completion(imagesArray)
                            }
                        })
                    }
                } 
            })
        })
    }
}