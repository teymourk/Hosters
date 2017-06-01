//
//  FriendsFeedCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/12/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class HomeCell: BaseCell {
    
    let eventsCV:HomeCVCell = {
        let events = HomeCVCell()
            events.translatesAutoresizingMaskIntoConstraints = false
        return events
    }()
    
    let categoryLabel:UILabel = {
        let label = UILabel()
            label.textColor = .darkGray
            label.font = UIFont(name: "Prompt", size: 17)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
       super.setupView()
        
        setShadow()
        
        backgroundColor = .clear
        
        addSubview(categoryLabel)
        
        categoryLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        categoryLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        addSubview(eventsCV)
        
        eventsCV.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        eventsCV.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
        eventsCV.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
