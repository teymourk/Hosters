//
//  OptionsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

protocol onOptionsDelegate: class {
    
    func onCamera(sender: UIButton)
}

class OptionsCell: BaseCell {
    
    var eventDetails:Events? {
        didSet {
            
            if let isLive = eventDetails?.isLive {
                
                //Event Ended, its photo Library
                if isLive == 1 {
                    
                    self.camera.setImage(UIImage(named: "sh"), for: .normal)
                    
                } else if isLive == 2 {
                    
                    self.camera.setImage(UIImage(named: "s"), for: .normal)
                    
                    
                } else {
                    
                    self.camera.setImage(UIImage(named: "c"), for: .normal)
                }
            }
        }
    }
    
    lazy var camera:UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onOption), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var delegate:onOptionsDelegate?

    override func setupView() {
        super.setupView()
     
        addSubview(camera)
        
        camera.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        camera.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        camera.heightAnchor.constraint(equalToConstant: 40).isActive = true
        camera.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }

    func onOption(sender: UIButton) {
        
        if delegate != nil {
            delegate?.onCamera(sender: sender)
        }
    }
}
