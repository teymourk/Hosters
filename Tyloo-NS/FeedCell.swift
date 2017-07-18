//
//  FriendsFeedCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/12/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MapKit

//Fix Variable

class FeedCell: BaseCell, CLLocationManagerDelegate {
    var posts:Posts? {
        didSet {
            
            if let user = posts?.user {
                
                cellConfigure(posts!, user: user)
            }
        }
    }
    
    lazy var profileImage:UIImageView = {
        let image = UIImageView()
            image.layer.cornerRadius = 25
            image.layer.borderWidth = 1
            image.layer.borderColor = darkGray.CGColor
            image.translatesAutoresizingMaskIntoConstraints = false
            image.layer.masksToBounds = true
        return image
    }()
    
    let dimContainerView:UIView = {
        let view = UIView()
            view.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
        return view
    }()
    
    var postImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .ScaleToFill
            image.backgroundColor = .grayColor()
        return image
    }()
    
    var fullName:UILabel = {
        let label = UILabel()
            label.textColor = .whiteColor()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFontOfSize(16)
        return label
    }()
    
    var username:UILabel = {
        let label = UILabel()
            label.textColor = .whiteColor()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    var title:UILabel = {
        let label = UILabel()
            label.textColor = .whiteColor()
            label.textAlignment = .Center
            label.font = UIFont.boldSystemFontOfSize(22)
            label.adjustsFontSizeToFitWidth = true;
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var location:UIButton = {
        let button = UIButton(type: .System)
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var images:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named:"stack_of_photos"), forState: .Normal)
        return button
    }()
    
    var imagesCount:UILabel = {
        let label = UILabel()
        label.textColor = goldColor
        label.font = UIFont.boldSystemFontOfSize(16)
        label.text = "\(0)"
        return label
    }()
    
    var peopleWith:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named:"firends"), forState: .Normal)
        return button
    }()
    
    var liveLabel:UILabel = {
        let label = UILabel()
            label.text = "ACTIVE"
            label.textColor = .whiteColor()
            label.font = UIFont.boldSystemFontOfSize(16)
            label.hidden = true
        return label
    }()
    
    var liveImage:UIImageView = {
        let image = UIImageView()
            image.image = UIImage(named: "red")
            image.hidden = true
        return image
    }()
    
    var peopleWithCount:UILabel = {
        let label = UILabel()
            label.textColor = goldColor
            label.font = UIFont.boldSystemFontOfSize(16)
        return label
    }()
    
    var arrowIndicatior:UIImageView = {
        let image = UIImageView()
            image.image = UIImage(named: "righArrow")
        return image
    }()
    
    lazy var loader:UIActivityIndicatorView = {
        let refresh = UIActivityIndicatorView(activityIndicatorStyle: .White)
            refresh.center = self.center
            refresh.color = .redColor()
            refresh.startAnimating()
        return refresh
    }()
    
    //Configureing Cell properties
    func cellConfigure(post:Posts, user:Users) {
        
        if let imgURL = post.backGround {
            
            postImage.image = nil
            postImage.getImagesBack(imgURL, placeHolder: "emptyImage", loader:loader)
        }
        
        if let postName = user.name {
            fullName.text = postName
        }
        
        if let postUsername = user.username {
            username.text = postUsername
        }
        
        if let profileURL = user.profileImage {
            profileImage.getImagesBack(profileURL, placeHolder: "Profile",loader:UIActivityIndicatorView())
        }
        
        if let postTitle = posts?.postDescription {
            title.text = postTitle
        }
        
        if let postLocation = posts?.location {
            location.setTitle(postLocation, forState: .Normal)
        }
        
        if let tagged = posts?.tagged  {
        
            self.peopleWithCount.text = "\(tagged.count)"
        
        } else {
            self.peopleWithCount.text = "\(0)"
        }
        
        if let posKey = posts?.postKey {
            
            PostImages.getPostImagesData(posKey, completion: { (postImages) in
              
                self.imagesCount.text = "\(postImages.count)"
            })
        }
        
        guard let status = post.statusLight else {return}
        
        liveImage.hidden = status == true ? false : true
        liveLabel.hidden = status == true ? false : true
    }
    
    override func prepareForReuse() {
        
        peopleWithCount.text = "\(0)"
        imagesCount.text = "\(0)"
    }

    override func setupView() {
        super.setupView()
        
        addSubview(postImage)
        addSubview(profileImage)
        addSubview(fullName)
        addSubview(username)
        addSubview(liveLabel)
        addSubview(liveImage)
        addSubview(title)
        addSubview(location)
        addSubview(loader)
        addSubview(peopleWith)
        addSubview(peopleWithCount)
        addSubview(images)
        addSubview(imagesCount)
        addSubview(arrowIndicatior)
        postImage.addSubview(dimContainerView)
        
        //PostImage Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: postImage)
        addConstrainstsWithFormat("V:|[v0]|", views: postImage)
        
        //Profile Image Constraints
        addConstrainstsWithFormat("H:|-6-[v0]", views: profileImage)
        addConstrainstsWithFormat("V:|-10-[v0]", views: profileImage)
        
        //For Profile Image
        //let width = (self.frame.height - 6 - 7 - fullName.frame.width) * 9 / 16
        
        //Height
        addConstraint(NSLayoutConstraint(item: profileImage, attribute: .Height, relatedBy: .Equal, toItem: profileImage, attribute: .Height, multiplier: 0, constant: 50))
        //Width
        addConstraint(NSLayoutConstraint(item: profileImage, attribute: .Width, relatedBy: .Equal, toItem: profileImage, attribute: .Width, multiplier: 0, constant: 50))

        //FullName Constraints
        addConstrainstsWithFormat("V:|-10-[v0]", views: fullName)
        
        //Right
        addConstraint(NSLayoutConstraint(item: fullName, attribute: .Left, relatedBy: .Equal, toItem: profileImage, attribute: .Right, multiplier: 1, constant: 7))
        
        //Username Constrains
        
        //Top
        addConstraint(NSLayoutConstraint(item: username, attribute: .Top, relatedBy: .Equal, toItem: fullName, attribute: .Bottom, multiplier: 1, constant: 4))
        
        //Left
        addConstraint(NSLayoutConstraint(item: username, attribute: .Left, relatedBy: .Equal, toItem: profileImage, attribute: .Right, multiplier: 1, constant: 7))
        
        //Live label and Image Constraints
        addConstrainstsWithFormat("H:[v0(10)]-10-|", views: liveImage)
        addConstrainstsWithFormat("V:|-10-[v0(10)]", views: liveImage)
        addConstrainstsWithFormat("V:|-6-[v0]", views: liveLabel)
        
        //Live label left
        addConstraint(NSLayoutConstraint(item: liveLabel, attribute: .Right, relatedBy: .Equal, toItem: liveImage, attribute: .Left, multiplier: 1, constant: -6))
        
        //Title Horizontal Constraints
        addConstrainstsWithFormat("H:|-5-[v0]-5-|", views: title)
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: title, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: title, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        //ArrowImage
        addConstrainstsWithFormat("H:[v0(10)]-10-|", views: arrowIndicatior)
        addConstrainstsWithFormat("V:[v0(15)]-10-|", views: arrowIndicatior)
        
        //Location Constraints
        addConstrainstsWithFormat("H:[v0]", views: location)
        addConstrainstsWithFormat("V:[v0(20)]", views: location)
        
        //Top
        addConstraint(NSLayoutConstraint(item: location, attribute: .Top, relatedBy: .Equal, toItem: title, attribute: .Bottom, multiplier: 1, constant: 7))
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: location, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //People wih and Images Constraints
        addConstrainstsWithFormat("H:|-6-[v0(20)]-10-[v1]-20-[v2(20)]-10-[v3]", views: peopleWith, peopleWithCount, images, imagesCount)
        addConstrainstsWithFormat("V:[v0(20)]-6-|", views: peopleWith)
        addConstrainstsWithFormat("V:[v0(20)]-6-|", views: peopleWithCount)
        addConstrainstsWithFormat("V:[v0(20)]-6-|", views: images)
        addConstrainstsWithFormat("V:[v0(20)]-6-|", views: imagesCount)
        
        //Dimed Conctainer
        postImage.addConstrainstsWithFormat("H:|[v0]|", views: dimContainerView)
        postImage.addConstrainstsWithFormat("V:|[v0]|", views: dimContainerView)

    }
}