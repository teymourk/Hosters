//
//  AllPicturesFeedVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/1/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CellId"
private let HEADER_ID = "HeaderId"

class PostInfoAndPictures: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var postedImages:[PostImages]? {
        didSet {
            
            if postedImages?.count != nil {
            
                emptyText.removeFromSuperview()
                collectionView?.reloadData()
                
            } else {
                
                handleMessageWhenTheyAreNoImages()
            }
        }
    }
    
    var timer:Timer?
    var isGrid:Bool = Bool()
    
    var postDetails:Posts?
    var taggedUsers = [Users]()

    var pageNotification:PageNotifications = {
        let pn = PageNotifications()
        return pn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Pictures"
        navigationController?.navigationBar.isTranslucent = false
        collectionView!.register(AllPicturesFeedCell.self, forCellWithReuseIdentifier: CELL_ID)
        collectionView?.register(ActivityDetailsHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_ID)
        collectionView?.backgroundColor = .white
        
        let feedType = UIBarButtonItem(image: UIImage(named: "Grid"), style: .plain, target: self, action: #selector(onFeedType(_ :)))
        navigationItem.rightBarButtonItem = feedType
    }
    
    func onFeedType(_ sender: UIBarButtonItem) {
        
        if sender.image == UIImage(named: "Grid") {
            
            sender.image = UIImage(named: "List")
            isGrid = true
            collectionView?.reloadData()

        } else {
            
            sender.image = UIImage(named: "Grid")
            isGrid = false
            collectionView?.reloadData()
        }
    }
    
    //Mark: HeaderDelegate
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath) as! ActivityDetailsHeader
    
        cell.postDetails = postDetails
        cell.allphotosVC = self
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(10, 0, 0, 0)
    }
    
    var hasPeopleTagged:Bool = Bool()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 230)
        
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return postedImages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! AllPicturesFeedCell
    
        cell.postImages = postedImages![(indexPath as NSIndexPath).item]
        cell.allPicturesFeed = self
        cell.like.tag = (indexPath as NSIndexPath).item
        cell.menuOptions.tag = (indexPath as NSIndexPath).item
        cell.handleCellAnimation()
        cell.setCellShadow()
        
        if isGrid {
            
            cell.postedImage.removeFromSuperview()
            cell.setupGridView()
            
        } else {
            
            cell.postedImage.removeFromSuperview()
            cell.setupListView()
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return isGrid ? CGSize(width: view.frame.width/3, height: view.frame.width/3) : CGSize(width: view.frame.width, height: HEIGHE_IMAGE + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return isGrid ? 0 : 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    lazy var emptyText:UILabel = {
        let label = UILabel()
            label.textColor = darkGray
            label.font = UIFont(name: "Prompt", size: 17)
            label.text = "No Images For This Posts 😢"
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func handleMessageWhenTheyAreNoImages() {
        
        view.addSubview(emptyText)
        
        emptyText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func onCamera() {
        
        guard let postDetail = postDetails else {return}
        
        if postDetails?.status == false {
            
            let photoLibraryVC = PhotoLibrary()
            photoLibraryVC.postKey = postDetail.postKey
            
            let navController = UINavigationController(rootViewController: photoLibraryVC)
            self.present(navController, animated: true, completion: nil)
            return
        }
        
        
        let cameraVC = AddImages()
            cameraVC.activePostsDetails = postDetails
        
        let navController = UINavigationController(rootViewController: cameraVC)
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func handleLiking(_ sender:UIButton) {
        
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let post = postedImages![(indexPath as NSIndexPath).item]
        
        handleDealingWithFirebase(post, sender: sender)
    }
    
    func onMenuOptions(_ sender:UIButton) {
        
        let index = IndexPath(item: sender.tag, section: 0)
        let images = postedImages![(index as NSIndexPath).item]
        
        guard let postKey = postDetails?.postKey, let imageKey = images.imageKey else { return }
        
        let imagesRef = FirebaseRef.database.REF_PHOTO.child("\(postKey)/\(imageKey)")
        
        let alertController = UIAlertController(title: "Options", message: "Choose one of the following.", preferredStyle: .actionSheet)
        
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
    
    func handleDealingWithFirebase(_ post:PostImages, sender:UIButton) {
    
        guard let postKey = postDetails?.postKey else { return }
        
        let photoRef = FirebaseRef.database.REF_PHOTO.child("\(postKey)/\(post.imageKey!)/likes")
    
        //var likes = post.likes
        
        DispatchQueue.main.async(execute: {
            
            if sender.currentImage == UIImage(named: "novel_filled") {
                
                sender.setImage(UIImage(named: "novel-empty"), for: UIControlState())
                
                //likes?.removeValue(forKey: FirebaseRef.database.currentUser.key)
                //photoRef.setValue(likes)
                
            } else {
                
                sender.setImage(UIImage(named: "novel_filled"), for: UIControlState())
                photoRef.updateChildValues([FirebaseRef.database.currentUser.key: true])
            }
        })
    }
}
