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
import TGCameraViewController

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
                cell.setupJustImageLayer()
                
            } else {
                                
                let image = cellImages[indexPath.item - 1]
                
                cell.setupDetailsLayer()
                cell.coverImage.image = image
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
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath) as? EventDetailsHeader {
            
            header.postedImages = loadImages()
            header.optionsView.delegate = self
            return header
        }
        
        return BaseCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        //return !loadImages().isEmpty ? CGSize(width: view.frame.width, height: FEED_CELL_HEIGHT * 0.25) : CGSize(width: 0, height: 0)
        
        return CGSize(width: view.frame.width, height: FEED_CELL_HEIGHT * 0.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //return !loadImages().isEmpty ? UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    }
}
