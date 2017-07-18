//
//  FriendsFeedCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/12/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class HomeCell: BaseCollectionViewCell {
    
    let eventsCV:HomeCVCell = {
        let events = HomeCVCell()
            events.translatesAutoresizingMaskIntoConstraints = false
        return events
    }()
    
    let categoryLabel:UILabel = {
        let label = UILabel()
            label.textColor = .darkGray
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
        backgroundColor = .white
        
        setupConstraints()
    }
}
