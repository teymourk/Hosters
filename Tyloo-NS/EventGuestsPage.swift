//
//  EventGuestsCollection.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/30/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ATTENDING = "GUEST_ATTENDING"
private let CELL_DECLINED = "GUEST_DECLINED"
private let CELL_MAYBE = "GUEST_MAYBE"

class EventGuestsPage: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var event_id:String? = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.register(GuestsAttending.self, forCellWithReuseIdentifier: CELL_ATTENDING)
        self.collectionView?.register(GuestsMaybe.self, forCellWithReuseIdentifier: CELL_MAYBE)
        self.collectionView?.register(GuestsDeclined.self, forCellWithReuseIdentifier: CELL_DECLINED)
        self.collectionView?.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        self.collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.backgroundColor = .white
        
        setupMenuBar()
    }
    
    var menuBar:MenuBar = {
        let mb = MenuBar()
            mb.menuItems = ["Going","Maybe", "Not Going"]
        return mb
    }()
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let eventID = event_id {
            
            if indexPath.item == 1 {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_MAYBE, for: indexPath) as? GuestsMaybe {
                    
                    cell.event_id = eventID
                    
                    return cell
                }
                
            } else if indexPath.item == 2 {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_DECLINED, for: indexPath) as? GuestsDeclined {
                    
                    cell.event_id = eventID
                    
                    return cell
                }
                
            } else {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ATTENDING, for: indexPath) as? GuestsAttending {
                    
                    cell.event_id = eventID
                    
                    return cell
                }
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width,
                      height: view.frame.height)
    }
    
    internal func setupMenuBar() {
        
        view.addSubview(menuBar)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstrainstsWithFormat("V:|[v0(40)]", views: menuBar)
    }
}
