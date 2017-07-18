//
//  AllPicturesFeedVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/1/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CellID"

class AllPicturesFeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var postedImages:[PostImages]? {
        didSet {
            
            activityIndicator.stopAnimating()
            collectionView!.reloadData()
        }
    }
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
            indicator.center = self.view.center
            indicator.color = .grayColor()
            indicator.startAnimating()
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pictures"
        navigationController?.navigationBar.translucent = false
        self.collectionView!.registerClass(AllPicturesFeedCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.collectionView?.backgroundColor = .whiteColor()
        
        let backButton = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(onCancel))
        navigationItem.leftBarButtonItem = backButton
        
        setupView()
        getImages()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return postedImages?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as! AllPicturesFeedCell
    
        cell.postImages = postedImages![indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(view.frame.width, HEIGHE_IMAGE + 300)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4
    }
    
    func getImages() {
        
        PostImages.getAllPhotos { (images) in
            
            self.postedImages = images
        }
    }
    
    func onCancel(sender:UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupView() {
        
        view.addSubview(activityIndicator)
    }
}


class AllPicturesFeedCell:BaseCell {
    
    var postImages:PostImages? {
        didSet {
            
            guard let imageURL = postImages?.imageURL else {return}
            
            postedImage.getImagesBack(imageURL, placeHolder: "emptyImage", loader: UIActivityIndicatorView())
            
            guard let likes = postImages?.likes?.count else {return}
            
            like.setTitle("\(likes)", forState: .Normal)
            
            guard let postCaption = postImages?.description else {return}
            
            caption.text = postCaption
            
            if let user = postImages?.user {
                
                guard let imageURL = user.profileImage else {return}
                
                profileImage.getImagesBack(imageURL, placeHolder: "Profile", loader: UIActivityIndicatorView())
                
                guard let Userusername = user.username else {return}
                
                username.text = Userusername
            }
        }
    }
    
    var postedImage:UIImageView = {
        let image = UIImageView()
            image.backgroundColor = .greenColor()
            image.contentMode = .ScaleToFill
        return image
    }()
    
    lazy var like:UIButton = {
        let btn = UIButton()
            btn.setImage(UIImage(named: "novel"), forState: .Normal)
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            btn.addTarget(self, action: #selector(handleLiking(_ :)), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    var seperator:UIView = {
        let view = UIView()
            view.backgroundColor = darkGray
        return view
    }()
    
    var profileImage:UIImageView = {
        let image = UIImageView()
            image.backgroundColor = .yellowColor()
            image.contentMode = .ScaleToFill
            image.layer.masksToBounds = true
            image.layer.cornerRadius = 30
        return image
    }()
    
    var username:UILabel = {
        let label = UILabel()
            label.backgroundColor = .purpleColor()
            label.font = UIFont.systemFontOfSize(17)
        return label
    }()
    
    var date:UILabel = {
        let label = UILabel()
        label.backgroundColor = .purpleColor()
        label.font = UIFont.systemFontOfSize(15)
        return label
    }()
    
    lazy var postTitle:UIButton = {
        let btn = UIButton()
            btn.setTitle("POST TIEL ", forState: .Normal)
            btn.setTitleColor(buttonColor, forState: .Normal)
            btn.titleLabel?.textAlignment = .Left
        return btn
    }()
    
    
    var caption:UITextView = {
        let txt = UITextView()
        txt.textColor = .blackColor()
        txt.font = UIFont.systemFontOfSize(16)
        txt.scrollEnabled = false
        txt.editable = false
        txt.backgroundColor = .clearColor()
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    func handleLiking(sender: UIButton) {
        
        print("SALAM")
    }
    
    override func prepareForReuse() {
        
        like.setImage(UIImage(named: "empty-novel"), forState: .Normal)
        postTitle.setTitle(nil, forState: .Normal)
        username.text = nil
        date.text = nil
        caption.text = nil
    }
    
    override func setupView() {
        super.setupView()
        
        addSubview(postedImage)
        addSubview(like)
        addSubview(seperator)
        addSubview(profileImage)
        addSubview(username)
        addSubview(date)
        addSubview(postTitle)
        addSubview(caption)
        
        //PostedImage Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: postedImage)
        addConstrainstsWithFormat("V:[v0]", views: postedImage)
        
        //Heigh
        addConstraint(NSLayoutConstraint(item: postedImage, attribute: .Height, relatedBy: .Equal, toItem: postedImage, attribute: .Height, multiplier: 0, constant: HEIGHE_IMAGE))
        
        //Like Constraints
        addConstrainstsWithFormat("H:|[v0(150)]", views: like)
        addConstrainstsWithFormat("V:[v0(60)]", views: like)
        
        //Top
        addConstraint(NSLayoutConstraint(item: like, attribute: .Top, relatedBy: .Equal, toItem: postedImage, attribute: .Bottom, multiplier: 1, constant: 4))
        
        //Seperator Constraints
        addConstrainstsWithFormat("H:|-10-[v0]-10-|", views: seperator)
        addConstrainstsWithFormat("V:[v0(0.5)]", views: seperator)
        
        //Top
        addConstraint(NSLayoutConstraint(item: seperator, attribute: .Top, relatedBy: .Equal, toItem: like, attribute: .Bottom, multiplier: 1, constant: 10))
        
        addConstrainstsWithFormat("H:|-12-[v0(60)]|", views: profileImage)
        addConstrainstsWithFormat("V:[v0(60)]", views: profileImage)
        
        //Top
        addConstraint(NSLayoutConstraint(item: profileImage, attribute: .Top, relatedBy: .Equal, toItem: seperator, attribute: .Bottom, multiplier: 1, constant: 7))

        //username Constraints
        addConstrainstsWithFormat("H:[v0]", views: username)
        addConstrainstsWithFormat("V:[v0(20)]", views: username)
        
        //Top
        addConstraint(NSLayoutConstraint(item: username, attribute: .Top, relatedBy: .Equal, toItem: seperator, attribute: .Bottom, multiplier: 1, constant: 15))
        
        //Left
        addConstraint(NSLayoutConstraint(item: username, attribute: .Left, relatedBy: .Equal, toItem: profileImage, attribute: .Right, multiplier: 1, constant: 10))
        
        
        //Date Constraints
        addConstrainstsWithFormat("H:[v0]", views: date)
        addConstrainstsWithFormat("V:[v0(20)]", views: date)
        
        //Top
        addConstraint(NSLayoutConstraint(item: date, attribute: .Top, relatedBy: .Equal, toItem: username, attribute: .Bottom, multiplier: 1, constant: 10))
        
        //Left
        addConstraint(NSLayoutConstraint(item: date, attribute: .Left, relatedBy: .Equal, toItem: profileImage, attribute: .Right, multiplier: 1, constant: 10))
        
        //PostTitle Constraints
        addConstrainstsWithFormat("H:|-10-[v0]-10-|", views: postTitle)
        addConstrainstsWithFormat("V:[v0(40)]", views: postTitle)
        
        //Top
        addConstraint(NSLayoutConstraint(item: postTitle, attribute: .Top, relatedBy: .Equal, toItem: profileImage, attribute: .Bottom, multiplier: 1, constant: 10))
        
        //Caption Constraints
        addConstrainstsWithFormat("H:|-10-[v0]-10-|", views: caption)
        addConstrainstsWithFormat("V:[v0(40)]", views: caption)
        
        //Top
        addConstraint(NSLayoutConstraint(item: caption, attribute: .Top, relatedBy: .Equal, toItem: postTitle, attribute: .Bottom, multiplier: 1, constant: 10))
    }
}





