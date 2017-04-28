//
//  GuestsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/26/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class GuestsCell: BaseCell {
    
    var profile_image:UIImageView = {
        let image = UIImageView()
            image.layer.masksToBounds = true
            image.layer.cornerRadius = 25
            image.contentMode = .scaleAspectFill
            image.backgroundColor = .red
        return image
    }()
    
    var profile_name:UILabel = {
        let label = UILabel()
            label.textColor = .darkGray
            label.font = UIFont.boldSystemFont(ofSize: 12)
            label.text = "NIMA SAJAD POUR"
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var seperator:UIView = {
        let seperator = UIView()
            seperator.backgroundColor = .lightGray
            seperator.translatesAutoresizingMaskIntoConstraints = false
        return seperator
    }()
    
    override func setupView() {
        
        addSubview(profile_image)
    
        addConstrainstsWithFormat("H:|-10-[v0(50)]", views: profile_image)
        addConstrainstsWithFormat("V:[v0(50)]", views: profile_image)
        
        profile_image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(profile_name)
        
        profile_name.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        profile_name.leftAnchor.constraint(equalTo: profile_image.rightAnchor, constant: 10).isActive = true
        profile_name.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    
        addSubview(seperator)
        
        seperator.leftAnchor.constraint(equalTo: profile_name.leftAnchor).isActive = true
        seperator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
