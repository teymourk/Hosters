//
//  LiveView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/16/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class LiveView: BaseView {

    let liveLabel:UILabel = {
        let label = UILabel()
            label.textColor = .darkGray
            label.text = "Live 📍"
            label.font = UIFont(name: "NotoSans-Italic", size: 20)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func setupView() {
        
        addSubview(liveLabel)
        
        addConstrainstsWithFormat("H:|-10-[v0]|", views: liveLabel)
        addConstrainstsWithFormat("V:|[v0]|", views: liveLabel)
    }
}
