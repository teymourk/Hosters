//
//  FriendsFeedCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/12/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MapKit

private let CELL_EVENTS = "Cell_Evets"

class FeedCell: BaseCell {
    
    var _eventDetails:Events? {
        didSet {
            guard let eventDetails = _eventDetails else {return}
            
            if let coverURL = eventDetails.coverURL  {
                
                coverImage.getImagesBack(url: coverURL, placeHolder: "emptyImage")
            }
        }
    }
    
    let coverImage:UIImageView = {
        let image = UIImageView()
            image.backgroundColor = .red
            image.layer.masksToBounds = true
            image.contentMode = .scaleAspectFill
        return image
    }()
    
    let segmentedControl:UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Call","Direction", "Photos"])
            segment.backgroundColor = darkGray
        return segment
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(coverImage)
        
        addConstrainstsWithFormat("H:|[v0]|", views: coverImage)
        addConstrainstsWithFormat("V:|[v0]|", views: coverImage)
        
        addSubview(segmentedControl)
        
        addConstrainstsWithFormat("H:|[v0]|", views: segmentedControl)
        addConstrainstsWithFormat("V:[v0(40)]|", views: segmentedControl)
    }
}








