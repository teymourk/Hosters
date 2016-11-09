//
//  ActivePostsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/20/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class ActivePostsCell: BaseCell {
    
    var activePosts:Posts? {
        didSet {
            
            if let postTitle = activePosts?.postDescription {
                _tilte.text = postTitle
            }
            
            if let postLocation = activePosts?.location {
                _location.text = postLocation
            }
        }
    }
    
    var _tilte:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Prompt", size: 14)
        return label
    }()
    
    var _location:UILabel = {
        let label = UILabel()
        label.textColor = buttonColor
        label.font = UIFont(name: "NotoSans", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var _arrowIndicatior:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "righArrow")
        return image
    }()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        
        addSubview(_tilte)
        addSubview(_location)
        addSubview(_arrowIndicatior)
        
        //Title Constraints
        addConstrainstsWithFormat("H:|-10-[v0]", views: _tilte)
        addConstrainstsWithFormat("V:|-4-[v0(20)]", views: _tilte)
        

        //Location Constraints
        addConstrainstsWithFormat("H:|-10-[v0]|", views: _location)
        addConstrainstsWithFormat("V:[v0]", views: _location)
        
        //Top Constraints
        addConstraint(NSLayoutConstraint(item: _location, attribute: .top, relatedBy: .equal, toItem: _tilte, attribute: .bottom, multiplier: 1, constant: 7))

        //Arrow Indicator Cosntrains
        addConstrainstsWithFormat("H:[v0(10)]-10-|", views: _arrowIndicatior)
        addConstrainstsWithFormat("V:[v0(15)]-10-|", views: _arrowIndicatior)
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: _arrowIndicatior, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
