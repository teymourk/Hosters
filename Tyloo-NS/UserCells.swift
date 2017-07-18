//
//  UserCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/14/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.

import UIKit

class UsersCells: BaseTCell {
    
    var users:Users? {
        didSet {
            
            if let username = users?.username {
                _username.text = username
            }
            
            if let name = users?.name {
                _name.text = name
            }
            
            if let likes = users?.likes {
                _likes.text = "\(likes) Likes"
            }
            
            if let profileImageURL = users?.profileImage {
                _profileImage.getImagesBack(profileImageURL, placeHolder: "Profile", loader: UIActivityIndicatorView())
            }
        }
    }
    
    var _profileImage:UIImageView = {
        
        let image = UIImageView()
            image.layer.masksToBounds = true
            image.layer.cornerRadius = 20
            image.layer.borderWidth = 1
            image.layer.borderColor = UIColor.orangeColor().CGColor
        return image
    }()
    
    var _username:UILabel = {
        let label = UILabel()
            label.font = UIFont.boldSystemFontOfSize(13)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var _name:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var _likes:UILabel = {
        let label = UILabel()
            label.font = UIFont.systemFontOfSize(12)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var _follow_following:UIButton = {
        let button = UIButton(type: .System)
            button.setTitle("Following", forState: .Normal)
            button.setTitleColor(.whiteColor(), forState: .Normal)
            button.backgroundColor = UIColor(white: 0.85, alpha: 1)
        return button
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(_profileImage)
        addSubview(_likes)
        addSubview(_username)
        addSubview(_name)
        addSubview(_follow_following)
        
        //ProfileImage Cosntraints
        addConstrainstsWithFormat("H:|-10-[v0(40)]", views: _profileImage)
        addConstrainstsWithFormat("V:|-10-[v0(40)]", views: _profileImage)
        
        //userName Constraints
        addConstrainstsWithFormat("H:[v0]-170-|", views: _username)
        addConstrainstsWithFormat("V:|-10-[v0(20)]", views: _username)
        
        
        //Right of ProfileImage
        addConstraint(NSLayoutConstraint(item: _username, attribute: .Left, relatedBy: .Equal, toItem: _profileImage, attribute: .Right, multiplier: 1, constant: 5))
        
        //Full Name Constraints
        addConstrainstsWithFormat("H:[v0]", views: _name)
        addConstrainstsWithFormat("V:[v0(15)]", views: _name)
        
        //Top
        addConstraint(NSLayoutConstraint(item: _name, attribute: .Top, relatedBy: .Equal, toItem: _username, attribute: .Bottom, multiplier: 1, constant: 2))
        
        //Right of ProfileImage
        addConstraint(NSLayoutConstraint(item: _name, attribute: .Left, relatedBy: .Equal, toItem: _profileImage, attribute: .Right, multiplier: 1, constant: 5))
        
        //like
        addConstrainstsWithFormat("H:|-14-[v0]", views: _likes)
        
        //Below of name
        addConstraint(NSLayoutConstraint(item: _likes, attribute: .Top, relatedBy: .Equal, toItem: _profileImage, attribute: .Bottom, multiplier: 1, constant: 6))
    
    
        //Follow/Unfollow Constraints
        addConstrainstsWithFormat("H:[v0(90)]-20-|", views: _follow_following)
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: _follow_following, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    }
}
