//
//  Active_Ended_Header.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 11/29/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class Active_Ended_Header: BaseCell {
 
    var text:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "Prompt", size: 15)
            label.textColor = darkGray
        return label
    }()
    
    let view:UIView = {
        let v = UIView()
            v.backgroundColor = orange
        return v
    }()
    
    let view2:UIView = {
        let v = UIView()
            v.backgroundColor = orange
        return v
    }()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .clear
        
        addSubview(text)
        addSubview(view)
        addSubview(view2)
        
        addConstrainstsWithFormat("H:|-10-[v0(150)]", views: view)
        addConstrainstsWithFormat("H:|-185-[v0(60)]", views: text)
        addConstrainstsWithFormat("H:[v0(150)]-10-|", views: view2)
        
        addConstrainstsWithFormat("V:|-25-[v0(1)]", views: view)
        addConstrainstsWithFormat("V:|-15-[v0(20)]", views: text)
        addConstrainstsWithFormat("V:|-25-[v0(1)]", views: view2)
    }
}
