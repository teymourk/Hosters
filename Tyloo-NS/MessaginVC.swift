//
//  MessaginVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/29/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class MessaginVC: UICollectionViewController {
    
    lazy var scroll:UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .whiteColor()
        navigationController?.navigationBar.translucent = false
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.backgroundColor = .whiteColor()
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        return 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        return cell
    }
}
