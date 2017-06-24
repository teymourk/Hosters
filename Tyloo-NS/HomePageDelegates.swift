//
//  HomePageDelegates.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/21/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

extension HomePage: UICollectionViewDelegateFlowLayout {
    
    //Mark: CollectionView Delegate/DataSource    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                
        return eventsDictionary?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_FEED, for: indexPath) as? HomeCell {
            
            if let eventDic = eventsDictionary {
                
                setCellLabels(Cell: cell, EventDic:eventDic, indexPath: indexPath)
            }
        
            return cell
        }
        
        return BaseCollectionViewCell()
    }
    
    private func setCellLabels(Cell:HomeCell, EventDic:[Int:[Events]], indexPath:IndexPath) {
        
        if let eventsArray = EventDic[indexPath.item] {
            
            Cell.eventsCV.events = eventsArray
            Cell.eventsCV.homePage = self
            
            for eventOBJ in eventsArray {
                
                switch eventOBJ.rsvp_status {
                    
                case "not_replied"?:
                    Cell.categoryLabel.text = "Invited  💌"
                    break
                case "attending"?:
                    Cell.categoryLabel.text = "Attending ✅"
                    break
                case "unsure"?:
                    Cell.categoryLabel.text = "Interested 🤔"
                    break
                default: break
                    
                }
            }
        }
        
        if indexPath.item == EventDic.count - 1 {
            
            Cell.categoryLabel.text = "Attended 👻"
            
        } else if indexPath.item == 0 {
            
            Cell.categoryLabel.text = "Live 📍"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width,
                      height: FEED_CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    //Mark - HeaderDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width,
                      height: -1 * (heightConst))
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath) as? SearchHeader {
        
            return header
        }
        
        return BaseCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10,
                            left: 0, bottom: 0, right: 0)
    }
}
