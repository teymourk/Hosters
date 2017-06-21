//
//  BaseCollectionViewCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/20/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    var seperator:UIView = {
        let seperator = UIView()
        seperator.backgroundColor = .lightGray
        seperator.translatesAutoresizingMaskIntoConstraints = false
        return seperator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        addSubview(seperator)
        
        seperator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        seperator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

