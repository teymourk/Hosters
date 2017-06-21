//
//  OptionsView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/20/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class OptionsView: BaseView {
    
    let optionsBtn:UIButton = {
        let btn = UIButton()
            btn.setImage(UIImage(named: "c"), for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func setupView() {
    
        addSubview(optionsBtn)
        
        addConstrainstsWithFormat("H:|[v0]|", views: optionsBtn)
        addConstrainstsWithFormat("V:|[v0]|", views: optionsBtn)
        
        backgroundColor = .white
        layer.borderWidth = 0.5
        layer.borderColor = darkGray.cgColor
    }
}

class NoImagesView: BaseView {
    
    override func setupView() {
        
        backgroundColor = .cyan
    }
}
