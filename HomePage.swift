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

class HomePage: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    var userPosts:[Posts]? {
        didSet{
        
            collectionView?.reloadData()
        }
    }
     
    var postImages = [String:[PostImages]]()
    var reloadTimer:Timer?
    
    lazy var locationManager:CLLocationManager? = {
        let manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()

    lazy var refreshController:UIRefreshControl = {
        let refresher = UIRefreshControl()
            refresher.tintColor = .gray
            refresher.addTarget(self, action: #selector(onRefreshPage), for: .valueChanged)
        return refresher
    }()
    
    let pageNotification:PageNotifications = {
        let notification = PageNotifications()
        return notification
    }()
    
    lazy var picturesForPosts:PicturesInsideCell? = {
        let postPictures = PicturesInsideCell()
        return postPictures
    }()
    
    func onRefreshPage() {
    
        if Reachability.isInternetAvailable() {
        
        getPostsData.getPostsFromFireBase()
        perform(#selector(fetchPostsFromData), with: nil, afterDelay: 0.5)
            
        } else {
            
            pageNotification.showNotification("Not Connected To The Internet 😭")
            refreshController.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        collectionView?.backgroundColor = UIColor(white: 0.90, alpha: 1)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: CELL_IDENTEFITER)
        collectionView?.alwaysBounceVertical = true
        collectionView?.addSubview(refreshController)
        
        locationManager?.requestWhenInUseAuthorization()
        setupOrangeSeperator()
        
        perform(#selector(fetchPostsFromData), with: nil, afterDelay: 1)
        
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTEFITER, for: indexPath) as? FeedCell {
        
            if let posts = userPosts?[(indexPath as NSIndexPath).row] {

                cell.postsDetails = posts
                cell.friendsFeedView = self
                cell.menuOptions.tag = (indexPath as NSIndexPath).item
                cell.feedAllPhotosVC.index = indexPath
                pushImages(cell, posts: posts)
            }
    
            return cell
        }
    
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: FEED_CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        didSelectOnPost(indexPath)
    }
 
    fileprivate func pushImages(_ cell:FeedCell, posts:Posts) {
        
        if let postKey = posts.postKey {
            
            let imagesArray = postImages[postKey]
            
            cell.feedAllPhotosVC.allImages = imagesArray
        }
    }
    
    //Pushing Post Information
    func didSelectOnPost(_ indexPath:IndexPath) {
        
        if let post = userPosts?[(indexPath as NSIndexPath).item] {
            
            if let postKey = post.postKey {
             
                let imagesArray = postImages[postKey]
                
                let activityAbout = PostInfoAndPictures(collectionViewLayout: UICollectionViewFlowLayout())
                    activityAbout.postDetails = post
                    activityAbout.postedImages = imagesArray
                
                navigationController?.pushViewController(activityAbout, animated: true)
            }
        }
    }
    
    fileprivate func handlePushingIntoAllPhotosFeed(_ key:String) {
        
        let photosFeed = PostInfoAndPictures(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(photosFeed, animated: true)
    }
    
    func onNotifications(_ sender:UIBarButtonItem) {
    
        let notificationVC = Notifications()
        navigationController?.pushViewController(notificationVC, animated: true)
    }
        
    lazy var updatePostView:EditPost = {
        let up = EditPost()
            up.friendsFeed = self
        return up
    }()
    
    func onMenuOptions(_ sender:UIButton) {
        
        let index = IndexPath(item: sender.tag, section: 0)
        let post = userPosts![(index as NSIndexPath).item]
        guard let postkey = post.postKey else {return}
        
        let postRef = FirebaseRef.database.REF_POSTS.child(postkey)
        
        let alertConteoller = UIAlertController(title: "Option", message: "Please choose one of the followings.", preferredStyle: .actionSheet)
        
        if post.poster == FirebaseRef.database.currentUser.key {
            
            alertConteoller.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
                alert in
                
                postRef.removeValue()
                self.pageNotification.showNotification("Post Successfully Removed 👍")
                self.userPosts?.remove(at: (index as NSIndexPath).item)
                
            }))
            
            alertConteoller.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: {
                alert in
                
                guard let description = post.postDescription else {return}
                
                self.updatePostView.showMenu(description, privacy: "")
                self.updatePostView.postKey = post.postKey
                
            }))
            
            if post.status == true {
            
                let postRef = FirebaseRef.database.REF_POSTS.child("\(post.postKey!)")
                let timeEnded:CGFloat = CGFloat(Date().timeIntervalSince1970)
            
                alertConteoller.addAction(UIAlertAction(title: "End Posting", style: .default, handler: {
                    alert in
                    
                    self.pageNotification.showNotification("Post Ended. Users can no longer Post Images 😭")
                    postRef.updateChildValues(["Status":false])
                    postRef.updateChildValues(["TimeEnded":timeEnded])

                }))
            }
            
            alertConteoller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                alert in
                
            }))
            
        } else {
            
            alertConteoller.addAction(UIAlertAction(title: "Request To Join", style: .default, handler: {
                alert in
                
                self.pageNotification.showNotification("Request Sent To Host. Please Wait on their response 🙇")
                
            }))
            
            alertConteoller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                alert in
                
            }))
        }
        
        self.present(alertConteoller, animated: true, completion: nil)
    }
    
    func handleSettingExistinPostImages(_ allPosts:[Posts], allImages:[PostImages]?) {
        
        for post in allPosts {
            
            if let filteredImages = allImages?.filter({$0.postKey == post.postKey}) {
                
                for value in filteredImages.enumerated() {
                    
                    guard let postKey = value.element.postKey else {return}
                    
                    self.postImages[postKey] = filteredImages
                }
            }
        }
    }
    
    
    var orangeSeperator:UIView = {
        let seperator = UIView()
            seperator.backgroundColor = orange
            seperator.translatesAutoresizingMaskIntoConstraints = false
        return seperator
    }()
    
    lazy var emptyPostLabel:UILabel = {
        let label = UILabel()
            label.textColor = darkGray
            label.font = UIFont(name: "Prompt", size: 17)
            label.text = "No Posts.Try Inviting Your Friend 💩 🙄"            
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var inviteContact:UIButton = {
        let button = UIButton()
            button.setTitle("Invite Your Contact", for: UIControlState())
            button.titleLabel?.font = UIFont(name: "NotoSans", size: 20)
            button.setTitleColor(.white, for: UIControlState())
            button.setBackgroundImage(UIImage(named: "signin"), for: UIControlState())
            button.addTarget(self, action: #selector(self.onInviteContact(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func onInviteContact(_ sender:UIButton) {
        
        pageNotification.showNotification("WORKING ON THE FEATURE")
    }
    
    func setupOrangeSeperator() {
        
        view.addSubview(orangeSeperator)
        
        orangeSeperator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        orangeSeperator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        orangeSeperator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func handlePageWhenTheyAreNoPosts() {
        
        view.addSubview(emptyPostLabel)
        view.addSubview(inviteContact)
        
        emptyPostLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyPostLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        inviteContact.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inviteContact.topAnchor.constraint(equalTo: emptyPostLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    func fetchPostsFromData() {
        
        do {
            
            let fetchRequest: NSFetchRequest<Posts> = Posts.fetchRequest()
            let imageRequest: NSFetchRequest<PostImages> = PostImages.fetchRequest()
            
            try self.userPosts = (context.fetch(fetchRequest))
            let imagesArray = try(context.fetch(imageRequest))
            
            guard let postsArray = userPosts else {return}

            self.handleSettingExistinPostImages(postsArray, allImages: imagesArray)
            
        } catch let err {
            print(err)
        }
        
        refreshController.endRefreshing()
    }
}
