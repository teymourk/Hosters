//
//  LiveEvents.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/25/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class LiveEvents: BaseCell {

    let noLiveTitle:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.text = "There Are No Live Events 🙄"
            label.font = UIFont(name: "Prompt", size: 12)
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
        
        backgroundColor = .white
        
        addSubview(noLiveTitle)
        
        noLiveTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        noLiveTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(seperator)
        
        addConstrainstsWithFormat("H:|[v0]|", views: seperator)
        addConstrainstsWithFormat("V:[v0(0.6)]|", views: seperator)
    }
}
