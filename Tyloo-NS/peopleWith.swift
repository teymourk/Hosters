//
//  peopleWith.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/18/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "Cell"

class peopleWith: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var taggedUsersArray:[Users]? {
        didSet{
            peopleWith.reloadData()
        }
    }

    lazy var peopleWith:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(14, -14, 0, 0)
        layout.scrollDirection = .Horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cv.alwaysBounceVertical = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return taggedUsersArray?.count ?? 0
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as! PeopleWithCell
        
        cell.taggedUsers = taggedUsersArray![indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 90)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return -30
    }
    
    override func setupView() {
        super.setupView()
        
    
        addSubview(peopleWith)
    
        //peopleWithConstraints
        addConstrainstsWithFormat("H:|[v0]|", views: peopleWith)
        addConstrainstsWithFormat("V:|[v0]|", views: peopleWith)
        
        self.peopleWith.registerClass(PeopleWithCell.self, forCellWithReuseIdentifier: CELL_ID)
    }
}