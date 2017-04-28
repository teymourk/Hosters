//
//  EventsCells.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/25/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CELL_FEED"

class HomeCVCell: BaseView  {
    
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
            cv.register(EventsCell.self, forCellWithReuseIdentifier: CELL_ID)
            cv.contentInset = UIEdgeInsetsMake(-20, 10, 0, 0)
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    var homePage:HomePage?

    override func setupView() {
        
        addSubview(eventCollectionView)
        
        addConstrainstsWithFormat("H:|[v0]|", views: eventCollectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: eventCollectionView)
    }
}

extension HomeCVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //Mark: CollectionView Delegate/DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return events?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? EventsCell {
            
            if let eventDetails = events?[indexPath.item] {
            
                cell._eventDetails = eventDetails
            }
            
            return cell
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let homePage = homePage else {return}
        
        if let eventObj = events?[indexPath.item] {
        
            homePage.navigateToEventDetails(eventDetail: eventObj)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (frame.width) - (frame.width / 7),
                      height: FEED_CELL_HEIGHT - 70)
    }
}
