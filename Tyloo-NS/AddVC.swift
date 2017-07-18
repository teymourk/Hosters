//
//  Add_CreateView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/12/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CELL_ID"

class AddView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var activePosts:[Posts]? {
        didSet{
            activePostsCollectionView.reloadData()
        }
    }
   
    lazy var activePostsCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.translatesAutoresizingMaskIntoConstraints = false
            cv.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
            cv.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 0, 0)
            cv.backgroundColor = UIColor(white: 0.82, alpha: 1)
            cv.alwaysBounceVertical = true
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activePosts?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as! ActivePostsCell
        
        cell.activePosts = activePosts![indexPath.item]
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, FEED_CELL_HEIGHT/2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        getActivePostDetails(indexPath)
    }
    
    func getActivePostDetails(indexPath:NSIndexPath) {
    
        let posts = activePosts![indexPath.item]
        
        let addImageVC = AddImageCameraVC()
            addImageVC.activePostsDetails = posts
            navigationController?.presentViewController(addImageVC, animated: true, completion: nil)
    }
    
    func getActivePosts() {
        
        FirebaseRef.Fb.REF_POSTS.observeEventType(.Value, withBlock: {
            snapshot in
            
            Posts.getFeedPosts(snapshot.value, completion: { (nil, activePosts) in
                
                self.activePosts = activePosts
                
            })
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activePostsCollectionView.registerClass(ActivePostsCell.self, forCellWithReuseIdentifier: CELL_ID)
        navigationController?.navigationBar.translucent = false
        view.backgroundColor = .whiteColor()
        
        setupView()
        setupGuideView()
        getActivePosts()
    }
    
    func onCreateNew(sender:UIBarButtonItem) {
        
        let createVC = CreatePostVC()
        createVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    var guideLabel:UILabel = {
        let label = UILabel()
        label.text = "Or, Add Your photo to an existing event happening now"
        label.textColor = .whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var checkIn:UIButton = {
        let btn = UIButton()
            btn.setImage(UIImage(named: "create_new_filled")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            btn.setTitle("Check-In", forState: .Normal)
            btn.titleEdgeInsets = UIEdgeInsetsMake(4, 6, 0, 0)
            btn.titleLabel?.font = UIFont.systemFontOfSize(16)
            btn.setTitleColor(UIColor.rgb(25, green: 136, blue: 251), forState: .Normal)
            btn.addTarget(self, action: #selector(onCreateNew(_ :)), forControlEvents: .TouchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var guideView:UIView = {
        let view = UIView()
        view.backgroundColor = darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    func setupGuideView() {
    
        view.addSubview(guideView)
        guideView.addSubview(guideLabel)
        guideView.addSubview(checkIn)
        
        //GuideView Constraints
        view.addConstrainstsWithFormat("H:|[v0]|", views: guideView)
        view.addConstrainstsWithFormat("V:|[v0(80)]", views: guideView)
        
        //Check-In Cosntrains
        guideView.addConstrainstsWithFormat("H:|-4-[v0(100)]", views: checkIn)
        guideView.addConstrainstsWithFormat("V:|-3-[v0(30)]", views: checkIn)
        
        //GuideLabe Constraints
        guideView.addConstrainstsWithFormat("H:|[v0]|", views: guideLabel)
        guideView.addConstrainstsWithFormat("V:[v0]-10-|", views: guideLabel)
    }
    
    func setupView() {
        
        view.backgroundColor = UIColor(white: 0.82, alpha: 1)
        
        //view.addSubview(createNew)
        view.addSubview(guideLabel)
        view.addSubview(activePostsCollectionView)
    
        //ActivePosts Constrains
        view.addConstrainstsWithFormat("H:|[v0]|", views: activePostsCollectionView)
        view.addConstrainstsWithFormat("V:[v0]|", views: activePostsCollectionView)
     
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: activePostsCollectionView, attribute: .Top, relatedBy: .Equal, toItem: guideLabel, attribute: .Bottom, multiplier: 1, constant: 0))
    }
}