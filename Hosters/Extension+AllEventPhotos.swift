//
//  AllEventPhotosDelgates.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/1/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import FirebaseStorage
import MBProgressHUD

private let CELL_ID = "CellID"
private let GRID_ID = "GRID_ID"
private let HEADER_ID = "HEADER_ID"
private let SEGMENT_CELL = "SEGMENT_CELL"

extension AllEventPhotos: UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellImages.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? EventDetailsCell {
            
            if indexPath.item == 0 {
                cell._eventDetails = _eventDetails
                cell.setupCoverImage()
                
            } else {
                                
                let image = cellImages[indexPath.item - 1]
                let details = evenDetails[indexPath.item - 1]
                
                cell.coverImage.image = image
                cell.details.text = details
                cell.setupDetailsLayer()
            }
            
            return cell
        }
        
        return BaseCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return indexPath.item == 0 ? CGSize(width: view.frame.width, height: FEED_CELL_HEIGHT / 1.5) : CGSize(width: view.frame.height, height: 40)
    }
        
    //Mark: HeaderDelegate
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath) as? EventDetailsHeader, let eventDetail = _eventDetails, let isLive = eventDetail.isLive as Int16? {
            
            //If event is live
            if isLive == 1 {
                header.setupShareOptions()
                
            } else {
                
                //If images arent Empty
                if !loadImages().isEmpty {
                    
                    header.postedImages = loadImages()
                    header.handleWithImagesView()
                    
                } else {
                    
                    header.handleNoImagesView()
                }
                
                header.optionsView.delegate = self
                header.allEventPhotos = self
                header.optionsView.eventDetails = eventDetail
            }
            
            return header
        }
        
        return BaseCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        //return !loadImages().isEmpty ? CGSize(width: view.frame.width, height: FEED_CELL_HEIGHT * 0.25) : CGSize(width: 0, height: 0)
        
        return CGSize(width: view.frame.width, height: FEED_CELL_HEIGHT * 0.20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //return !loadImages().isEmpty ? UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    }
}
