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
