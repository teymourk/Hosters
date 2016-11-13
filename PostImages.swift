//
//  PostImages.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/19/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit


class getImagesData: NSObject {
    
    class func getImagesFromFireBase(_ postKey:String?) {
        
        appDelegate.clearCoreData(entity: "PostImages")
        
        guard let postKey = postKey else {return}
        
        FirebaseRef.database.REF_PHOTO.child(postKey).observe(.value, with: {
            snapshot in
            
            if let snapData = snapshot.value as? [String:AnyObject] {
                
                for(key, imageObj) in snapData  {
                    
                    if let imageObjDic = imageObj as? [String:AnyObject] {
                     
                        _ = getImagesData(postKey: postKey, imageKey: key, postImagesDic: imageObjDic)
                    }
                }
            }
        })
    }

    init(postKey:String, imageKey:String, postImagesDic:Dictionary<String,AnyObject>) {
        
        let images = PostImages(context: context)
        
        images.imageKey = imageKey
        images.postKey = postKey
        
        if let imageURL = postImagesDic["ImgURL"] as? String {
            
            images.imageURL = imageURL
        }
        
        if let poster = postImagesDic["poster"] as? String {
            images.poster = poster
        }
        
        if let caption = postImagesDic["description"] as? String {
            images.caption = caption
        }
    }
}
