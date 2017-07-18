//
//  MyPostsVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/15/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "Cell"

class MyPostsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var myPosts: [Posts]? {
        didSet {
            
            collectionView?.reloadData()
        }
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
            mb.myFeedVC = self
        return mb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        title = "My Posts"
        self.collectionView?.backgroundColor = .whiteColor()
        self.collectionView?.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        self.collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        self.collectionView!.registerClass(FeedCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        
        getMyPosts()
        setupMenuBar()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPosts?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as! FeedCell

        cell.posts = myPosts![indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, FEED_CELL_HEIGHT)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        didSelectOnPost(indexPath)
    }
    
    //Pushing Post Information
    func didSelectOnPost(indexPath:NSIndexPath) {
        
        let post = myPosts![indexPath.item]
        
        let layout = UICollectionViewFlowLayout()
        let activityAbout = ActivityAboutVC(collectionViewLayout: layout)
        activityAbout.postDetails = post
        activityAbout.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(activityAbout, animated: true)
    }
    
    func getMyPosts() {
        
        FirebaseRef.Fb.REF_POSTS.observeEventType(.Value, withBlock: {
            snapshot in
            
            if snapshot.value != nil {
            
                Posts.getFeedPosts(snapshot.value, completion: { (post, nil) in
                    
                    let filteredPost = post.filter({$0.poster == currentUser.key})
                    self.myPosts = filteredPost
                })
                
            } else {
                
                print("EMPTY MY POST")
            }
        })
    }
    
    //Mark: - SetupMenuBar
    func setupMenuBar() {
        
        view.addSubview(menuBar)
        
        //Menubar Constraints
        view.addConstrainstsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstrainstsWithFormat("V:|[v0(40)]", views: menuBar)
    }
}
