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
}
