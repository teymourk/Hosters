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
    private var _postKey:String?
    private var _timePosted:NSNumber?
    
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
    
    var timePosted:NSNumber? {
        return _timePosted
    }
    
    var likes:[String:AnyObject]? {
        return _likes
    }
    
    var description:String? {
        return _description
    }
    
    var postKey:String? {
        return _postKey
    }
    
    init(postKey:String, imageKey:String, postImagesDic:Dictionary<String,AnyObject>) {
        
        self._ImagesKey = imageKey
        self._postKey = postKey
        
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
        
        if let timePosted = postImagesDic["timePosted"] as? NSNumber {
            self._timePosted = timePosted
        }
    }
    
    class func getPostImagesData(_ postKey:String?, completion: @escaping (([PostImages]) -> Void)) {
        
        FirebaseRef.database.REF_PHOTO.child(postKey!).observe(.value, with: {
            snapshot in
            
            let postDic = snapshot.value as? [String:AnyObject]
            var imagesArray = [PostImages]()
            
            if let postsDic = postDic {
                
                for(key, posts) in postsDic {
                    
                    let images = PostImages(postKey: snapshot.key,imageKey: key, postImagesDic: posts as! [String:AnyObject])
                    
                    FirebaseRef.database.REF_USERS.child(images.poster!).observeSingleEvent(of: .value, with: {
                        snapshot in
                        
                        Users.getUsersDataFromFB(snapshot.value! as AnyObject, completion: { (users) in
                            
                            for user in users {
                                
                                images.user = user
                                imagesArray.append(images)
                            }
                        })
                        
                        DispatchQueue.main.async {
                            completion(imagesArray)
                        }
                    })
                }
                
            } else {
                
                imagesArray.removeAll()
                DispatchQueue.main.async {
                    completion(imagesArray)
                    
                }
            }
        })
    }
}
