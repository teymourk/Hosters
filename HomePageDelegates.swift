//
//  HomePageDelegates.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/21/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_FEED = "Cell_FEED"
private let HEADER_ID = "Header_ID"

extension HomePage: UICollectionViewDelegateFlowLayout {
    
    //Mark: CollectionView Delegate/DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return events?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return events?[section].count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_FEED, for: indexPath) as? FeedCell {
            
            if let eventDetails = events?[indexPath.section][indexPath.item] {
                
                cell._eventDetails = eventDetails
            }
            
            return cell
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width,
                      height: FEED_CELL_HEIGHT)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    //Mark: HeadeDelegate
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath) as? EventHeader {
            
            if let eventHeader = events?[indexPath.section][indexPath.item] {
                
                header.eventDetails = eventHeader
            }
            
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 45)
    }
}
