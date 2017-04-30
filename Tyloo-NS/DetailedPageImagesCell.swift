//
//  DetailedPageImagesCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/29/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_PICTURES = "Cell_Picture"

class DetailedPageImagesCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var segmentedController:UISegmentedControl = {
        let segment = UISegmentedControl(items: ["List", "Grid"])
            segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    lazy var picturesCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .white
            cv.register(PicturesCell.self, forCellWithReuseIdentifier: CELL_PICTURES)
            cv.delegate = self
            cv.dataSource = self
            cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_PICTURES, for: indexPath) as? PicturesCell {
            
            
            return cell
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width / 3,
                      height: frame.width / 3)
    }
    
    override func setupView() {
        
        addSubview(segmentedController)
        
        segmentedController.leftAnchor.constraint(equalTo: leftAnchor, constant: -4).isActive = true
        segmentedController.rightAnchor.constraint(equalTo: rightAnchor, constant: 4).isActive = true
        segmentedController.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(picturesCV)
        
        addConstrainstsWithFormat("H:|[v0]|", views: picturesCV)
        addConstrainstsWithFormat("V:|-30-[v0]|", views: picturesCV)
    }
}

class PicturesCell:BaseCell {
    
    override func setupView() {
        
        backgroundColor = .cyan
    
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = darkGray.cgColor
    }
}
