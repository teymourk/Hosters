//
//  HomePageDelegates.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/21/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_FEED = "Cell_FEED"
private let HEADER_ID = "HEADER_ID"

extension HomePage: UICollectionViewDelegateFlowLayout {
    
    //Mark: CollectionView Delegate/DataSource    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return eventsDictionary?.count ?? 0 
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_FEED, for: indexPath) as? HomeCell {
            
            if let eventsArray = eventsDictionary?[indexPath.item] {
                
                cell.eventsCV.events = eventsArray
                cell.eventsCV.homePage = self
            }
            
            return cell
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width,
                      height: FEED_CELL_HEIGHT - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    //Mark: HeaderDelegate
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath) as? LiveEvents {
        
            return header
        }

        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if let liveEvent = liveEventArray {
         
            if liveEvent.isEmpty {
                
                return CGSize(width: view.frame.width,
                              height: 50)
            }
        }
        
        return CGSize(width: view.frame.width,
                      height: FEED_CELL_HEIGHT - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 15,
                            left: 0, bottom: 0, right: 0)
    }
}
