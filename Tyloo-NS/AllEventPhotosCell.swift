//
//  AllEventPhotosCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/31/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class AllEventPhotosCell:BaseCell {
    
    var postImages:Images? {
        didSet {
            
            guard let imageURL = postImages?.img else {return}
            
            postedImage.getImagesBack(url: imageURL, placeHolder: "emptyImage")
        }
    }
    
    var postedImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.masksToBounds = true
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var profileImage:UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .yellow
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 20
        return image
    }()
    
    var username:UILabel = {
        let label = UILabel()
            label.text = "Test Username"
            label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var date:UILabel = {
        let label = UILabel()
            label.text = "Test Date"
            label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        setupList()
    }
    
    
    func setupList() {
        
        addSubview(postedImage)
        addSubview(seperator)
        addSubview(profileImage)
        addSubview(username)
        addSubview(date)
        
        addConstrainstsWithFormat("H:|-12-[v0]", views: profileImage)
        
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //PostedImage
        postedImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        postedImage.heightAnchor.constraint(equalToConstant: 414).isActive = true
        postedImage.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        
        //username Constraints
        addConstrainstsWithFormat("H:[v0]", views: username)
        addConstrainstsWithFormat("V:[v0(20)]", views: username)
        
        username.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 5).isActive = true
        username.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        //Date Constraints
        addConstrainstsWithFormat("H:[v0]-10-|", views: date)
        addConstrainstsWithFormat("V:[v0(20)]", views: date)
        
        date.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
    }
}

class GridCell:AllEventPhotosCell {
    
    override func setupList() {
        
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        
        addSubview(postedImage)
        
        //username Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: postedImage)
        addConstrainstsWithFormat("V:|[v0]|", views: postedImage)
    }
}
