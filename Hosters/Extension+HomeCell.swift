//
//  Extension+HomeCell.swift
//  Tyloo
//
//  Created by Kiarash Teymoury on 7/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

extension HomeCell {

    func setupConstraints() {
        
        addSubview(_categoryLabel)
        
        let eventsLeftContentEdge = _userEventsCollectionView.eventCollectionView.contentInset.left
        
        _categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        _categoryLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: eventsLeftContentEdge).isActive = true
        _categoryLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        addSubview(_userEventsCollectionView)
        
        _userEventsCollectionView.topAnchor.constraint(equalTo: _categoryLabel.bottomAnchor, constant: 10).isActive = true
        _userEventsCollectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        _userEventsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

}
