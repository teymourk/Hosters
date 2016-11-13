//
//  AllPicturesFeedCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/26/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class AllPicturesFeedCell:BaseCell {
    
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
            image.layer.borderWidth = 0.5
            image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    lazy var like:UIButton = {
        let btn = UIButton()
            btn.setImage(UIImage(named: "novel-empty"), for: UIControlState())
            btn.addTarget(self, action: #selector(handleLiking(_ :)), for: .touchUpInside)
        return btn
    }()
    
    var likeCount:UILabel = {
        let label = UILabel()
            label.textColor = darkGray
            label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var seperator:UIView = {
        let view = UIView()
            view.backgroundColor = .lightGray
        return view
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
            label.font = UIFont(name: "Prompt", size: 17)
            label.textColor = .white
        return label
    }()
    
    var date:UILabel = {
        let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    var caption:UITextView = {
        let txt = UITextView()
            txt.textColor = .white
            txt.font = UIFont(name: "NotoSans", size: 13)
            txt.isScrollEnabled = false
            txt.isEditable = false
            txt.backgroundColor = .clear
        return txt
    }()
    
    lazy var menuOptions:UIButton = {
        let menu = UIButton()
            menu.setImage(UIImage(named: "menu_2"), for: UIControlState())
            menu.addTarget(self, action: #selector(onMenu(_ :)), for: .touchUpInside)
        return menu
    }()
    
    func onMenu(_ sender:UIButton) {
        
    }
    
    var allPicturesFeed:PostInfoAndPictures?
    var likes:Int?
    
    func handleLiking(_ sender: UIButton) {
        
        setupImageAnumation()
    }
    
    func handleIfLiked(_ usersLikes:[String:AnyObject]) {
        
        for users in usersLikes.keys {
            
            if users.contains(FirebaseRef.database.currentUser.key) {
                
                like.setImage(UIImage(named: "novel_filled"), for: UIControlState())
            }
        }
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
        
        like.setImage(UIImage(named: "novel-empty"), for: UIControlState())
        likeCount.text = nil
        caption.text = nil
    }
    
    func setupListView() {
        
        addSubview(postedImage)
        addSubview(like)
        addSubview(likeCount)
        addSubview(seperator)
        addSubview(profileImage)
        addSubview(username)
        addSubview(date)
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
        addConstrainstsWithFormat("H:[v0]-15-|", views: date)
        addConstrainstsWithFormat("V:[v0(12)]", views: date)
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: date, attribute: .centerY, relatedBy: .equal, toItem: profileImage, attribute: .centerY, multiplier: 1, constant: 0))
        
        //PostedImage Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: postedImage)
        addConstrainstsWithFormat("V:|[v0]|", views: postedImage)
        
        //Like Constraints
        addConstrainstsWithFormat("H:|-15-[v0(30)]", views: like)
        addConstrainstsWithFormat("V:[v0(30)]", views: like)
        
        //Top
        addConstraint(NSLayoutConstraint(item: like, attribute: .top, relatedBy: .equal, toItem: postedImage, attribute: .bottom, multiplier: 1, constant: 4))
        
        //Like Count
        addConstrainstsWithFormat("H:[v0]", views: likeCount)
        addConstrainstsWithFormat("V:[v0]", views: likeCount)
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: likeCount, attribute: .centerY, relatedBy: .equal, toItem: like, attribute: .centerY, multiplier: 1, constant: 0))
        
        //Left
        addConstraint(NSLayoutConstraint(item: likeCount, attribute: .left, relatedBy: .equal, toItem: like, attribute: .right, multiplier: 1, constant: 4))
        
        //Seperator Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: seperator)
        addConstrainstsWithFormat("V:[v0(1.5)]|", views: seperator)
        
        //Caption Constrains
        postedImage.addConstrainstsWithFormat("H:|-10-[v0]|", views: caption)
        postedImage.addConstrainstsWithFormat("V:[v0(40)]-10-|", views: caption)
        
        //MenuOptions Constrains
        addConstrainstsWithFormat("H:[v0]-10-|", views: menuOptions)
        addConstrainstsWithFormat("V:[v0]-10-|", views: menuOptions)
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        setupListView()
    }
}
