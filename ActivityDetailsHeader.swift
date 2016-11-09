//
//  ActivityDetailsHeader.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/26/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class ActivityDetailsHeader: BaseCell {
    
    var postDetails:Posts? {
        didSet {
            
            if let title = postDetails?.postDescription {
                postTitle.text = title
            }
            
            if let locationName = postDetails?.location {
                location.setTitle(locationName, for: UIControlState())
            }
            
            if let tagged = postDetails?.tagged {
                
                Posts.getTaggedUsers(tagged, completion: { (users) in
                    
                    self.peopleTagged.taggedUsersArray = users

                })
            }
            
            if let postStatus = postDetails?.statusLight {
                
                postStatus == true ? camera.setImage(UIImage(named: "camera"), for: UIControlState()) : camera.setImage(UIImage(named: "library"), for: UIControlState())
                
                date.text = postStatus == true ? "Add Photo Using Camera" : "Add Photo Using Photo Library"
            }
        }
    }
    
    var allphotosVC:PostInfoAndPictures?
    
    var postTitle:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "PROMPT", size: 15)
            label.textColor = darkGray
        return label
    }()
    
    var location:UIButton = {
        let button = UIButton()
            button.titleLabel?.font = UIFont(name: "NotoSans", size: 14)
            button.setTitleColor(buttonColor, for: UIControlState())
        return button
    }()
    
    lazy var camera:UIButton = {
        let button = UIButton()
        button.setTitleColor(.lightGray, for: UIControlState())
        button.addTarget(self, action: #selector(onAddPhoto(_ :)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let date:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "NotoSans", size: 12)
            label.textColor = .lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomDataSeperator:UIView = {
        let view = UIView()
            view.backgroundColor = .gray
        return view
    }()

    var seperator:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    var peopleTagged:peopleWith = {
        let pw = peopleWith()
        return pw
    }()
    
    var pageNotification:PageNotifications = {
        let pn = PageNotifications()
        return pn
    }()
    
    
    func onAddPhoto(_ sender:UIButton) {
        
        allphotosVC?.onCamera()
    }
    
    func onCheckIn(_ sender:UIButton) {
        
        pageNotification.showNotification("Not Available.Working on the feature")
    }
    
    override func setupView() {
        super.setupView()
        
        addSubview(postTitle)
        addSubview(location)
        addSubview(camera)
        addSubview(date)
        addSubview(bottomDataSeperator)
        addSubview(peopleTagged)
        addSubview(seperator)
        
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        //View All Photos Constraints
        addConstrainstsWithFormat("H:[v0]", views: postTitle)
        addConstrainstsWithFormat("V:|-10-[v0(20)]", views: postTitle)
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: postTitle, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        //Location
        addConstrainstsWithFormat("H:[v0]", views: location)
        addConstrainstsWithFormat("V:[v0]", views: location)
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: location, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        //Top
        //CenterX
        addConstraint(NSLayoutConstraint(item: location, attribute: .top, relatedBy: .equal, toItem: postTitle, attribute: .bottom, multiplier: 1, constant: 10))
        
        //Camera constraints
        camera.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        camera.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 15).isActive = true
        
        
        date.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        date.topAnchor.constraint(equalTo: camera.bottomAnchor, constant: 5).isActive = true
        
        //Bottom Seperator
        addConstrainstsWithFormat("H:|-25-[v0]-25-|", views: bottomDataSeperator)
        addConstrainstsWithFormat("V:[v0(0.5)]", views: bottomDataSeperator)
        
        //Top
        addConstraint(NSLayoutConstraint(item: bottomDataSeperator, attribute: .top, relatedBy: .equal, toItem: date, attribute: .bottom, multiplier: 1, constant: 5))
        
        //PeopleWith Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: peopleTagged)
        addConstrainstsWithFormat("V:[v0(85)]", views: peopleTagged)
        
        //Top
        addConstraint(NSLayoutConstraint(item: peopleTagged, attribute: .top, relatedBy: .equal, toItem: bottomDataSeperator, attribute: .bottom, multiplier: 1, constant: 14))
        
        //Seperator Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: seperator)
        addConstrainstsWithFormat("V:[v0(1.5)]|", views: seperator)
    }
}
