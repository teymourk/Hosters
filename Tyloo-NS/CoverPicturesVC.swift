//
//  CoverPicturesVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/25/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "cellId"

class CoverPicturesVC: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var allCoversArray:[Posts]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .Horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.registerClass(CoverPicturesCell.self, forCellWithReuseIdentifier: CELL_ID)
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allCoversArray?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as! CoverPicturesCell
        
        cell.postsDetails = allCoversArray![indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(frame.width, frame.height)
    }
    
    //NEEDS FIX
    func scrollCoverPhotos() {
        
        for index in collectionView.indexPathsForVisibleItems() {
            
            let currentIndex = index.item + 1
            
            let index = NSIndexPath(forItem: currentIndex, inSection: 0)
            
            collectionView.scrollToItemAtIndexPath(index, atScrollPosition: .Left, animated: true)
            
            if currentIndex == (allCoversArray?.count)! - 1 {
                
                let index = NSIndexPath(forItem: 0, inSection: 0)
                self.collectionView.scrollToItemAtIndexPath(index, atScrollPosition: .Right, animated: true)
            }
        }
    }
    
    override func setupView() {
        super.setupView()
        
        NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: #selector(scrollCoverPhotos), userInfo: nil, repeats: true)
        
        getFriendsFeed()
        
        addSubview(collectionView)
        
        //CollectionView Constrains
        addConstrainstsWithFormat("H:|[v0]|", views: collectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: collectionView)
    }

    func getFriendsFeed() {
        
        FirebaseRef.Fb.REF_POSTS.observeEventType(.Value, withBlock: {
            snapshot in
            
            Posts.getFeedPosts(snapshot.value, completion: { (posts, nil) in
                
                //Filtering Friends from current User
                let filteredPosts = posts.filter({$0.poster != currentUser.key})
                self.allCoversArray = filteredPosts
            })
        })
    }
}

class CoverPicturesCell:BaseCell {
    
    var postsDetails:Posts? {
        didSet {
            if let coverImageURL = postsDetails?.backGround {
                _coverPhoto.getImagesBack(coverImageURL, placeHolder: "emptyImage", loader: UIActivityIndicatorView())
            }
            
            if let title = postsDetails?.postDescription {
                _title.text = title
            }
            
            guard let status =  postsDetails?.statusLight else {return}
            
            liveImage.hidden = status == true ? false : true
            liveLabel.hidden = status == true ? false : true
        }
    }
    
    var _coverPhoto:UIImageView = {
        let cover = UIImageView()
            cover.contentMode = .ScaleToFill
        return cover
    }()
    
    var liveLabel:UILabel = {
        let label = UILabel()
        label.text = "LIVE"
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
    
    var _title:UILabel = {
        let label = UILabel()
            label.textAlignment = .Center
            label.textColor = .whiteColor()
            label.font = UIFont.boldSystemFontOfSize(20)
        return label
    }()
    
    override func setupView() {
        super.setupView()

        addSubview(_coverPhoto)
        _coverPhoto.addSubview(_title)
        _coverPhoto.addSubview(liveLabel)
        _coverPhoto.addSubview(liveImage)
        
        //CoverPhoto Constrains
        addConstrainstsWithFormat("H:|[v0]|", views: _coverPhoto)
        addConstrainstsWithFormat("V:|[v0]|", views: _coverPhoto)
        
        //Live label and Image Constraints
        _coverPhoto.addConstrainstsWithFormat("H:[v0(10)]-10-|", views: liveImage)
        _coverPhoto.addConstrainstsWithFormat("V:|-10-[v0(10)]", views: liveImage)
        _coverPhoto.addConstrainstsWithFormat("V:|-6-[v0]", views: liveLabel)
        
        //Live label left
        _coverPhoto.addConstraint(NSLayoutConstraint(item: liveLabel, attribute: .Right, relatedBy: .Equal, toItem: liveImage, attribute: .Left, multiplier: 1, constant: -6))
        
        //CoverPhoto Constrains
        _coverPhoto.addConstrainstsWithFormat("H:|[v0]|", views: _title)
        _coverPhoto.addConstrainstsWithFormat("V:[v0]", views: _title)
        
        //CenterY
        _coverPhoto.addConstraint(NSLayoutConstraint(item: _title, attribute: .CenterY, relatedBy: .Equal, toItem: _coverPhoto, attribute: .CenterY, multiplier: 1, constant: 0))
    }
}
