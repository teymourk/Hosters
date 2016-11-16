//
//  AllPicturesFeedVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/1/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData

private let CELL_ID = "CellId"
private let HEADER_ID = "HeaderId"

class PostInfoAndPictures: UICollectionViewController, UICollectionViewDelegateFlowLayout, AllPostsImagesDelegate {
    
    var postedImages:[PostImages]? {
        didSet {
            
            collectionView?.reloadData()
        }
    }
    
    var postDetails:Posts?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView!.register(AllPicturesFeedCell.self, forCellWithReuseIdentifier: CELL_ID)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isScrollEnabled = false
        collectionView?.isPagingEnabled = true

    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return postedImages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! AllPicturesFeedCell
    
        cell.postImages = postedImages![(indexPath as NSIndexPath).item]
        cell.menuOptions.tag = indexPath.item
        cell.delegate = self
        cell.allPicturesFeed = self
        cell.setCellShadow()
        cell.setupListView()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    var pageNotification:PageNotifications = {
        let pn = PageNotifications()
        return pn
    }()
    
    func onImages(sender: UITapGestureRecognizer) {
        
        var currentIndex:Int?
        
        if let index = collectionView?.indexPathsForVisibleItems {
            
            for visibleIndex in index {
                
                currentIndex = visibleIndex.item
            }
            
            currentIndex = currentIndex! + 1
            
            guard let imagesCount = postedImages?.count, let indexCount = currentIndex else {return}
            
            if currentIndex == imagesCount {
                
                self.dismiss(animated: true, completion: nil)
                
            } else {
                
                let indexPath = IndexPath(item: indexCount, section: 0)
                collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
            }
        }
    }
    
    func onImageSwipe(sender: UISwipeGestureRecognizer) {
        
        print("SALAM")
    }
    
    func onMenu(_ sender: UIButton) {
        
        let index = IndexPath(item: sender.tag, section: 0)
        let images = postedImages![(index as NSIndexPath).item]
        
        guard let postKey = postDetails?.postKey, let imageKey = images.imageKey else { return }
        
        let imagesRef = FirebaseRef.database.REF_PHOTO.child("\(postKey)/\(imageKey)")
        
        let alertController = UIAlertController(title: "Options", message: "Choose one of the following.", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "View Details", style: .default, handler: {
            alert in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        if images.poster == FirebaseRef.database.currentUser.key {
            
            alertController.addAction(UIAlertAction(title: "Delete Image", style: .destructive, handler: {
                alert in
                
                imagesRef.removeValue()
                self.postedImages?.remove(at: index.item)
                self.pageNotification.showNotification("Images Was Successfully Removed.")
                
            }))
            
        } else {
            
            alertController.addAction(UIAlertAction(title: "Report Image", style: .default, handler: {
                alert in
                
                self.pageNotification.showNotification("Thank You. Image was reported")
                
            }))
            
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
