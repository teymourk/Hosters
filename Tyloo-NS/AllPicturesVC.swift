//
//  AllPicturesVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/24/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MBProgressHUD

private let CELL_ID = "CellID"

class AllPicturesVC: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var postKey:String? {
        didSet{
            
            guard let postKey = postKey else {return}
            getPostedImages(postKey)
        }
    }
    
    var allImagesArray:[PostImages]? {
        didSet {
            
            allImagesCollectionView.reloadData()
        }
    }
    
    lazy var allImagesCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.registerClass(AllPicturesCell.self, forCellWithReuseIdentifier: CELL_ID)
            cv.backgroundColor = .clearColor()
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    
    func getPostedImages(postKey:String) {
        
        PostImages.getPostImagesData(postKey) { (images) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.allImagesArray = images
            })
        }
    }
    
    override func setupView() {
        super.setupView()

        addSubview(allImagesCollectionView)
        
        //CollectionView Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: allImagesCollectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: allImagesCollectionView)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImagesArray?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as! AllPicturesCell
        
        cell.allImage = allImagesArray![indexPath.item]
        cell._like.tag = indexPath.item
        cell.allPicturesVC = self
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(frame.width, frame.height)
    }
        
    func handleLiking(sender:UIButton) {
        
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        let post = allImagesArray![indexPath.item]
    
        handleDealingWithFirebase(post, sender: sender)
    }
    
    func handleDealingWithFirebase(post:PostImages, sender:UIButton) {
        
        let photoRef = FirebaseRef.Fb.REF_PHOTO.childByAppendingPath("\(postKey!)/\(post.imageKey!)/likes")
        _ = FirebaseRef.Fb.REF_USERS.childByAppendingPath("\(post.poster!)/user/likes")

        var likes = post.likes
    
        dispatch_async(dispatch_get_main_queue(), {
            
            if sender.currentImage == UIImage(named: "novel") {
                
                sender.setImage(UIImage(named: "novel-empty"), forState: .Normal)
                likes?.removeValueForKey(currentUser.key)
                photoRef.setValue(likes)
                
            } else {
                
                sender.setImage(UIImage(named: "novel"), forState: .Normal)
                photoRef.updateChildValues([currentUser.key: true])
            }
        })
    }
}

class AllPicturesCell:BaseCell {
    
    var allPicturesVC:AllPicturesVC?
    
    var allImage:PostImages? {
        didSet {
         
            if let user = allImage?.user {
                configureCell(allImage!, users: user)
            }
        }
    }
    
    var _postedImages:UIImageView = {
        let image = UIImageView()
            image.contentMode = .ScaleToFill
        return image
    }()
    
