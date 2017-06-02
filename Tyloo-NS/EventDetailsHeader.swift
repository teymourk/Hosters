//
//  EventDetailsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/27/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CELL_ID"
private let CELL_IMAGES = "CELL_IMAGES"


class EventDetailsHeader: HomeCVCell {
    
    var _eventDetails:Events?
    
    override func handleCVOptions() {
    
        handleCellAnimation()
        setShadow()
        
        eventCollectionView.isPagingEnabled = true
        
        eventCollectionView.register(EventDetailCell.self, forCellWithReuseIdentifier: CELL_ID)
        eventCollectionView.register(ImagesCell.self, forCellWithReuseIdentifier: CELL_IMAGES)
    
        perform(#selector(handleScrollToDetails), with: nil, afterDelay: 1.5)
    }
    
    @objc private func handleScrollToDetails() {
        
        let index = IndexPath(item: 1, section: 0)
    
        eventCollectionView.scrollToItem(at: index, at: .left, animated: true)
    }
}


//Mark: Delegate Ovrride
extension EventDetailsHeader {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let eventDetails = _eventDetails {
        
            if indexPath.item == 1 {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? EventDetailCell {
                    
                    cell._eventDetails = eventDetails
                    
                    return cell
                }
            }
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGES, for: indexPath) as? ImagesCell {
                
                cell.eventDetails = eventDetails
                
                return cell
            }
        }
        
        return BaseCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width,
                      height: frame.height)
    }
}
