//
//  ImagesCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//
import UIKit

class EventDetailsCell: BaseCollectionViewCell {
    
    weak var _eventDetails:Events? {
        didSet {
            
            guard let eventDetails = _eventDetails else {return}
            
            DispatchQueue.main.async {
                self.UpdateUI(For: eventDetails)
            }
        }
    }
    
    let details:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.font = UIFont(name: "NotoSans", size: 12)
            label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coverImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.masksToBounds = true
            image.translatesAutoresizingMaskIntoConstraints = false
        return image

    }()
    
    override func setupView() {
        super.setupView()
        backgroundColor = .white
    }
    
    fileprivate func UpdateUI(For details: Events) {
    
        if let URL = details.coverURL {
            
            coverImage.getImagesBack(url: URL, placeHolder: "emptyImage")
            
        } else {
            
            coverImage.image = UIImage(named: "emptyCover")
        }
    }
    
    internal func setupCoverImage() {
        
        addSubview(coverImage)
        
        addConstrainstsWithFormat("H:|[v0]|", views: coverImage)
        addConstrainstsWithFormat("V:|[v0]|", views: coverImage)
    }
    
    internal func setupDetailsLayer() {
    
        let height = frame.height - 10
        
        addSubview(coverImage)
        
        coverImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: height).isActive = true
        coverImage.widthAnchor.constraint(equalToConstant: height).isActive = true
        coverImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        
        addSubview(details)
        
        details.centerYAnchor.constraint(equalTo: coverImage.centerYAnchor).isActive = true
        details.leftAnchor.constraint(equalTo: coverImage.rightAnchor, constant: 5).isActive = true
        details.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
    }
}
