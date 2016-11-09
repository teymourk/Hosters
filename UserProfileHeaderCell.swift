//
//  UserProfileHeaderCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 9/2/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//
import UIKit

protocol UserProfileHeaderDelegate: class {
    
    func onTrackers(_ sender: UIButton)
    func onTracking(_ sender: UIButton)
    func onEditProfile(_ sender: UIButton)
}

class UserProfileHeaderCell: BaseCell {
    
    var delegate:UserProfileHeaderDelegate?
    
    var profileDetails:Users? {
        didSet{
            
            if let imgURL = profileDetails?.profileImage {
                profileImage.getImagesBack(url: imgURL, placeHolder: "Profile")
            }
            
            if let fullname = profileDetails?.name {
                _fullName.text = fullname
            }
    
            if let postlikes = profileDetails?.likes {
                likes.text = "Likes \(postlikes)"
            }
            
            if let userKey = profileDetails?.userKey {
                
                if userKey == FirebaseRef.database.currentUser.key {
                    
                    editProfile_Follow_Button.setTitle("Edit Profile", for: UIControlState())
                    
                } else {
                    
                    editProfile_Follow_Button.handleFinidinTrackersForUser(userKey)
                }
            }
            
            if let trackersCount = profileDetails?.trackers?.count {
             
                _trackers.setTitle("Trackers \(trackersCount)", for: UIControlState())
                
            } else {
                _trackers.setTitle("Trackers \(0)", for: UIControlState())
            }
            
            if let trackingCount = profileDetails?.tracking?.count {
                
                _tracking.setTitle("Tracking \(trackingCount)", for: UIControlState())
                
            } else {
                _tracking.setTitle("Tracking \(0)", for: UIControlState())
            }
        }
    }
    
    var profileImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFit
            image.layer.cornerRadius = 40
            image.layer.masksToBounds = true
        return image
    }()
    
    var _fullName:UILabel = {
        let label = UILabel()
            label.textColor = .gray
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textAlignment = .center
        return label
    }()
    
    var likes:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "NotoSans", size: 15)
            label.textColor = .lightGray
            label.textAlignment = .center
        return label
    }()
    
    var _likeLogo:UIImageView = {
        let logo = UIImageView()
            logo.image = UIImage(named: "heart")
            logo.contentMode = .scaleAspectFill
        return logo
    }()
    
    lazy var _trackers:UIButton = {
        let btn = UIButton()
            btn.setTitleColor(darkGray, for: UIControlState())
            btn.addTarget(self, action: #selector(onTrackers(_ :)), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    lazy var _tracking:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(darkGray, for: UIControlState())
        btn.addTarget(self, action: #selector(onTracking(_ :)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    var bottomSeperator:UIView = {
        let view = UIView()
            view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var editProfile_Follow_Button:UIButton = {
        let btn = UIButton()
            btn.backgroundColor = .lightGray
            btn.titleLabel?.font = UIFont(name: "NotoSans", size: 15)
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 4
            btn.addTarget(self, action: #selector(onEditProfile(_ :)), for: .touchUpInside)
        return btn
    }()
    
    func onTrackers(_ sender: UIButton) {
        
        if delegate != nil {
            delegate?.onTrackers(sender)
        }
    }
    
    func onTracking(_ sender:UIButton) {
        
        if delegate != nil {
            delegate?.onTracking(sender)
        }
    }
    
    func onEditProfile(_ sender:UIButton) {
        
        if delegate != nil {
            delegate?.onEditProfile(sender)
        }
    }
        
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        addSubview(profileImage)
        addSubview(_fullName)
        addSubview(likes)
        addSubview(_likeLogo)
        addSubview(_trackers)
        addSubview(_tracking)
        addSubview(editProfile_Follow_Button)
        addSubview(bottomSeperator)
        
        //ProfileImage Constraints
        addConstrainstsWithFormat("H:|-15-[v0(80)]", views: profileImage)
        addConstrainstsWithFormat("V:|-15-[v0(80)]", views: profileImage)
        
        //Username Constraints
        addConstrainstsWithFormat("H:[v0]", views: _fullName)
        addConstrainstsWithFormat("V:|-25-[v0]", views: _fullName)
        
        //Left
        addConstraint(NSLayoutConstraint(item: _fullName, attribute: .left, relatedBy: .equal, toItem: profileImage, attribute: .right, multiplier: 1, constant: 10))
        
        //Like Logo
        addConstrainstsWithFormat("H:[v0]", views: _likeLogo)
        
        //Top
        addConstraint(NSLayoutConstraint(item: _likeLogo, attribute: .top, relatedBy: .equal, toItem: _fullName, attribute: .bottom, multiplier: 1, constant: 10))
        
        //Left
        addConstraint(NSLayoutConstraint(item: _likeLogo, attribute: .left, relatedBy: .equal, toItem: profileImage, attribute: .right, multiplier: 1, constant: 10))
        
        //Likes Constraints
        addConstrainstsWithFormat("H:[v0]", views: likes)
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: likes, attribute: .centerY, relatedBy: .equal, toItem: _likeLogo, attribute: .centerY, multiplier: 1, constant: 0))
        
        //Left
        addConstraint(NSLayoutConstraint(item: likes, attribute: .left, relatedBy: .equal, toItem: _likeLogo, attribute: .right, multiplier: 1, constant: 5))
        
        //Bio Constraints
        addConstrainstsWithFormat("H:|-10-[v0(100)]-40-[v1(100)]", views: _trackers, _tracking)
        addConstrainstsWithFormat("V:[v0(30)]", views: _trackers)
        addConstrainstsWithFormat("V:[v0(30)]", views: _tracking)
        
        //Tracking CenterY
        addConstraint(NSLayoutConstraint(item: _tracking, attribute: .centerY, relatedBy: .equal, toItem: _trackers, attribute: .centerY, multiplier: 1, constant: 0))
        
        //Edit Profile _ Follow_Unfollow
        addConstrainstsWithFormat("H:|-10-[v0]-10-|", views: editProfile_Follow_Button)
        addConstrainstsWithFormat("V:[v0(30)]", views: editProfile_Follow_Button)
        
        //Top
        addConstraint(NSLayoutConstraint(item: editProfile_Follow_Button, attribute: .top, relatedBy: .equal, toItem: _trackers, attribute: .bottom, multiplier: 1, constant: 5))
    
        //Top
        addConstraint(NSLayoutConstraint(item: _trackers, attribute: .top, relatedBy: .equal, toItem: profileImage, attribute: .bottom, multiplier: 1, constant: 10))
        
        //BottomSeperator Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: bottomSeperator)
        addConstrainstsWithFormat("V:[v0(1.5)]|", views: bottomSeperator)
    }
}
