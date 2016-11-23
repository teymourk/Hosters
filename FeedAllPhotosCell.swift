//
//  FeedAllPhotosCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/26/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class FeedAllPhotosCell: BaseCell {
    
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
            img.clipsToBounds = true
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
