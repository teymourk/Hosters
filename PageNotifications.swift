//
//  pageNotifications.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/8/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class PageNotifications: NSObject {
    
    var notifcationTitle:UILabel = {
        let label = UILabel()
            label.textColor = darkGray
            label.textAlignment = .center
            label.font = UIFont(name: "Prompt", size: 12)
            label.layer.borderWidth = 2
            label.layer.borderColor = UIColor.white.cgColor
            label.backgroundColor = UIColor.rgb(39, green: 153, blue: 21)
            label.numberOfLines = 2
        return label
    }()
    
    var messageSize:CGSize!
    
    func showNotification(_ message: NSString) {
        
        //Gets the width of the text entered
        messageSize = message.size(attributes: [NSFontAttributeName:notifcationTitle.font])
        
        if let window = UIApplication.shared.keyWindow {
            
            let centerX:CGFloat = 0.0
            
            let height = self.messageSize.height * 2.5
            let width = window.frame.width
            
            window.addSubview(notifcationTitle)
            
            notifcationTitle.frame = CGRect(x: centerX, y: 65, width: width, height: 0)
            
            UIView.animate(withDuration: 0.7, animations: {
                
                self.notifcationTitle.frame = CGRect(x: centerX, y: 65, width: width, height: height)
                self.notifcationTitle.text = NSString(string: message) as String
            })
        }
        
        self.perform(#selector(handleDissmiss), with: nil, afterDelay: 3)
    }
    
    func handleDissmiss() {
       
        if let window = UIApplication.shared.keyWindow {
        
            let width = window.frame.width
        
            UIView.animate(withDuration: 0.4, animations: {
                
                    self.notifcationTitle.frame = CGRect(x: 0.0, y: 65, width: width, height: 0)
                
                }, completion: { (done) in
                    
                self.notifcationTitle.removeFromSuperview()
            })
        }
    }
    
    override init() {
        super.init()
    }
}
