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
        
        addSubview(categoryLabel)
        
        let eventsLeftContentEdge = eventsCV.eventCollectionView.contentInset.left
        
        categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: eventsLeftContentEdge).isActive = true
        categoryLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        addSubview(eventsCV)
        
        eventsCV.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
        eventsCV.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        eventsCV.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

}
