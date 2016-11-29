//
//  PostsHeader.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 11/28/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

protocol postHeaderDelegate: class {
    
    func onMenuOptions(sender:UIButton)
}

class PostsHeader: BaseCell {

    var postsDetails:Posts? {

        didSet {
            
            guard let posts = postsDetails else {return}
            guard let users = postsDetails?.users else {return}

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
        }
    }
    
    var delegate:postHeaderDelegate?
    
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
    
    lazy var menuOptions:UIButton = {
        let menu = UIButton()
            menu.setTitleColor(darkGray, for: .normal)
            menu.setTitle("...", for: .normal)
            menu.addTarget(self, action: #selector(onMenu(_ :)), for: .touchUpInside)
        return menu
    }()
    
    let bottomSeperator:UIView = {
        let view = UIView()
            view.backgroundColor = .darkGray
        return view
    }()
    
    func onMenu(_ sender:UIButton) {
        
        if delegate != nil {
            
            delegate?.onMenuOptions(sender: sender)
        }
    }
    
    override func setupView() {
        
        backgroundColor = .white
        
        addSubview(profileImage)
        addSubview(usernameLabel)
        addSubview(activeImage)
        addSubview(activeLabel)
        addSubview(menuOptions)
        addSubview(bottomSeperator)
        
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
        
        addConstrainstsWithFormat("H:[v0]-10-|", views: menuOptions)
        addConstrainstsWithFormat("V:|-15-[v0]", views: menuOptions)
        
        addConstrainstsWithFormat("H:|[v0]|", views: bottomSeperator)
        addConstrainstsWithFormat("V:[v0(0.5)]|", views: bottomSeperator)
    }
}
