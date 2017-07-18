//
//  Extnesion+OptionCollectionView.swift
//  Tyloo
//
//  Created by Kiarash Teymoury on 7/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

//Mark - Delegate Constructors

extension OptionsCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return searchOptions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell_ID, for: indexPath) as? SearchOptionsCell {
            
            let searchImage = searchOptions?[indexPath.item] ?? ""
            
            cell.searchImage.image = UIImage(named: searchImage)
            
            return cell
        }
        
        return BaseCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 45,
                      height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let searchHeader = searchHeader else {return}
        
        searchHeader.homePage?.handlePushingToSearchPage()
    }
}
