//
//  ScrollPage.swift
//  Tyloo
//
//  Created by Kiarash Teymoury on 7/9/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class ScrollPage: UIScrollView {
    
    let locationPage:[String:Any] = ["Title":"wfkeofke", "Description":"BALALABWJNWI", "Color":UIColor.red]
    let CameraPage:[String:Any] = ["Title":"wfkeofke", "Description":"BALALABWJNWI", "Color":UIColor.yellow]
    let ContinuePage:[String:Any] = ["Title":"wfkeofke", "Description":"BALALABWJNWI", "Color":UIColor.cyan]
    
    var pagesArray = [Dictionary<String, Any>]()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        pagesArray = [locationPage, CameraPage, ContinuePage]
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        for (index, pages) in pagesArray.enumerated() {
            
            let view = UIView()
                view.backgroundColor = .red
            
            addSubview(view)
            
            view.frame.size.width = (superview?.bounds.size.width)! * 3
            view.frame.origin.x = CGFloat(index) * self.bounds.size.width
            
            backgroundColor = pages["Color"] as? UIColor
        }
    }
}
