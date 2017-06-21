//
//  OptionsView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/20/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

protocol OptionsViewDelegate: class {
    
    func onOptions(_ sender: UIButton)
}

class OptionsView: BaseView {
    
    let optionsBtn:UIButton = {
        let btn = UIButton()
            btn.setImage(UIImage(named: "c"), for: .normal)
            btn.addTarget(self, action: #selector(onOptions(_:)), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var delegate:OptionsViewDelegate?
    
    override func setupView() {
    
        addSubview(optionsBtn)
        
        addConstrainstsWithFormat("H:|[v0]|", views: optionsBtn)
        addConstrainstsWithFormat("V:|[v0]|", views: optionsBtn)
        
        backgroundColor = .white
        layer.borderWidth = 0.5
        layer.borderColor = darkGray.cgColor
    }
    
    @objc
    private func onOptions(_ sender: UIButton) {
        
        if delegate != nil {
            delegate?.onOptions(sender)
        }
    }
}

class NoImagesView: BaseView {
    
    override func setupView() {
        
        backgroundColor = .cyan
    }
}
