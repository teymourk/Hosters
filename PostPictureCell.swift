//
//  PostPictureCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 8/31/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CELL_ID"

class PostPictureCell: BaseCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    var activePosts:[Posts]? {
        didSet {
            
            postPicturesForActivitiesCV.reloadData()
        }
    }
    
    var addOrPostVC:AddOrPost?
    
    lazy var postPicturesForActivitiesCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .white
            cv.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
            cv.scrollIndicatorInsets = UIEdgeInsetsMake(30, 0, 0, 0)
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    lazy var emptyText:UILabel = {
        let label = UILabel()
        label.textColor = darkGray
        label.font = UIFont(name: "Prompt", size: 17)
        label.text = "No Posts.Try Creating one 😍"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func handleSettingEmptyTextWhenNoPosts() {
        
        addSubview(emptyText)
        
        emptyText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emptyText.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return activePosts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! ActivePostsCell
        
        if let activePost = activePosts?[(indexPath as NSIndexPath).item] {
         
            cell.activePosts = activePost
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width, height: FEED_CELL_HEIGHT/4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let post = activePosts?[(indexPath as NSIndexPath).item] {
            
            let cameraVC = AddImages()
                cameraVC.activePostsDetails = post
            let navController = UINavigationController(rootViewController: cameraVC)
            addOrPostVC?.present(navController, animated: true, completion: nil)

        }
    }
   
    func handleFetchingActivePosts() {
        
        Posts.getFeedPosts(UIRefreshControl()) { (posts, nil) in

            let currentUserUID = FirebaseRef.database.currentUser.key

            let currentUserPostsFilter = posts.filter({$0.poster == currentUserUID})

            //Get Active Posts
            let activePostFilter = currentUserPostsFilter.filter({$0.statusLight == true})

            if activePostFilter.count != 0 {
                self.activePosts = activePostFilter
                self.emptyText.removeFromSuperview()
                
            } else{
                self.handleSettingEmptyTextWhenNoPosts()
            }
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        handleFetchingActivePosts()
    }
    
    override func setupView() {
        super.setupView()
        
        postPicturesForActivitiesCV.register(ActivePostsCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        addSubview(postPicturesForActivitiesCV)
        
        addConstrainstsWithFormat("H:|[v0]|", views: postPicturesForActivitiesCV)
        addConstrainstsWithFormat("V:|[v0]|", views: postPicturesForActivitiesCV)
    }
}
