//
//  EventsCells.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/25/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import SCLAlertView

private let CELL_ID = "CELL_FEED"

class HomeCVCell: BaseCell  {
    
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
            cv.contentInset = UIEdgeInsetsMake(0, 10, 0, 0)
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
                cell.guestCountsButton.tag = indexPath.item
                cell.delegate = self
            }
            
            return cell
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let homePage = homePage{
            
            if let eventObj = events?[indexPath.item] {
                
                homePage.navigateToEventDetails(eventDetail: eventObj)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (frame.width) - (frame.width / 7),
                      height: FEED_CELL_HEIGHT - 90)
    }
}

//Mark: -EventCellDelegate
extension HomeCVCell: EventCellDelegate {
    
    func handleOnGuest(sender: UIButton) {
        
        let index = IndexPath(item: sender.tag, section: 0)
        
        if let homePage = homePage, let eventId = events?[index.item].event_id, let guest_list_enabled = events?[index.item].guest_list_enabled  {
            
            if !guest_list_enabled {
                
                SCLAlertView().showInfo("Info", subTitle: "Viewing guest list is disabled by the host")
                return
            }
                
            homePage.handlePushingToGuestPage(_eventId: eventId)
        }
    }
}