    lazy var _like:UIButton = {
        let btn = UIButton()
            btn.setImage(UIImage(named:"novel-empty"), forState: .Normal)
            btn.addTarget(self, action: #selector(handleLiking(_ :)), forControlEvents: .TouchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var _profileImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .ScaleAspectFill
            image.layer.masksToBounds = true
            image.layer.cornerRadius = 20
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var _username:UILabel = {
        let label = UILabel()
            label.textColor = .whiteColor()
            label.font = UIFont.systemFontOfSize(14)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var seperator:UIView = {
        let view = UIView()
            view.backgroundColor = goldColor
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var likesCount:UILabel = {
        let label = UILabel()
            label.textColor = .whiteColor()
            label.textAlignment = .Right
            label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    
    var _caption:UITextView = {
        let txt = UITextView()
            txt.textColor = .whiteColor()
            txt.font = UIFont.systemFontOfSize(16)
            txt.scrollEnabled = false
            txt.editable = false
            txt.backgroundColor = .clearColor()
            txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    func configureCell(post:PostImages, users:Users) {
        
        if let postImageURL = allImage?.imageURL {
            _postedImages.getImagesBack(postImageURL, placeHolder: "emptyImage", loader: UIActivityIndicatorView())
        }
        
        if let caption = allImage?.description {
            _caption.text = caption
        }
        
        if let likes = allImage?.likes {
            
            likesCount.text = "\(likes.count)"
            handleIfLiked(likes)
        }
        
        if let profileImageURL = users.profileImage {
            _profileImage.getImagesBack(profileImageURL, placeHolder: "Profile", loader: UIActivityIndicatorView())
        }
        
        if let username = users.username {
            _username.text = username
        }
    }
    
    func handleLiking(sender: UIButton) {
        
        allPicturesVC?.handleLiking(sender)
    }
    
    func handleIfLiked(usersLikes:[String:AnyObject]) {
        
        for users in usersLikes.keys {
            
            if users.containsString(currentUser.key) {
               
                _like.setImage(UIImage(named: "novel"), forState: .Normal)
        
            }
        }
    }
    
    override func prepareForReuse() {
        
        _like.setImage(UIImage(named: "novel-empty"), forState: .Normal)
        likesCount.text = nil
        _caption.text = nil
    }

    override func setupView() {
        super.setupView()
        
        addSubview(_postedImages)
        addSubview(_like)
        addSubview(likesCount)
        addSubview(seperator)
        addSubview(_caption)
        addSubview(_profileImage)
        addSubview(_username)
    
        //Images constraints
        addConstrainstsWithFormat("H:|[v0]|", views: _postedImages)
        addConstrainstsWithFormat("V:|[v0]", views: _postedImages)
                
        addConstraint(NSLayoutConstraint(item: _postedImages, attribute: .Height, relatedBy: .Equal, toItem: _postedImages, attribute: .Height, multiplier: 0, constant: HEIGHE_IMAGE))
        
        //Like Constraints
        addConstrainstsWithFormat("H:[v0(40)]-14-|", views: _like)
        addConstrainstsWithFormat("V:[v0(40)]", views: _like)
        
        //Top Constraints
        addConstraint(NSLayoutConstraint(item: _like, attribute: .Top, relatedBy: .Equal, toItem: _postedImages, attribute: .Bottom, multiplier: 1, constant: 15))
        
        //ProfileImage/Username Constraints
        addConstrainstsWithFormat("H:|-10-[v0(40)]-10-[v1]|", views: _profileImage, _username)
        addConstrainstsWithFormat("V:[v0(40)]", views: _profileImage)
        addConstrainstsWithFormat("V:[v0]", views: _profileImage)
        
        //Image Bottom
        addConstraint(NSLayoutConstraint(item: _profileImage, attribute: .Bottom, relatedBy: .Equal, toItem: seperator, attribute: .Top, multiplier: 1, constant: -4))
        
        //Username CenterY
        addConstraint(NSLayoutConstraint(item: _username, attribute: .Bottom, relatedBy: .Equal, toItem: seperator, attribute: .Top, multiplier: 1, constant: -4))
        
        //Seperator Constraints
        addConstrainstsWithFormat("H:|-12-[v0]-12-|", views: seperator)
        addConstrainstsWithFormat("V:[v0(0.5)]", views: seperator)
        
        //Top Constraints
        addConstraint(NSLayoutConstraint(item: seperator, attribute: .Top, relatedBy: .Equal, toItem: _like, attribute: .Bottom, multiplier: 1, constant: 7))
        
        //likes Constraints
        addConstrainstsWithFormat("H:[v0(60)]-12-|", views: likesCount)
        addConstrainstsWithFormat("V:[v0]", views: likesCount)
        
        //Top Constraints
        addConstraint(NSLayoutConstraint(item: likesCount, attribute: .Top, relatedBy: .Equal, toItem: seperator, attribute: .Bottom, multiplier: 1, constant: 1))
        
        //Label Constraints
        addConstrainstsWithFormat("H:|-12-[v0]-12-|", views: _caption)
        addConstrainstsWithFormat("V:[v0]", views: _caption)
        
        //Top Constraints
        addConstraint(NSLayoutConstraint(item: _caption, attribute: .Top, relatedBy: .Equal, toItem: likesCount, attribute: .Bottom, multiplier: 1, constant: 0))
    }
}