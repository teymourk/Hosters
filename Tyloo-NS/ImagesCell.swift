//
//  ImagesCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class ImagesCell: BaseCell {

    var eventDetails:Events? {
        didSet {
            
            if let URL = eventDetails?.coverURL {
                
                coverImage.getImagesBack(url: URL, placeHolder: "emptyImage")
                
            } else {
                
                coverImage.image = UIImage(named: "emptyCover")
            }
        }
    }
    
    let coverImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.masksToBounds = true
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let button:UIButton = {
        let button = UIButton()
            button.setTitle("View All Photos", for: .normal)
            button.setTitleColor(darkGray, for: .normal)
            button.titleLabel?.textAlignment = .right
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(coverImage)
        
        coverImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        coverImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: FEED_CELL_HEIGHT / 2).isActive = true
        
        addSubview(button)
        
        button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: coverImage.bottomAnchor).isActive = true
    }
}
