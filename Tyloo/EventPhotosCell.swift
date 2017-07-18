//
//  EventPhotosCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/22/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EventPhotosCell: BaseCollectionViewCell {
    
    weak var postedImages:PostImages? {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    var _images:UIImageView = {
        let img = UIImageView()
            img.contentMode = .scaleAspectFill
            img.layer.masksToBounds = true
        return img
    }()
    
    override func setupView() {
        super.setupView()
        
        setupImageLayout()
    }
    
    internal func setupImageLayout() {
        
        addSubview(_images)
        
        addConstrainstsWithFormat("H:|[v0]|", views: _images)
        addConstrainstsWithFormat("V:|[v0]|", views: _images)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        _images.image = nil
    }
    
    fileprivate func updateUI() {
    
        guard let imgURL = postedImages?.imageURL else {return}
        
        self._images.getImagesBack(url: imgURL, placeHolder: "emptyImage")
    }
}
