//
//  ImagesCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class ImagesCell: BaseCell {
    
    var eventPhotosCV:PicturesInsideCell = {
        let ep = PicturesInsideCell()
            ep.translatesAutoresizingMaskIntoConstraints = false
        return ep
    }()

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
            button.setTitle("View All Photos >", for: .normal)
            button.titleLabel?.font = UIFont(name: "NotoSans", size: 12)
            button.setTitleColor(darkGray, for: .normal)
            button.titleLabel?.textAlignment = .right
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func setupView() {
        super.setupView()
        
        guard let eventImages = eventPhotosCV.allImages else {return}
        
        addSubview(coverImage)
        
        addConstrainstsWithFormat("H:|[v0]|", views: coverImage)
        addConstrainstsWithFormat("V:|[v0]|", views: coverImage)
        
        if !eventImages.isEmpty {
            
            perform(#selector(animateImages), with: nil, afterDelay: 2)
        }
    }
    
    internal func animateImages() {
        
        coverImage.removeFromSuperview()
        
        addSubview(eventPhotosCV)
        
        eventPhotosCV.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        eventPhotosCV.topAnchor.constraint(equalTo: topAnchor).isActive = true
        eventPhotosCV.heightAnchor.constraint(equalToConstant: FEED_CELL_HEIGHT / 2).isActive = true
        
        addSubview(button)
        
        button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: eventPhotosCV.bottomAnchor).isActive = true
    }
}
