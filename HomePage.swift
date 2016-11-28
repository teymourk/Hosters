//
//  FriendsPostsView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/11/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MBProgressHUD
import MapKit
import CoreData

private let CELL_IDENTEFITER = "Cell"
private let HEADER_ID = "HeaderId"

class HomePage: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate, PicturesInsideCellDelegate {
    
    var postImages = [String:[PostImages]]()
    
//    lazy var refreshController:UIRefreshControl = {
//        let refresher = UIRefreshControl()
//        refresher.tintColor = .gray
//        refresher.addTarget(self, action: #selector(onRefreshPage), for: .valueChanged)
//        return refresher
//    }()
    
    lazy var locationManager:CLLocationManager? = {
        let manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()

    let pageNotification:PageNotifications = {
        let notification = PageNotifications()
        return notification
    }()
    
    lazy var picturesForPosts:PicturesInsideCell? = {
        let postPictures = PicturesInsideCell()
        return postPictures
    }()
    
    let noPostView:NoPostsView = {
        let NP = NoPostsView()
        return NP
    }()
    
    func onRefreshPage() {
    
        if Reachability.isInternetAvailable() {
        
        } else {
            
            pageNotification.showNotification("Not Connected To The Internet 😭")
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        collectionView?.backgroundColor = .white
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: CELL_IDENTEFITER)
        collectionView?.alwaysBounceVertical = true
        //collectionView?.addSubview(refreshController)
        
        locationManager?.requestWhenInUseAuthorization()
        setupSeperator()
    
        perform(#selector(fetchPostsFromData), with: nil, afterDelay: 2)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fetchController.sections?[0].numberOfObjects ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTEFITER, for: indexPath) as? FeedCell {
        
            let posts = fetchController.object(at: indexPath)

            cell.postsDetails = posts
            cell.menuOptions.tag = (indexPath as NSIndexPath).item
            cell.feedAllPhotosVC.postKey = posts.postKey
            cell.feedAllPhotosVC.delegate = self
            cell.friendsFeedView = self
            cell.setCellShadow()
            
            return cell
        }
    
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: FEED_CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 15,
                            left: 0, bottom: 0, right: 0)
    }

    func onMenuOptions(_ sender:UIButton) {
        
        let index = IndexPath(item: sender.tag, section: 0)
        let post = fetchController.object(at: index)
        guard let postkey = post.postKey else {return}
        
        let postRef = FirebaseRef.database.REF_POSTS.child(postkey)
        
        let alertConteoller = UIAlertController(title: "Option", message: "Please choose one of the followings.", preferredStyle: .actionSheet)
            alertConteoller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if post.poster == FirebaseRef.database.currentUser.key {
            
            alertConteoller.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: {
                alert in
            
            }))
            
            if post.status == true {
            
                let postRef = FirebaseRef.database.REF_POSTS.child("\(post.postKey!)")
                let timeEnded:CGFloat = CGFloat(Date().timeIntervalSince1970)
            
                alertConteoller.addAction(UIAlertAction(title: "End Posting", style: .destructive, handler: {
                    alert in
                    
                    self.pageNotification.showNotification("Post Ended. Users can no longer Post Images 😭")
                    postRef.updateChildValues(["Status":false])
                    postRef.updateChildValues(["TimeEnded":timeEnded])

                }))
            }
            
            alertConteoller.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
                alert in
                
                postRef.removeValue()
                self.pageNotification.showNotification("Post Successfully Removed 👍")
                
            }))
            
        } else {
            
            alertConteoller.addAction(UIAlertAction(title: "Request To Join", style: .default, handler: {
                alert in
                
                self.pageNotification.showNotification("Request Sent To Host. Please Wait on their response 🙇")
                
            }))
        }
        
        self.present(alertConteoller, animated: true, completion: nil)
    }
    
    var seperator:UIView = {
        let seperator = UIView()
            seperator.backgroundColor = orange
            seperator.translatesAutoresizingMaskIntoConstraints = false
        return seperator
    }()
        
    func setupSeperator() {
        
        view.addSubview(seperator)
        
        seperator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant:2).isActive = true
        seperator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func setupNoPostView(text:String) {
        
        view.addSubview(noPostView)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: noPostView)
        view.addConstrainstsWithFormat("V:|[v0]|", views: noPostView)
        
        noPostView.emptyPostLabel.text = text
    }
    
    lazy var fetchController:NSFetchedResultsController<Posts> = {
        let fetch: NSFetchRequest<Posts> = Posts.fetchRequest()
            fetch.sortDescriptors = [NSSortDescriptor(key: "timePosted", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            frc.delegate = self
        return frc
    }()
    
    lazy var fetchControllers:NSFetchedResultsController<PostImages> = {
        let fetch: NSFetchRequest<PostImages> = PostImages.fetchRequest()
            fetch.sortDescriptors = [NSSortDescriptor(key: "timePosted", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            frc.delegate = self
        return frc
    }()
    
    func fetchPostsFromData() {
        
        do {
            
            try fetchController.performFetch()
            
            
            if fetchController.sections?[0].numberOfObjects == 0 {
                //setupNoPostView(text: "No Posts.Try Inviting Your Friend 💩 🙄")
            }
                    
        } catch let error {
            print("ERROR IS \(error)")
        }
        
        collectionView?.reloadData()
    }
    
    var operations = [BlockOperation]()
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView?.performBatchUpdates({
            
            for operation in self.operations {
                operation.start()
            }
            
        }, completion: nil)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let indexPath = newIndexPath {
            
            switch type {
                
            case .insert:
                operations.append(BlockOperation(block: {
                    self.collectionView?.insertItems(at: [indexPath])
                    
                    if self.noPostView.isDescendant(of: self.view) {
                        self.noPostView.removeFromSuperview()
                    }
                    
                }))
                
                break
            case .delete:
                collectionView?.deleteItems(at: [indexPath])
                break
                
            default: break
            }
        }
    }
    
    //MARK: PicturesInsideCell Delegate
    
    func onImages(images: [PostImages]) {
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
        let postImages = PostInfoAndPictures(collectionViewLayout: layout)
        postImages.postedImages = images
        
        navigationController?.present(postImages, animated: false, completion: nil)
    }
}
