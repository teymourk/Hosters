//
//  PostPictureCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 8/31/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData

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
        
        do {
            
            let request:NSFetchRequest<Posts> = Posts.fetchRequest()
            request.predicate = NSPredicate(format: "status = %@", NSNumber(booleanLiteral: true))
            
            try self.activePosts = context.fetch(request)
            
        } catch let err {
            print(err)
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
