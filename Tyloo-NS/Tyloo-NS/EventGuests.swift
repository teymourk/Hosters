//
//  EventGuests.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/26/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "Cell"

class EventGuests: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var _eventUsers:Users?
    
    var menuBar:MenuBar = {
        let mb = MenuBar()
            mb.menuItems = ["✅ Attending", " 🤔 Interested", " ❌ No Going"]
        return mb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(EventPageCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.collectionView?.backgroundColor = .white
        self.collectionView?.isPagingEnabled = true
        
        setupView()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? EventPageCell {
            
            return cell
        }

        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width,
                      height: view.frame.height)
    }
    
    func setupView() {
        
        view.addSubview(menuBar)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstrainstsWithFormat("V:|[v0(70)]", views: menuBar)
    }
}

