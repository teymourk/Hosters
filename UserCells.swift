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
            
            if let profileImageURL = users?.profileImage {
                _profileImage.getImagesBack(url: profileImageURL, placeHolder: "Profile")
            }
            
            if users?.userKey == FirebaseRef.database.currentUser.key {
                _follow_following.isHidden = true
            }
        }
    }
    
    var searchUsersVC:SearchUsers?
    
    var _profileImage:UIImageView = {
        let image = UIImageView()
            image.layer.masksToBounds = true
            image.layer.cornerRadius = 25
            image.contentMode = .scaleAspectFill
        return image
    }()
    
    var _username:UILabel = {
        let label = UILabel()
            label.textColor = .darkGray
            label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var _follow_following:UIButton = {
        let button = UIButton()
            button.setTitleColor(.white, for: UIControlState())
            button.setTitle("Track", for: UIControlState())
            button.titleLabel?.font = UIFont(name: "NotoSans", size: 12)
            button.setTitleColor(darkGray, for: UIControlState())
            button.addTarget(self, action: #selector(onTarack_unTrack(_ :)), for: .touchUpInside)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 4
            button.layer.borderWidth = 1
            button.layer.borderColor = orange.cgColor
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func onTarack_unTrack(_ sender:UIButton) {
        
        sender.title(for: UIControlState()) == "Tracking" ? sender.handleUnTracking(sender, users: searchUsersVC?.allUsers) : sender.handleTracking(sender, users: searchUsersVC?.allUsers)
    }
    
    override func setupView() {
        super.setupView()
        
        addSubview(_profileImage)
        addSubview(_username)
        addSubview(_follow_following)
        
        backgroundColor = .white
        
        //ProfileImage Cosntraints
        addConstrainstsWithFormat("H:|-10-[v0(50)]", views: _profileImage)
        addConstrainstsWithFormat("V:[v0(50)]", views: _profileImage)
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: _profileImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 10))
        
        //userName Constraints
        addConstrainstsWithFormat("H:[v0]-170-|", views: _username)
        addConstrainstsWithFormat("V:|-20-[v0(20)]", views: _username)
        
        //Right of ProfileImage
        addConstraint(NSLayoutConstraint(item: _username, attribute: .left, relatedBy: .equal, toItem: _profileImage, attribute: .right, multiplier: 1, constant: 10))
        
        //Follow/Unfollow Constraints
        addConstrainstsWithFormat("H:[v0(70)]-20-|", views: _follow_following)
        addConstrainstsWithFormat("V:[v0(30)]", views: _follow_following)
        
        _follow_following.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
}
