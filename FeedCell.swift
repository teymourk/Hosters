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
            guard let users = postsDetails?.users else {return}
            
            placeDetails.postTitle.text = posts.postDescription
            placeDetails.location.text = posts.location
            placeDetails.rating.text = "Rating: \(posts.rating)"
            
            //UsersDetails
            usernameLabel.text = users.username
            
            let active = UIImage(named: "ok_filled")
            let time = UIImage(named: "clock-1")
            
            let timeStamp = Date(timeIntervalSince1970: posts.timeEnded)
            
            activeLabel.text = posts.status == true ? "Active" : "Ended \(timeStamp.Time()) ago"
            activeImage.image = posts.status == true ? active : time
            
            if let imageURl = users.profileImage {
                profileImage.getImagesBack(url: imageURl, placeHolder: "Profile")
            }
            
            if let photoRefrence = posts.photoRefrence {
                
                let url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoRefrence)&key=AIzaSyC4StcqHSO6EuYx56D_mCoUJBCwvHSo8Xo"
                
                placeDetails.locationIcon.getImagesBack(url: url, placeHolder: "Profile")
            }
        }
    }
    
    var activeLabel:UILabel = {
        let label = UILabel()
            label.textAlignment = .right
            label.textColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    var activeImage:UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var profileImage:UIImageView = {
        let image = UIImageView()
            image.layer.cornerRadius = 15
            image.layer.borderWidth = 0.5
            image.layer.borderColor = darkGray.cgColor
            image.layer.masksToBounds = true
            image.isUserInteractionEnabled = true
            image.contentMode = .scaleAspectFill
            image.tag = 0
        return image
    }()
    
    var usernameLabel:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.font =  UIFont(name: "NotoSans", size: 14)
        return label
    }()
    
//    var arrowIndicatior:UIImageView = {
//        let image = UIImageView()
//            image.image = UIImage(named: "righArrow")
//        return image
//    }()
    
    lazy var menuOptions:UIButton = {
        let menu = UIButton()
            menu.setTitle("...", for: .normal)
            menu.addTarget(self, action: #selector(onMenu(_ :)), for: .touchUpInside)
        return menu
    }()
    
    let bottomDataSeperator:UIView = {
        let view = UIView()
            view.backgroundColor = .lightGray
        return view
    }()
    
    var friendsFeedView:HomePage?
    
    lazy var feedAllPhotosVC:PicturesInsideCell = {
        let fp = PicturesInsideCell()
            fp.feedCell = self
            fp.alpha = 0.7
        return fp
    }()
    
    var allphotosFeedHeight:NSLayoutConstraint?
        
    func onMenu(_ sender:UIButton) {
        
        friendsFeedView?.onMenuOptions(sender)
    }
    
    var placeDetails:PlaceDetails = {
        let pd = PlaceDetails()
        return pd
    }()

    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        addSubview(feedAllPhotosVC)
        addSubview(profileImage)
        addSubview(usernameLabel)
        //addSubview(arrowIndicatior)
        addSubview(menuOptions)
        addSubview(activeLabel)
        addSubview(activeImage)        
        addSubview(bottomDataSeperator)
        addSubview(placeDetails)
        
        //Active Image Constraints
        addConstrainstsWithFormat("H:[v0(15)]-10-|", views: activeImage)
        addConstrainstsWithFormat("V:|-5-[v0(15)]", views: activeImage)
        
        //Active Label
        addConstrainstsWithFormat("H:[v0(300)]", views: activeLabel)
        addConstrainstsWithFormat("V:[v0]", views: activeLabel)
        
        //Active Label right
        addConstraint(NSLayoutConstraint(item: activeLabel, attribute: .right, relatedBy: .equal, toItem: activeImage, attribute: .left, multiplier: 1, constant: -4))
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: activeLabel, attribute: .centerY, relatedBy: .equal, toItem: activeImage, attribute: .centerY, multiplier: 1, constant: 0))
        
        
        //FeedAllphotosVC Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: feedAllPhotosVC)
        addConstrainstsWithFormat("V:|-45-[v0]", views: feedAllPhotosVC)
        
        allphotosFeedHeight = NSLayoutConstraint(item: feedAllPhotosVC, attribute: .height, relatedBy: .equal, toItem: feedAllPhotosVC, attribute: .height, multiplier: 0, constant: 192)
        
        guard let height = allphotosFeedHeight else {return}
        
        self.addConstraint(height)
        
        //ProfileImage Cosntraints
        addConstrainstsWithFormat("H:|-10-[v0(30)]", views: profileImage)
        addConstrainstsWithFormat("V:|-5-[v0(30)]", views: profileImage)
        
        //username Cosntraints
        addConstrainstsWithFormat("H:[v0]|", views: usernameLabel)
        addConstrainstsWithFormat("V:[v0]", views: usernameLabel)
        
        //Left
        addConstraint(NSLayoutConstraint(item: usernameLabel, attribute: .left, relatedBy: .equal, toItem: profileImage, attribute: .right, multiplier: 1, constant: 7))
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: usernameLabel, attribute: .centerY, relatedBy: .equal, toItem: profileImage, attribute: .centerY, multiplier: 1, constant: 5))
        
        //Bottom Constraint
        addConstrainstsWithFormat("H:|[v0]|", views: bottomDataSeperator)
        addConstrainstsWithFormat("V:[v0(1.5)]|", views: bottomDataSeperator)
        
        addConstrainstsWithFormat("H:|-10-[v0]-10-|", views: placeDetails)
        addConstrainstsWithFormat("V:[v0(100)]-5-|", views: placeDetails)
        
        addConstrainstsWithFormat("H:[v0]-10-|", views: menuOptions)
        addConstrainstsWithFormat("V:|-20-[v0]", views: menuOptions)
    }
}









