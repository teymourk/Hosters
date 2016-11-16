//
//  AllPicturesFeedCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/26/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

protocol AllPostsImagesDelegate: class {
    
    func onImages(sender: UITapGestureRecognizer)
    func onImageSwipe(sender: UISwipeGestureRecognizer)
    func onMenu(_ sender:UIButton)
}

class AllPicturesFeedCell:BaseCell {
    
    var delegate:AllPostsImagesDelegate?
    
    var postImages:PostImages? {
        didSet {
            
            if let user = postImages?.users {
                username.text = user.username
            }
            
            if let userImage = postImages?.users?.profileImage {
                profileImage.getImagesBack(url: userImage, placeHolder: "Profile")
            }
            
            if let postImage = postImages?.imageURL {
                postedImage.getImagesBack(url: postImage, placeHolder: "emptyImage")
            }
            
            if let postCaption = postImages?.caption  {
            
                caption.text = postCaption
            }
        }
    }
    
    var postedImage:UIImageView = {
        let image = UIImageView()
            image.clipsToBounds = true
            image.contentMode = .scaleAspectFill
            image.isUserInteractionEnabled = true
        return image
    }()
    
    
    var profileImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.masksToBounds = true
            image.layer.cornerRadius = 15
        return image
    }()
    
    var username:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "NotoSans-Bold", size: 13)
            label.textColor = .white
        return label
    }()
    
    var timePosted:UILabel = {
        let label = UILabel()
            label.text = "45 Min Ago"
            label.textColor = .white
            label.font = UIFont(name: "NotoSans-Bold", size: 13)
        return label
    }()
    
    var caption:UILabel = {
        let label = UILabel()
            label.textColor = .white
            label.font = UIFont(name: "NotoSans-Bold", size: 18)
            label.backgroundColor = .clear
            label.numberOfLines = 2
        return label
    }()
    
    lazy var menuOptions:UIButton = {
        let menu = UIButton()
            menu.setImage(UIImage(named: "menu_2"), for: UIControlState())
            menu.addTarget(self, action: #selector(onMenu(_ :)), for: .touchUpInside)
        return menu
    }()
    
    func onImage(_ sender: UITapGestureRecognizer) {
        
        if delegate != nil {            
            delegate?.onImages(sender: sender)
        }
    }
    
    func onImageSwipe(sender: UISwipeGestureRecognizer) {
        
        if delegate != nil {
            delegate?.onImageSwipe(sender: sender)
        }
    }
    
    func onMenu(_ sender: UIButton) {
        
        if delegate != nil {
            delegate?.onMenu(sender)
        }
    }
    
    var allPicturesFeed:PostInfoAndPictures?
    
    func handleLiking(_ sender: UIButton) {
        
        setupImageAnumation()
    }
    
    var likeImageAnimation:UIImageView = {
        let image = UIImageView()
            image.image = UIImage(named: "heart_balloon_filled")
            image.contentMode = .scaleAspectFill
        return image
    }()
    
    func setupImageAnumation() {
        
        postedImage.addSubview(likeImageAnimation)
        
        likeImageAnimation.frame = CGRect(x: postedImage.center.x, y: postedImage.frame.midY, width: 100, height: 100)
        likeImageAnimation.alpha = 1
        
        UIView.animate(withDuration: 1, animations: {
            
            self.likeImageAnimation.frame = CGRect(x: self.postedImage.center.x, y: self.postedImage.frame.minY, width: 100, height: 100)
            self.likeImageAnimation.alpha = 0
        })
    }
    
    override func prepareForReuse() {
        
        caption.text = nil
    }
    
    func setupListView() {
        
        addSubview(postedImage)
        addSubview(profileImage)
        addSubview(username)
        addSubview(timePosted)
        addSubview(menuOptions)
        postedImage.addSubview(caption)
        postedImage.contentMode = .scaleAspectFill
        
        //ProfileImage Constraints
        addConstrainstsWithFormat("H:|-15-[v0(30)]", views: profileImage)
        addConstrainstsWithFormat("V:|-15-[v0(30)]", views: profileImage)
        
        //username Constraints
        addConstrainstsWithFormat("H:[v0]", views: username)
        addConstrainstsWithFormat("V:[v0(20)]", views: username)
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: username, attribute: .centerY, relatedBy: .equal, toItem: profileImage, attribute: .centerY, multiplier: 1, constant: 0))
        
        //Left
        addConstraint(NSLayoutConstraint(item: username, attribute: .left, relatedBy: .equal, toItem: profileImage, attribute: .right, multiplier: 1, constant: 10))
        
        
        //Date Constraints
        addConstrainstsWithFormat("H:[v0]-15-|", views: timePosted)
        addConstrainstsWithFormat("V:[v0(15)]", views: timePosted)
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: timePosted, attribute: .centerY, relatedBy: .equal, toItem: profileImage, attribute: .centerY, multiplier: 1, constant: 0))
        
        //PostedImage Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: postedImage)
        addConstrainstsWithFormat("V:|[v0]|", views: postedImage)
        
        //Caption Constrains
        postedImage.addConstrainstsWithFormat("H:|-10-[v0]|", views: caption)
        postedImage.addConstrainstsWithFormat("V:[v0(40)]-40-|", views: caption)
        
        //MenuOptions Constrains
        addConstrainstsWithFormat("H:[v0]-10-|", views: menuOptions)
        addConstrainstsWithFormat("V:[v0]-10-|", views: menuOptions)
    }
    
    override func setupView() {
        super.setupView()
                
        tapGesture(self, actions: "onImage:", object: postedImage, numberOfTaps: 1)
    
        setupListView()
    }
}
