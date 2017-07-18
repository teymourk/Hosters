//
//  AccessCamera_PhotoLibraryVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/27/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CellID"

class AccessCamera_PhotoLibraryVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerClass(AccessCamera_PhotoLibraryCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.collectionView?.backgroundColor = darkGray
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as! AccessCamera_PhotoLibraryCell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3, height: view.frame.height/3)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}

class AccessCamera_PhotoLibraryCell:BaseCell {
    
    var _images:UIImageView = {
        let image = UIImageView()
            image.contentMode = .ScaleToFill
            image.backgroundColor = .lightGrayColor()
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func setupView() {
        super.setupView()
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.whiteColor().CGColor
        
        addSubview(_images)
        
        //CoverPhoto Constrains
        addConstrainstsWithFormat("H:|[v0]|", views: _images)
        addConstrainstsWithFormat("V:|[v0]|", views: _images)
    }
}
