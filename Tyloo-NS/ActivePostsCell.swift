//
//  ActivePostsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/20/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class ActivePostsCell: BaseCell {
    
    var activePosts:Posts? {
        didSet {
            if let postImageURL = activePosts?.backGround {
                _postImage.getImagesBack(postImageURL, placeHolder: "emptyImage", loader: UIActivityIndicatorView())
            }
            
            if let postTitle = activePosts?.postDescription {
                _tilte.text = postTitle
            }
            
            if let postLocation = activePosts?.location {
                _location.text = postLocation
            }
            
            if let usersWith = activePosts?.tagged {
                
                Posts.getTaggedUsers(usersWith, completion: { (users) in
                    
                    self.peopleWithView.taggedUsersArray = users
                })
            }
        }
    }
    
    var _postImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .ScaleToFill
        return image
    }()
    
    var _tilte:UILabel = {
        let label = UILabel()
        label.textColor = .blackColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var _location:UILabel = {
        let label = UILabel()
        label.textColor = buttonColor
        label.font = UIFont.systemFontOfSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var _arrowIndicatior:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "righArrow")
        return image
    }()
    
    lazy var peopleWithView:peopleWith = {
        let pw = peopleWith()
        return pw
    }()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .whiteColor()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        addSubview(_postImage)
        addSubview(_tilte)
        addSubview(_location)
        addSubview(_arrowIndicatior)
        addSubview(peopleWithView)
        
        //ProfileImage Constraints
        addConstrainstsWithFormat("H:|[v0(130)]", views: _postImage)
        addConstrainstsWithFormat("V:|[v0]|", views: _postImage)
        
        //Title Constraints
        addConstrainstsWithFormat("H:[v0]", views: _tilte)
        addConstrainstsWithFormat("V:|-4-[v0(20)]", views: _tilte)
        
        //Left Constraints
        addConstraint(NSLayoutConstraint(item: _tilte, attribute: .Left, relatedBy: .Equal, toItem: _postImage, attribute: .Right, multiplier: 1, constant: 7))
        
        //Location Constraints
        addConstrainstsWithFormat("H:[v0]", views: _location)
        addConstrainstsWithFormat("V:[v0(20)]", views: _location)
        
        //Top Constraints
        addConstraint(NSLayoutConstraint(item: _location, attribute: .Top, relatedBy: .Equal, toItem: _tilte, attribute: .Bottom, multiplier: 1, constant: 7))
        
        //Left Constraints
        addConstraint(NSLayoutConstraint(item: _location, attribute: .Left, relatedBy: .Equal, toItem: _postImage, attribute: .Right, multiplier: 1, constant: 7))
        
        //Arrow Indicator Cosntrains
        addConstrainstsWithFormat("H:[v0(10)]-10-|", views: _arrowIndicatior)
        addConstrainstsWithFormat("V:[v0(15)]", views: _arrowIndicatior)
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: _arrowIndicatior, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        //People with view Costraints
        addConstrainstsWithFormat("H:[v0]-10-|", views: peopleWithView)
        addConstrainstsWithFormat("V:[v0]|", views: peopleWithView)
        
        //Top Constraints
        addConstraint(NSLayoutConstraint(item: peopleWithView, attribute: .Top, relatedBy: .Equal, toItem: _arrowIndicatior, attribute: .Bottom, multiplier: 1, constant: 7))
        
        //Left
        addConstraint(NSLayoutConstraint(item: peopleWithView, attribute: .Left, relatedBy: .Equal, toItem: _postImage, attribute: .Right, multiplier: 1, constant: 4))
    }
}