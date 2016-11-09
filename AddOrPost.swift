//
//  AddOrPost.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 8/7/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CELL_ID"
private let CREATE_NEW = "CREATE_ID"
private let ENDED_POST_ID = "Ended_ID"

class AddOrPost: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var activePosts:[Posts]? {
        didSet{
            activePostsCollectionView.reloadData()
        }
    }
    
    var endedPosts:[Posts]? {
        didSet{
            activePostsCollectionView.reloadData()
        }
    }
    
    lazy var activePostsCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.translatesAutoresizingMaskIntoConstraints = false
            cv.backgroundColor = UIColor(white: 0.82, alpha: 1)
            cv.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
            cv.scrollIndicatorInsets = UIEdgeInsetsMake(40, 0, 0, 0)
            cv.isPagingEnabled = true
            cv.showsHorizontalScrollIndicator = false
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    

    var peopleTagged:peopleWith = {
        let pw = peopleWith()
        return pw
    }()
    
    
    var userHasActivePost:Bool? = Bool()
    var postKey:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activePostsCollectionView.register(PostPictureCell.self, forCellWithReuseIdentifier: CELL_ID)
        activePostsCollectionView.register(EndedPostCell.self, forCellWithReuseIdentifier: ENDED_POST_ID)
        activePostsCollectionView.register(CreatePostCell.self, forCellWithReuseIdentifier: CREATE_NEW)
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white
        
        setupView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if (indexPath as NSIndexPath).item == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ENDED_POST_ID, for: indexPath) as! EndedPostCell
            setupGuideLabel("Add Image To Activity That Ended via Photo Library")
            cell.addOrPostVC = self
            return cell
        }
        
        if (indexPath as NSIndexPath).item == 2 {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CREATE_NEW, for: indexPath) as! CreatePostCell
            setupGuideLabel("Check-In")
            cell.addOrdPostVC = self

            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! PostPictureCell
        setupGuideLabel("Add Image To An Existing Activity Happening Now")
        cell.addOrPostVC = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        menuBar.horizontalBarLeftAncherContraint?.constant = scrollView.contentOffset.x / 3
    }
    
    fileprivate func showAlert(_ postKey:String) {
        
        let alertController = UIAlertController(title: "Warning", message: "You have an active post. You must end it this one to create an new one.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            
            let index = IndexPath(item: 0, section: 0)
            
            self.menuBar.menuCollectionView.selectItem(at: index, animated: true, scrollPosition: UICollectionViewScrollPosition())
            self.scrollToMenuIndex(0)
        }))
        
        alertController.addAction(UIAlertAction(title: "End Current Post", style: .destructive, handler: { (alert) in
            
            let postRef = FirebaseRef.database.REF_POSTS.child("\(postKey)")
            let timeEnded:CGFloat = CGFloat(Date().timeIntervalSince1970)
            postRef.updateChildValues(["Status":false])
            postRef.updateChildValues(["TimeEnded":timeEnded])
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    let menuItems = ["Active Posts", "Ended Posts", "Create New"]
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.menuCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        
        self.view.endEditing(true)
        
        navigationItem.title = menuItems[Int(index)]
    }
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        
        let indexPath = IndexPath(item: menuIndex, section: 0)
        activePostsCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }
    
    lazy var menuBar:MenuBar = {
        let mb = MenuBar()
            mb.menuItems = ["Active Posts", "Ended Posts", "Create New"]
            mb.addOrPostVC = self
        return mb
    }()
    
    let guideLabel:UILabel = {
        let label = UILabel()
            label.backgroundColor = darkGray
            label.font = UIFont(name: "NotoSans", size: 14)
            label.textAlignment = .center
            label.textColor = .white
        return label
    }()
    
    func setupGuideLabel(_ guide:String) {
        
        view.addSubview(guideLabel)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: guideLabel)
        view.addConstrainstsWithFormat("V:[v0(30)]", views: guideLabel)
        
        view.addConstraint(NSLayoutConstraint(item: guideLabel, attribute: .top, relatedBy: .equal, toItem: menuBar, attribute: .bottom, multiplier: 1, constant: 0))
        
        guideLabel.text = guide
    }
    
    func setupView() {
        
        view.backgroundColor = UIColor(white: 0.82, alpha: 1)
        
        view.addSubview(menuBar)
        view.addSubview(activePostsCollectionView)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstrainstsWithFormat("V:|[v0(40)]", views: menuBar)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: activePostsCollectionView)
        view.addConstrainstsWithFormat("V:|-40-[v0]|", views: activePostsCollectionView)

    }
}
