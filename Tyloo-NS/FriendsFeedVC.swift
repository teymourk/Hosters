//
//  FriendsPostsView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/11/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MBProgressHUD

private let CELL_IDENTEFITER = "Cell"

class FriendsFeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfilePageDelegate {
        
    var frinedsPosts:[Posts]? {
        didSet{
            self.collectionView?.reloadData()
        }
    }

    lazy var profileInfo:ProfileInfo = {
        let pv = ProfileInfo()
            pv.delegate = self
            pv.friendsFeedVC = self
            pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()

    lazy var extendedNavBar:UINavigationBar = {
        let myProfile = UIBarButtonItem(image: UIImage(named: "Profile")?.imageWithRenderingMode(.AlwaysTemplate), style: .Plain, target: self, action: #selector(onMyProfile(_ :)))
        let navItems = UINavigationItem()
            navItems.leftBarButtonItems = [myProfile]
        let nb = UINavigationBar()
            nb.backgroundColor = darkGray
            nb.setItems([navItems], animated: false)
        return nb
        
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        collectionView?.backgroundColor = .whiteColor()
        collectionView?.contentInset = UIEdgeInsetsMake(34, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(34, 0, 0, 0)
        collectionView!.registerClass(FeedCell.self, forCellWithReuseIdentifier: CELL_IDENTEFITER)
        
        print(FEED_CELL_HEIGHT)
        
        loadAllData()
    }
    
    func loadAllData() {
        
        let progressHUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.setupExtendedNavBar()
            self.getFriendsFeed()
            progressHUD.hide(true)
        })
    }
        
    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frinedsPosts?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_IDENTEFITER, forIndexPath: indexPath) as! FeedCell
        
        cell.posts = frinedsPosts![indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
                
        return CGSizeMake(view.frame.width, FEED_CELL_HEIGHT)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        didSelectOnPost(indexPath)
    }
    
    //Pushing Post Information
    func didSelectOnPost(indexPath:NSIndexPath) {
        
        let post = frinedsPosts![indexPath.item]
        
        let layout = UICollectionViewFlowLayout()
        let activityAbout = ActivityAboutVC(collectionViewLayout: layout)
        activityAbout.postDetails = post
        activityAbout.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(activityAbout, animated: true)
    }
    
    //Friends Feed
    func getFriendsFeed() {
        
        FirebaseRef.Fb.REF_POSTS.observeEventType(.Value, withBlock: {
            snapshot in
            
            Posts.getFeedPosts(snapshot.value, completion: { (posts, nil) in
                
                //Filtering Friends from current User
                let filteredPosts = posts.filter({$0.poster != currentUser.key})
                self.frinedsPosts = filteredPosts
            })            
        })
    }
    
    //Mark: - SetupMenuBar
    func setupExtendedNavBar() {
        
        view.addSubview(extendedNavBar)
        
        //Exntended Nav Bar Constraints
        view.addConstrainstsWithFormat("H:|[v0]|", views: extendedNavBar)
        view.addConstrainstsWithFormat("V:|[v0(34)]", views: extendedNavBar)
        
        let settings = UIBarButtonItem(image: UIImage(named: "settings-1")?.imageWithRenderingMode(.AlwaysTemplate), style: .Plain, target: self, action: #selector(handleNavigationToSettings))
        
        navigationItem.rightBarButtonItem = settings
    
    }
    
    func handleNavigationToSettings() {
        
        let settingsView = SettingsVC()
        navigationController?.pushViewController(settingsView, animated: true)
    }

    func onSearch(sender: UIBarButtonItem) {
    
        let searchUsersVC = SearchUsersVC()
        navigationController?.pushViewController(searchUsersVC, animated: true)
    }
    
    //Mark: - ProfileInfo Setup
    
    //Mark: - UserProfileDelegate
    func onMyPosts(sender: UIButton) {
        
        profileInfo.handleDissMiss()
        let myPostVC = MyPostsVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(myPostVC, animated: true)
    }
    
    func onEditProfile(sender: UIButton) {
        
        profileInfo.handleDissMiss()
    }

    func onMyProfile(sender: UIBarButtonItem) {
    
        profileInfo.setupProfileView()
    }
}