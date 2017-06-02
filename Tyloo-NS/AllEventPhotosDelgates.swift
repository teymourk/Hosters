//
//  AllEventPhotosDelgates.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/1/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CellID"
private let GRID_ID = "Grid_ID"
private let HEADER_ID = "HEADER_ID"

extension AllEventPhotos: UICollectionViewDelegateFlowLayout {

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if grid == false {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? AllEventPhotosCell {
                
                cell.postImages = postedImages?[indexPath.item]
                return cell
            }
            
        } else {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GRID_ID, for: indexPath) as? GridCell {
                
                cell.postImages = postedImages?[indexPath.item]
                return cell
            }
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width:CGFloat = grid == true ? view.frame.width / 3 : view.frame.width
        let height:CGFloat = grid == true ? HEIGHE_IMAGE / 3 : HEIGHE_IMAGE + 20
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return grid == true ? 0 : 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    //Mark: HeaderDelegate
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath) as? EventDetailsHeader {
            
            if let eventDetilas = _eventDetails {
                
                header._eventDetails = eventDetilas
            }
            
            return header
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width,
                      height: FEED_CELL_HEIGHT / 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10,
                            left: 0, bottom: 0, right: 0)
    }
}


