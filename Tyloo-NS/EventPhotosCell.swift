//
//  EventPhotosCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/22/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EventPhotosCell: BaseCell {
    
    var postedImages:PostImages? {
        didSet {
            
            guard let imgURL = postedImages?.imageURL else {return}
            self._images.getImagesBack(url: imgURL, placeHolder: "emptyImage")
        }
    }
    
    var feedAllPhotos:PicturesInsideCell?
    
    var _images:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        img.layer.borderWidth = 0.5
        img.layer.borderColor = UIColor.white.cgColor
        return img
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(_images)
        
        //AllImages Constrains
        addConstrainstsWithFormat("H:|[v0]|", views: _images)
        addConstrainstsWithFormat("V:|[v0]|", views: _images)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        _images.image = nil
    }
}
