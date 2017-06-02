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
            image.contentMode = .scaleToFill
            image.layer.masksToBounds = true
        return image
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(coverImage)
        
        addConstrainstsWithFormat("H:|[v0]|", views: coverImage)
        addConstrainstsWithFormat("V:|[v0]|", views: coverImage)
    }
}
