//
//  PlaceDetails.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 11/27/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class PlaceDetails: UIView {
    
    var postTitle:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "NotoSans", size: 13)
            label.textColor = .white
            label.numberOfLines = 2
        return label
    }()
    
    var ratingIcon:UIImageView = {
        let img = UIImageView()
            img.contentMode = .scaleAspectFill
            img.layer.masksToBounds = true
            img.image = UIImage(named: "test")
        return img
    }()
    
    var location:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "NotoSans", size: 14)
            label.textColor = darkGray
        return label
    }()
    
    var locationIcon:UIImageView = {
        let img = UIImageView()
            img.contentMode = .scaleAspectFill
            img.layer.masksToBounds = true
        return img
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
       
        setupView()
    }
    
    fileprivate func setupView() {
        
        layer.masksToBounds = true
        layer.cornerRadius = 4
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor
        
        addSubview(postTitle)
        addSubview(location)
        addSubview(locationIcon)
        addSubview(ratingIcon)
        backgroundColor = UIColor(white: 0.7, alpha: 1)
        
        addConstrainstsWithFormat("H:|-10-[v0(80)]", views: locationIcon)
        addConstrainstsWithFormat("V:|-10-[v0(60)]", views: locationIcon)
        
        addConstrainstsWithFormat("H:|-10-[v0]|", views: postTitle)
        addConstrainstsWithFormat("V:[v0]-5-|", views: postTitle)
        
        addConstrainstsWithFormat("H:|-100-[v0]|", views: location)
        addConstrainstsWithFormat("V:|-10-[v0]", views: location)
        
        addConstrainstsWithFormat("H:|-100-[v0(120)]", views: ratingIcon)
        addConstrainstsWithFormat("V:|-40-[v0(20)]", views: ratingIcon)
    }
}

