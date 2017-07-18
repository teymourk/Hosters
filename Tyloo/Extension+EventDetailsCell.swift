//
//  Extension+EventDetailsCell.swift
//  Tyloo
//
//  Created by Kiarash Teymoury on 7/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

extension EventDetailsCell {
    
    internal func setupCoverImage() {
        
        addSubview(coverImage)
        
        addConstrainstsWithFormat("H:|[v0]|", views: coverImage)
        addConstrainstsWithFormat("V:|[v0]|", views: coverImage)
    }
    
    internal func setupDetailsLayer() {
        
        let height = frame.height - 10
        
        addSubview(coverImage)
        
        coverImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: height).isActive = true
        coverImage.widthAnchor.constraint(equalToConstant: height).isActive = true
        coverImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        
        addSubview(details)
        
        details.centerYAnchor.constraint(equalTo: coverImage.centerYAnchor).isActive = true
        details.leftAnchor.constraint(equalTo: coverImage.rightAnchor, constant: 5).isActive = true
        details.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
    }
}
