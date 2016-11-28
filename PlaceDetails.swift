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
            label.font = UIFont(name: "NotoSans", size: 12)
            label.textColor = .white
            label.numberOfLines = 2
        return label
    }()
    
    var rating:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "NotoSans", size: 12)
            label.textColor = .white
        return label
    }()
    
    var location:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "NotoSans", size: 12)
            label.textColor = .white
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
        layer.cornerRadius = 10
        
        addSubview(postTitle)
        addSubview(location)
        addSubview(locationIcon)
        addSubview(rating)
        backgroundColor = UIColor(white: 0.3, alpha: 0.8)
        
        addConstrainstsWithFormat("H:|-10-[v0(80)]", views: locationIcon)
        addConstrainstsWithFormat("V:|-10-[v0(60)]", views: locationIcon)
        
        addConstrainstsWithFormat("H:|-10-[v0]|", views: postTitle)
        addConstrainstsWithFormat("V:[v0]-5-|", views: postTitle)
        
        addConstrainstsWithFormat("H:|-100-[v0]|", views: location)
        addConstrainstsWithFormat("V:|-5-[v0]", views: location)
        
        addConstrainstsWithFormat("H:|-100-[v0]|", views: rating)
        addConstrainstsWithFormat("V:|-30-[v0]", views: rating)
    }
}

