//
//  PostPicturesVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/13/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "Cell"

class ActivityAboutVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var postDetails: Posts? {
        didSet{
            
            title = postDetails?.postDescription
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.collectionView!.registerClass(ActivityAboutCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.collectionView?.pagingEnabled = true
        self.collectionView?.bounces = false
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 2
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as! ActivityAboutCell
        
        cell.postDetais = postDetails
        cell.getIndexPathForCells(indexPath.item)
        cell.activityAboutVC = self
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, view.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}