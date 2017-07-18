//
//  Extension+EventDetailHeader.swift
//  Tyloo
//
//  Created by Kiarash Teymoury on 7/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

extension EventDetailsHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return postedImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell_ID, for: indexPath) as? EventDetailsCell {
            
            if let image = postedImages?[indexPath.item], let imgURL = image.imageURL {
                
                cell.coverImage.getImagesBack(url: imgURL, placeHolder: "emptyImage")
                cell.setupDetailsLayer()
            }
            
            return cell
        }
        
        return BaseCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let allEventPhotosVC = allEventPhotos, let eventImages = postedImages else {return}
        
        allEventPhotosVC.pushToAllImages(eventImages: eventImages, selectedIndex: indexPath)
        
    }
}
