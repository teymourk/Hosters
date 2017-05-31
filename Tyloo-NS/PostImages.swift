//
//  PostImages.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/21/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class PostImages: NSObject {

    
    private var _imageKey:String?
    private var _imageURL:String?
    private var _poster:String?
    private var _timePosted:Double?

    var imageKey:String? {
        return _imageKey
    }
    
    var imageURL:String? {
        return _imageURL
    }
    
    var poster:String? {
        return _poster
    }
    
    var timePosted:Double? {
        return _timePosted
    }
    
    init(postKey:String, imageKey:String, dictionary:NSDictionary) {
        
        self._imageKey = imageKey
        
        if let imageURL = dictionary["ImgURL"] as? String {
            
            self._imageURL = imageURL
        }
        
        if let poster = dictionary["poster"] as? String {
            self._poster = poster
            
        }
        
        if let timePosted = dictionary["timePosted"] as? Double {
            self._timePosted = timePosted
        }
    }
    
    class func fetchEventImagesFromFireBase(refresher:UIRefreshControl, postKey:String, eventImages: @escaping ([PostImages]) -> ()) {
        
        refresher.beginRefreshing()
        
        var imagesArray:[PostImages] = [PostImages]()
        
        FirebaseRef.database.REF_PHOTO.child(postKey).observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let snapData = snapshot.value as? [String:AnyObject] {
                
                print(snapData)
            }
            
            DispatchQueue.main.async {
                eventImages(imagesArray)
                refresher.endRefreshing()
            }
        })
    }
}
