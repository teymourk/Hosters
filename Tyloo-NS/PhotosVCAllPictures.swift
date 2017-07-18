//
//  PhotosVCAllPictures.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/25/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MBProgressHUD

private let CELL_ID = "cellId"

class PhotosVCAllPictures: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var allPicturesArray:[PostImages]? {
        didSet {
            
            self.collectionView.reloadData()
        }
    }
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.registerClass(PhotosVCAllPicturesCell.self, forCellWithReuseIdentifier: CELL_ID)
            cv.backgroundColor = .clearColor()
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allPicturesArray?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as! PhotosVCAllPicturesCell
        
        cell.postsImages = allPicturesArray![indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
                        
        let imageFrame = frame.width / 3
        
        return CGSize(width: imageFrame, height: imageFrame)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        handlePushingPhotos()
    }
    
    var photosVC:PicturesVC?
    
    func handlePushingPhotos() {
        
        let allPicturesFeedVC = AllPicturesFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: allPicturesFeedVC)
        photosVC?.presentViewController(navController, animated: true, completion: nil)
    }
    
    func getAllPostedImages() {
        
        PostImages.getAllPhotos { (images) in
         
            self.allPicturesArray = images
        }
    }
    
    override func setupView() {
        super.setupView()
        
        getAllPostedImages()
        
        addSubview(collectionView)
        
        //CollectionView Constrains
        addConstrainstsWithFormat("H:|[v0]|", views: collectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: collectionView)
    }
}

class PhotosVCAllPicturesCell:BaseCell {
    
    var postsImages:PostImages? {
        didSet {
            if let coverImageURL = postsImages?.imageURL {
                _images.getImagesBack(coverImageURL, placeHolder: "emptyImage", loader: UIActivityIndicatorView())
            }
        }
    }
    
    var _images:UIImageView = {
        let cover = UIImageView()
        cover.contentMode = .ScaleToFill
        cover.translatesAutoresizingMaskIntoConstraints = false
        return cover
    }()
    
    override func setupView() {
        super.setupView()
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.whiteColor().CGColor
        
        addSubview(_images)
        
        //CoverPhoto Constrains
        addConstrainstsWithFormat("H:|[v0]|", views: _images)
        addConstrainstsWithFormat("V:|[v0]|", views: _images)
    }
}