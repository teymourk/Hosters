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
            
            if let eventDic = eventsDictionary {
                
                if let eventsArray = eventDic[indexPath.item] {
                    
                    cell.eventsCV.events = eventsArray
                    cell.eventsCV.homePage = self
                    
                    for eventOBJ in eventsArray {
                        
                        switch eventOBJ.rsvp_status {
                            
                        case "not_replied"?:
                            cell.categoryLabel.text = "Invited  💌"
                            break
                        case "attending"?:
                            cell.categoryLabel.text = "Attending ✅"
                            break
                        case "unsure"?:
                            cell.categoryLabel.text = "Interested 🤔"
                            break
                        default: break
                            
                        }
                    }
                }
                
                if indexPath.item == eventDic.count - 1 {
                    
                    cell.categoryLabel.text = "Attended 👻"
                }
            }
        
            return cell
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width,
                      height: FEED_CELL_HEIGHT)
    }
    
    //Mark: HeaderDelegate
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath) as? LiveEvents {
            
            if let liveEvent = liveEventArray {
            
                header.events = liveEvent
                header.homePage = self
            }
            
            return header
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
            if let liveEvents = liveEventArray {
        
                if liveEvents.isEmpty {
        
                    return CGSize(width: view.frame.width,
                                  height: 50)
                }
            }
        
        return CGSize(width: view.frame.width,
                      height: FEED_CELL_HEIGHT - 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10,
                            left: 0, bottom: 0, right: 0)
    }
}
