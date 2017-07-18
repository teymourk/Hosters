//
//  MenuBar.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/12/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "Cell"

class  MenuBar: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let menuItems = ["Posts", "Photos"]
    
    var myFeedVC:MyPostsVC?
    var friendsFeedVC:FriendsFeedVC?
    
    lazy var menuCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = darkGray
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as! MenuBarCell
        
        cell.menuLabel.text = menuItems[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(frame.width/3, frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
    }
    
    override func setupView() {
        super.setupView()
        
        let selectedIndex = NSIndexPath(forItem: 0, inSection: 0)
        menuCollectionView.selectItemAtIndexPath(selectedIndex, animated: false, scrollPosition: .None)
        
        
        menuCollectionView.registerClass(MenuBarCell.self, forCellWithReuseIdentifier: CELL_ID)
        addSubview(menuCollectionView)

        //CollectionView Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: menuCollectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: menuCollectionView)

    }
}

class MenuBarCell: BaseCell {
    
    var menuLabel:UILabel = {
        let label = UILabel()
            label.textAlignment = .Center
            label.textColor = .whiteColor()
            label.font = UIFont.boldSystemFontOfSize(20)
        return label
    }()
    
    override var highlighted: Bool {
        didSet {
            menuLabel.textColor = highlighted ? goldColor : .whiteColor()
        }
    }
    
    override var selected: Bool {
        didSet {
            menuLabel.textColor = selected ? goldColor : .whiteColor()
        }
    }
    
    override func setupView() {
        super.setupView()
        
        addSubview(menuLabel)
        
        //Icons Constraints
        addConstrainstsWithFormat("H:[v0(90)]", views: menuLabel)
        addConstrainstsWithFormat("V:[v0(30)]", views: menuLabel)
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: menuLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: menuLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    }
}

