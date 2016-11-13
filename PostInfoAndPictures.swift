//
//  AllPicturesFeedVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/1/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CellId"
private let HEADER_ID = "HeaderId"

class PostInfoAndPictures: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var postedImages:[PostImages]? {
        didSet {
            
            collectionView?.reloadData()
        }
    }
    
    var postDetails:Posts?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView!.register(AllPicturesFeedCell.self, forCellWithReuseIdentifier: CELL_ID)
        collectionView?.backgroundColor = .white
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return postedImages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! AllPicturesFeedCell
    
        cell.postImages = postedImages![(indexPath as NSIndexPath).item]
        cell.allPicturesFeed = self
        cell.setCellShadow()
        cell.setupListView()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
