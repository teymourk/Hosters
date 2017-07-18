//
//  SearchOptionsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/23/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class SearchOptionsCell: BaseCollectionViewCell {
    
    var searchImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFit
            image.layer.cornerRadius = 15
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func setupView() {
    
        backgroundColor = .clear
        
        handleCellAnimation()
        setupImageLayout()
        setShadow()
    }
    
    fileprivate func setupImageLayout() {
        
        addSubview(searchImage)
        
        searchImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        searchImage.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}
