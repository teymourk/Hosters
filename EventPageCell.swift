//
//  EventPageCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/26/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CELL_ID"

class EventPageCell: BaseCell {

    lazy var guestCollectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0
            layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .white
            cv.register(GuestsCell.self, forCellWithReuseIdentifier: CELL_ID)
            cv.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
            cv.scrollIndicatorInsets = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    override func setupView() {
        
        addSubview(guestCollectionView)
        
        addConstrainstsWithFormat("H:|[v0]|", views: guestCollectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: guestCollectionView)
    }
}

extension EventPageCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Mark: CollectionView Delegate/DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? GuestsCell {
        
            return cell
        }
        
        return BaseCell()
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width,
                      height: frame.height / 13)
    }
}
