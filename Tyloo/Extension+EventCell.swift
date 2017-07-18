//
//  Extension+EventCell.swift
//  Tyloo
//
//  Created by Kiarash Teymoury on 7/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import Foundation

extension EventsCell {
    
    internal func handleLayout() {
        
        addSubview(title)
        
        title.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        title.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant:5).isActive = true
        title.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(location)
        
        location.widthAnchor.constraint(equalTo: title.widthAnchor).isActive = true
        location.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        location.topAnchor.constraint(equalTo: title.bottomAnchor, constant:5).isActive = true
        location.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(seperator)
        
        seperator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 5).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        addSubview(guestCountsButton)
        
        guestCountsButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        guestCountsButton.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 10).isActive = true
        guestCountsButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    internal func setupViewHeader() {
        
        addSubview(headerView)
        
        headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(coverImage)
        
        coverImage.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        coverImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: FEED_CELL_HEIGHT / 2.3).isActive = true
    }
}
