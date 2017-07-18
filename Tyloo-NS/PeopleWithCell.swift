//
//  PeopleWithCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/18/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class PeopleWithCell: BaseCell {
    
    var taggedUsers:Users? {
        didSet{
            
            if let profileImageURL = taggedUsers?.profileImage {
                _profileImage.getImagesBack(profileImageURL, placeHolder: "Profile", loader: UIActivityIndicatorView())
            }
            
            if let username = taggedUsers?.username {
                _username.text = username
        
            }
        }
    }
    
    var _profileImage:UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 23
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.blackColor().CGColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var _username:UILabel = {
        let label = UILabel()
        label.textColor = .blackColor()
        label.textAlignment = .Center
        label.font = UIFont.boldSystemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(_profileImage)
        addSubview(_username)
                
        //ProfileImage Constraints
        addConstrainstsWithFormat("H:[v0(46)]", views: _profileImage)
        addConstrainstsWithFormat("V:[v0(46)]", views: _profileImage)
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: _profileImage, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //name Constrains
        addConstrainstsWithFormat("H:[v0]", views: _username)
        addConstrainstsWithFormat("V:[v0(20)]", views: _username)
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: _username, attribute: .CenterX, relatedBy: .Equal, toItem: _profileImage, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //Top
        addConstraint(NSLayoutConstraint(item: _username, attribute: .Top, relatedBy: .Equal, toItem: _profileImage, attribute: .Bottom, multiplier: 1, constant: 4))
    }
}