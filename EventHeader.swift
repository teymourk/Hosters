//
//  PostsHeader.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 11/28/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EventHeader: BaseCell {
    
    var eventDetails:Events? {
        
        didSet {
        
            guard let headerDetail = eventDetails else {return}
            
            activeLabel.text = headerDetail.start_time?.produceDate()
            
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
    
    var activeLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    var activeImage:UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    var usernameLabel:UILabel = {
        let label = UILabel()
            label.textColor = .red
            label.font =  UIFont(name: "NotoSans", size: 12)
        return label
    }()
    
    let bottomSeperator:UIView = {
        let view = UIView()
            view.backgroundColor = .darkGray
        return view
    }()
    
    internal func startCountDown() {
        
        if let eventTime = eventDetails?.start_time {
            
            usernameLabel.text = eventTime.countDown()
        }
    }
    
    override func setupView() {
        
        backgroundColor = .white
        
        addSubview(usernameLabel)
        addSubview(activeImage)
        addSubview(activeLabel)
        addSubview(bottomSeperator)
        
        //username Cosntraints
        addConstrainstsWithFormat("H:[v0]-2-|", views: usernameLabel)
        addConstrainstsWithFormat("V:[v0]-2-|", views: usernameLabel)
        
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        //Active Image Constraints
        addConstrainstsWithFormat("H:[v0(15)]-10-|", views: activeImage)
        addConstrainstsWithFormat("V:|-5-[v0(15)]", views: activeImage)
        
        //Active Label
        addConstrainstsWithFormat("H:[v0(300)]-2-|", views: activeLabel)
        addConstrainstsWithFormat("V:|-2-[v0]", views: activeLabel)
        
        addConstrainstsWithFormat("H:|[v0]|", views: bottomSeperator)
        addConstrainstsWithFormat("V:[v0(0.5)]|", views: bottomSeperator)
    }
}
