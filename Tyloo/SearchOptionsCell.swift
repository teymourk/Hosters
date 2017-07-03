//
//  SearchOptionsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/23/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class SearchOptionsCell: BaseCollectionViewCell {
    
    var searchLabel:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "Prompt", size: 12)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
    
        backgroundColor = randomColor()
        
        handleCellAnimation()
        setShadow()
        
        addSubview(searchLabel)
        
        searchLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    fileprivate func randomColor() -> UIColor {
        
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red,
                       green: green,
                       blue: blue,
                       alpha: 1)
    }
}
