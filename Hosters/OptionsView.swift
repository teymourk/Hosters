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
    
    weak var eventDetails:Events? {
        didSet {
        
            guard let isLive = eventDetails?.isLive else {return}
            
            switch isLive {
            case 2:
                optionsBtn.setImage(UIImage(named: "uploadO"), for: .normal)
                break
            case 3:
                optionsBtn.setImage(UIImage(named: "cameraL"), for: .normal)
                break
            default: break
            }
        }
    }
    
    let optionsBtn:UIButton = {
        let btn = UIButton()
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
        
        backgroundColor = .white
    }
}
