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
        return events
    }()
    
    let categoryLabel:UILabel = {
        let label = UILabel()
            label.text = "Categories Of Each Event"
            label.textColor = .black
            label.font = UIFont(name: "NotoSans", size: 14)
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
        
        backgroundColor = .white
        
        addSubview(categoryLabel)
        
        addConstrainstsWithFormat("H:|-15-[v0]-10-|", views: categoryLabel)
        addConstrainstsWithFormat("V:|-10-[v0]", views: categoryLabel)
        
        addSubview(eventsCV)
        
        addConstrainstsWithFormat("H:|[v0]|", views: eventsCV)
        
        eventsCV.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor).isActive = true
        eventsCV.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(seperator)
        
        addConstrainstsWithFormat("H:|[v0]|", views: seperator)
        addConstrainstsWithFormat("V:[v0(0.5)]|", views: seperator)
        
    }
}








