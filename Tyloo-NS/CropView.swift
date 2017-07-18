//
//  CropView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/22/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class CropView: BaseView {
    
    private var originalPosition: CGPoint?
    
    override func setupView() {
        super.setupView()
        
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = goldColor.CGColor
        backgroundColor = .clearColor()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            let position = touch.locationInView(self.superview)
            self.center = CGPointMake((self.superview?.center.x)!, position.y)
            
            let topEdge = CGRectGetMinY(self.frame)
            let bottomEdge = CGRectGetMaxY(self.frame)
            
            print("MinY: \(topEdge), MaxY, \(bottomEdge)")
            
            if topEdge <= 0 {
                
                self.frame = CGRectMake(0, 0, (superview?.frame.width)!, FEED_CELL_HEIGHT)
                self.touchesEnded(touches, withEvent: event)
    
            }
            
            if bottomEdge >= HEIGHE_IMAGE {
                
                self.frame = CGRectMake(0, 310, (superview?.frame.width)!, FEED_CELL_HEIGHT)
                self.touchesEnded(touches, withEvent: event)
            }
        }
    }
}