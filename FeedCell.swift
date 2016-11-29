//
//  FriendsFeedCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/12/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MapKit

class FeedCell: BaseCell, CLLocationManagerDelegate {
    var postsDetails:Posts? {
        didSet {
            
            guard let posts = postsDetails else {return}
            
            placeDetails.postTitle.text = posts.postDescription
            placeDetails.location.text = posts.location
            
            posts.rating.setRating(image: placeDetails.ratingIcon)
            
            if let photoRefrence = posts.photoRefrence {
                
                let url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoRefrence)&key=AIzaSyC4StcqHSO6EuYx56D_mCoUJBCwvHSo8Xo"
                
                placeDetails.locationIcon.getImagesBack(url: url, placeHolder: "Profile")
            }
        }
    }
    
    var friendsFeedView:HomePage?
    
    lazy var feedAllPhotosVC:PicturesInsideCell = {
        let fp = PicturesInsideCell()
            fp.feedCell = self
            fp.alpha = 0.7
        return fp
    }()
    
    var allphotosFeedHeight:NSLayoutConstraint?
    
    var placeDetails:PlaceDetails = {
        let pd = PlaceDetails()
        return pd
    }()

    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        addSubview(feedAllPhotosVC)
        addSubview(placeDetails)
        
        //FeedAllphotosVC Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: feedAllPhotosVC)
        addConstrainstsWithFormat("V:|-15-[v0]", views: feedAllPhotosVC)
        
        allphotosFeedHeight = NSLayoutConstraint(item: feedAllPhotosVC, attribute: .height, relatedBy: .equal, toItem: feedAllPhotosVC, attribute: .height, multiplier: 0, constant: 175)
        
        guard let height = allphotosFeedHeight else {return}
        
        self.addConstraint(height)
        
        addConstrainstsWithFormat("H:|-5-[v0]-5-|", views: placeDetails)
        addConstrainstsWithFormat("V:[v0(100)]-5-|", views: placeDetails)
    }
}









