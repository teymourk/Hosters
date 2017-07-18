//
//  EventsCells.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/25/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit


class HomeCVCell: BaseCollectionViewCell  {
 
    let CELL_ID = "CELL_ID"
    
    var events:[Events]? {
        didSet {
            eventCollectionView.reloadData()
        }
    }

    lazy var eventCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .white
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    weak var homePage:HomePage?
    
    override func setupView() {
        
        handleCVOptions()
        setupCollectionView()
    }
    
    internal func setupCollectionView() {
        
        addSubview(eventCollectionView)
        
        addConstrainstsWithFormat("H:|[v0]|", views: eventCollectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: eventCollectionView)
    }
    
    internal func handleCVOptions() {
        
        eventCollectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 0)
        eventCollectionView.register(EventsCell.self, forCellWithReuseIdentifier: CELL_ID)
    }
}
