//
//  ProfileInfo.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/12/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

struct currentUser {
    
    static var name:String?
    static var username:String?
    static var bio:String?
    static var profileImg:String?
    static var likes:Int?
    static var key:String = FirebaseRef.Fb.currentUser.key
}

protocol UserProfilePageDelegate: class {
    
    func onEditProfile(sender:UIButton)
    func onMyPosts(sender:UIButton)
}

class ProfileInfo: BaseView {
    
    var delegate:UserProfilePageDelegate?
    var friendsFeedVC:FriendsFeedVC?
    var originalPosition:CGPoint?
    
    var profileImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .ScaleAspectFit
            image.layer.cornerRadius = 40
            image.layer.borderWidth = 2
            image.layer.borderColor = UIColor.rgb(7, green: 197, blue: 238).CGColor
            image.layer.masksToBounds = true
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var _fullName:UILabel = {
        let label = UILabel()
            label.font = UIFont.boldSystemFontOfSize(17)
            label.textAlignment = .Center
        return label
    }()
    
    var likes:UILabel = {
        let label = UILabel()
            label.font = UIFont.systemFontOfSize(15)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .Center
        return label
    }()
    
    lazy var editProfile:UIButton = {
        let button = UIButton(type: .System)
            button.setTitle("Edit Profile", forState: .Normal)
            button.backgroundColor = .grayColor()
            button.setTitleColor(.whiteColor(), forState: .Normal)
            button.addTarget(self, action: #selector(onEditProfile(_ :)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    var bioTextView:UITextView = {
        let txtView = UITextView()
            txtView.textColor = .blackColor()
            txtView.font = UIFont.systemFontOfSize(12)
            txtView.backgroundColor = UIColor(white: 0.95, alpha: 1)
            txtView.editable = false
            txtView.scrollEnabled = false
        return txtView
    }()
    
    lazy var myPosts: UIButton = {
        let button = UIButton(type: .System)
            button.setTitle("My Posts", forState: .Normal)
            button.setTitleColor(.whiteColor(), forState: .Normal)
            button.backgroundColor = UIColor.rgb(7, green: 197, blue: 238)
            button.addTarget(self, action: #selector(onMyPosts(_ :)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    func onMyPosts(sender:UIButton) {
        if delegate != nil {
            delegate?.onMyPosts(sender)
        }
    }
    
    func onEditProfile(sender: UIButton) {
        if delegate != nil {
            delegate?.onEditProfile(sender)
        }
    }
    
    func getCurrentUserInfo()  {
        
        FirebaseRef.Fb.currentUser.observeEventType(.Value, withBlock: {
            snapshot in
            
            if let users = snapshot.value as? [String:AnyObject] {
                
                for(_, useObj) in users {
                    
                    let userDic = useObj as! [String:AnyObject]
                    
                    currentUser.name = userDic["name"] as? String
                    currentUser.username = userDic["username"] as? String
                    currentUser.bio = userDic["bio"] as? String
                    currentUser.profileImg = userDic["profileImage"] as? String
                    currentUser.likes = userDic["likes"] as? Int
                    
                    self.likes.text = "\(userDic["likes"]!) Likes"
                    
                    self._fullName.text = currentUser.name
                    self.bioTextView.text = currentUser.bio
                    self.profileImage.getImagesBack(currentUser.profileImg!, placeHolder: "Profile", loader: UIActivityIndicatorView())
                }
            }
        })
    }
    
    var yConstraint:NSLayoutConstraint?
    let dimView = UIView()
    
    func setupProfileView() {
        
        if let window = UIApplication.sharedApplication().keyWindow {
            
            dimView.frame = window.frame
            
            window.addSubview(dimView)
            window.addSubview(self)
            
            //Profile View Constraints
            window.addConstrainstsWithFormat("H:|-15-[v0]-15-|", views: self)
            window.addConstrainstsWithFormat("V:[v0(250)]", views: self)
            
            yConstraint = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: window, attribute: .CenterY, multiplier: 1, constant: -window.frame.height)
            
            window.addConstraint(yConstraint!)
            
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
                
                self.dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                window.layer.layoutIfNeeded()
                self.yConstraint?.constant = 0
                
            }, completion: nil)
        }
    }
    
    func handleDissMiss() {
        
        if let window = UIApplication.sharedApplication().keyWindow {
            
            UIView.animateWithDuration(0.5, animations: {
            
                self.yConstraint?.constant = window.frame.height
                self.dimView.backgroundColor = UIColor(white: 0, alpha: 0.0)
            
                window.layer.layoutIfNeeded()
                
            })
        }
        
        dimView.removeFromSuperview()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.originalPosition = self.center
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            let postition = touch.locationInView(self.superview)
            
            self.center = CGPointMake((superview?.center.x)!, postition.y)
            
            let topEdge = CGRectGetMinY(self.frame)
        
            if topEdge <= 100 {
                
                self.frame = CGRectMake(15, 100, self.frame.width, self.frame.height)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let bottomEdge = CGRectGetMaxY(self.frame)
        
        UIView.animateWithDuration(0.2) {
            
            if bottomEdge >= 580 {
                
                self.handleDissMiss()
                
            } else {
                
                self.center = self.originalPosition!
            }
        }
    }
    
    override func setupView() {
        super.setupView()

        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 7
        backgroundColor = UIColor(white: 0.95, alpha: 1)
    
        getCurrentUserInfo()
    
        addSubview(profileImage)
        addSubview(_fullName)
        addSubview(likes)
        addSubview(editProfile)
        addSubview(bioTextView)
        addSubview(myPosts)
    
        //ProfileImage Constraints
        addConstrainstsWithFormat("H:[v0(80)]", views: profileImage)
        addConstrainstsWithFormat("V:[v0(80)]-220-|", views: profileImage)
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: profileImage, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //Username Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: _fullName)
        
        //Top
        addConstraint(NSLayoutConstraint(item: _fullName, attribute: .Top, relatedBy: .Equal, toItem: profileImage, attribute: .Bottom, multiplier: 1, constant: 10))
        
        //Centerx
        addConstraint(NSLayoutConstraint(item: _fullName, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //Likes Constraints 
        addConstrainstsWithFormat("H:[v0(100)]", views: likes)
        
        //Top
        addConstraint(NSLayoutConstraint(item: likes, attribute: .Top, relatedBy: .Equal, toItem: _fullName, attribute: .Bottom, multiplier: 1, constant: 10))
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: likes, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //Edit Profile Constraints
        addConstrainstsWithFormat("H:|-40-[v0]-40-|", views: editProfile)
        
        //Top
        addConstraint(NSLayoutConstraint(item: editProfile, attribute: .Top, relatedBy: .Equal, toItem: likes, attribute: .Bottom, multiplier: 1, constant: 5))
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: editProfile, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //Bio Constraints 
        addConstrainstsWithFormat("H:|-30-[v0]-30-|", views: bioTextView)
        addConstrainstsWithFormat("V:[v0(100)]", views: bioTextView)
        
        //Top
        addConstraint(NSLayoutConstraint(item: bioTextView, attribute: .Top, relatedBy: .Equal, toItem: editProfile, attribute: .Bottom, multiplier: 1, constant: 7))
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: bioTextView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //MyPosts Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: myPosts)
        addConstrainstsWithFormat("V:[v0(40)]|", views: myPosts)
        
    }
}
