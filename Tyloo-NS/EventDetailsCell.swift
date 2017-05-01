//
//  EventDetailsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/27/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EventDetailsCell: EventsCell {
    
    let addressLabel:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.text = "Address Goes Here"
            label.textColor = buttonColor
            label.font = UIFont(name: "Prompt", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
        
        guestCountsButton.removeFromSuperview()
        
        addSubview(headerView)
        
        headerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(coverImage)
        
        coverImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        coverImage.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: FEED_CELL_HEIGHT / 1.7).isActive = true
        
        addSubview(title)
        
        title.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        title.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant:10).isActive = true
        title.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(location)
        
        location.widthAnchor.constraint(equalTo: title.widthAnchor).isActive = true
        location.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        location.topAnchor.constraint(equalTo: title.bottomAnchor, constant:5).isActive = true
        location.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(addressLabel)
        
        addressLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: title.leftAnchor, constant: 20).isActive = true
        addressLabel.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(seperator)
        
        addConstrainstsWithFormat("H:|[v0]|", views: seperator)
        addConstrainstsWithFormat("V:[v0(0.5)]|", views: seperator)
        
    }
}
