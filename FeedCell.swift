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
            
            //PostDetails
            postTitle.text = posts.postDescription
            location.setTitle(posts.location, for: .normal)
            
            //UsersDetails
            usernameLabel.text = users.username
            
            if let imageURl = users.profileImage {
                profileImage.getImagesBack(url: imageURl, placeHolder: "Profile")
            }
            
            let active = UIImage(named: "ok_filled")
            let time = UIImage(named: "clock-1")
            
            let timeStamp = Date(timeIntervalSince1970: posts.timeEnded)
            
            activeLabel.text = posts.status == true ? "Active" : "Ended \(timeStamp.Time()) ago"
            activeImage.image = posts.status == true ? active : time
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

    var postTitle:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "NotoSans", size: 12)
            label.textColor = darkGray
            label.numberOfLines = 2
        return label
    }()
    
    var location:UIButton = {
        let button = UIButton()
            button.titleLabel?.font = UIFont(name: "NotoSans", size: 13)
            button.setTitleColor(.lightGray, for: UIControlState())
        return button
    }()
    
    var locationIcon:UIImageView = {
        let img = UIImageView()
            img.contentMode = .scaleAspectFit
            img.image = UIImage(named: "pin-1")
        return img
    }()
    
    var arrowIndicatior:UIImageView = {
        let image = UIImageView()
            image.image = UIImage(named: "righArrow")
        return image
    }()
    
    lazy var menuOptions:UIButton = {
        let menu = UIButton()
            menu.setImage(UIImage(named: "menu_2"), for: UIControlState())
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
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        addSubview(feedAllPhotosVC)
        addSubview(profileImage)
        addSubview(usernameLabel)
        addSubview(arrowIndicatior)
        addSubview(menuOptions)
        addSubview(activeLabel)
        addSubview(activeImage)
        addSubview(postTitle)
        addSubview(location)
        addSubview(locationIcon)
        
        addSubview(bottomDataSeperator)
        
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
        
        //postTitle Constrainsts
        addConstrainstsWithFormat("H:|-10-[v0]-30-|", views: postTitle)
        addConstrainstsWithFormat("V:[v0]-35-|", views: postTitle)
        
        //Location Constraints 
        addConstrainstsWithFormat("H:|-10-[v0]-5-[v1]", views: locationIcon,location)
        addConstrainstsWithFormat("V:[v0]", views: location)
        addConstrainstsWithFormat("V:[v0]", views: locationIcon)
        
        //Top
        addConstraint(NSLayoutConstraint(item: location, attribute: .top, relatedBy: .equal, toItem: postTitle, attribute: .bottom, multiplier: 1, constant: 0))
        
        //CenterY Icon
        addConstraint(NSLayoutConstraint(item: locationIcon, attribute: .centerY, relatedBy: .equal, toItem: location, attribute: .centerY, multiplier: 1, constant: 0))
        
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
        
        //ArrowIndicator Constraints
        addConstrainstsWithFormat("H:[v0(10)]-10-|", views: arrowIndicatior)
        addConstrainstsWithFormat("V:[v0(15)]", views: arrowIndicatior)
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: arrowIndicatior, attribute: .bottom, relatedBy: .equal, toItem: feedAllPhotosVC, attribute: .bottom, multiplier: 1, constant: -5))
        
        
        //ArrowIndicator Constraints
        addConstrainstsWithFormat("H:[v0]-5-|", views: menuOptions)
        addConstrainstsWithFormat("V:[v0]", views: menuOptions)
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: menuOptions, attribute: .centerY, relatedBy: .equal, toItem: location, attribute: .centerY, multiplier: 1, constant: 0))
        
        //Bottom Constraint
        addConstrainstsWithFormat("H:|[v0]|", views: bottomDataSeperator)
        addConstrainstsWithFormat("V:[v0(1.5)]|", views: bottomDataSeperator)
    }
}
