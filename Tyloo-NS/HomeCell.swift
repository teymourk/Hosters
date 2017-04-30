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
            label.text = "Categories Of Each Event"
            label.textColor = .darkGray
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var seperator:UIView = {
        let seperator = UIView()
            seperator.backgroundColor = darkGray
            seperator.translatesAutoresizingMaskIntoConstraints = false
        return seperator
    }()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .clear
        
        addSubview(categoryLabel)
        
        categoryLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        categoryLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        addSubview(eventsCV)
        
        eventsCV.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        eventsCV.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
        eventsCV.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(seperator)
        
        seperator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        seperator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
