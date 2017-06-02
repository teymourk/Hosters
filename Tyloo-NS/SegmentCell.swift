//
//  SegmentCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/1/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

protocol onSegmentDelegate: class {
    
    func onSegment(sender: UISegmentedControl)
}

class SegmentCell:BaseCell {
    
    lazy var segmentControl:UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Grid", "List"])
            segment.selectedSegmentIndex = 0
            segment.setTitleTextAttributes([NSForegroundColorAttributeName: buttonColor], for: .normal)
            segment.addTarget(self, action: #selector(onSegment(sender :)), for: .valueChanged)
            segment.tintColor = .clear
            segment.layer.masksToBounds = true
            segment.layer.borderWidth = 0.5
            segment.layer.borderColor = UIColor.lightGray.cgColor
        return segment
    }()
    
    var delegate:onSegmentDelegate?
    
    override func setupView() {
        
        backgroundColor = .white
        
        addSubview(segmentControl)
        
        addConstrainstsWithFormat("H:|[v0]|", views: segmentControl)
        addConstrainstsWithFormat("V:|[v0]|", views: segmentControl)
    }
    
    func onSegment(sender: UISegmentedControl) {
        
        if delegate != nil {
            delegate?.onSegment(sender: sender)
        }
    }
}
