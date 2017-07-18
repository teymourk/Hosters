//
//  EventDetailsHeader.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/9/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EventDetailsHeader: BaseCollectionViewCell {
    
    let Cell_ID = "Cell_ID"
    
    lazy var collectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .white
            cv.register(EventDetailsCell.self, forCellWithReuseIdentifier: self.Cell_ID)
            cv.layer.borderWidth = 0.5
            cv.layer.borderColor = darkGray.cgColor
            cv.delegate = self
            cv.dataSource = self
            cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var postedImages:[PostImages]? {
        didSet {
            
            guard let imagesCount = postedImages?.count else {return}
            
            if imagesCount == 0 {
                handleNoImagesView()
                return
            }
            
            handleWithImagesView()
        }
    }
    
    let optionsView:OptionsView = {
        let view = OptionsView()
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let shareOptionCV:OptionsCollectionView = {
        let optionsCV = OptionsCollectionView(options: ["Facebook", "Contacts", "Instgram", "Twitter"])
            optionsCV.translatesAutoresizingMaskIntoConstraints = false
        return optionsCV
    }()
    
    
    var noImagesView:NoImagesView = {
        let view = NoImagesView()
            view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    weak var allEventPhotos:AllEventPhotos?
    
    override func setupView() {
        super.setupView()
    }
}

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
