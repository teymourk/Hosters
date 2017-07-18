//
//  GoogleView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/28/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class VIewFOrLaterUser: NSObject {
        
    let dimedView = UIView()
    
    func setupView() {
        
        if let window = UIApplication.sharedApplication().keyWindow {
            
            dimedView.frame = window.bounds
            
            window.addSubview(dimedView)
         
            let width = window.frame.width - 20
            let height = window.frame.height / 3
            
            _ = CGRectMake(10, window.frame.height, width, height)
        
            UIView.animateWithDuration(0.2, animations: {
                
                window.endEditing(true)
                self.dimedView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                _ = CGRectMake(10, window.center.x, width, height)
            })
        }
    }
    
    func handleDissmiss(sender:UITapGestureRecognizer) {
        
        UIView.animateWithDuration(0.2, animations: {
            
            if let window = UIApplication.sharedApplication().keyWindow {
                
                let width = window.frame.width - 20
                let height = window.frame.height / 3
                
                _ = CGRectMake(10, window.frame.height, width, height)
                self.dimedView.backgroundColor = UIColor(white: 0, alpha: 0)
            }
        })
        
        dimedView.removeFromSuperview()
    }
    
    override init() {
        super.init()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
             
        UIView.animateWithDuration(0.2, animations: {
            
            if let window = UIApplication.sharedApplication().keyWindow {
            
                let width = window.frame.width - 20
                let height = window.frame.height / 2.5
                
                _ = CGRectMake(10, window.frame.height, width, height)
                self.dimedView.backgroundColor = UIColor(white: 0, alpha: 0)
            }
        })
        
        dimedView.removeFromSuperview()
    }
    
    //IM USING THIS FUNCTION 3 TIMES!!!!!! MAKe IT ONE. CODE DUPLICATED 3 TIMES!!!!!!!!!
    
    func handleDissmiss() {
        
        UIView.animateWithDuration(0.2, animations: {
            
            if let window = UIApplication.sharedApplication().keyWindow {
                
                let width = window.frame.width - 20
                let height = window.frame.height / 2.5
                
                _ = CGRectMake(10, window.frame.height, width, height)
                self.dimedView.backgroundColor = UIColor(white: 0, alpha: 0)

            }
        })
        
        dimedView.removeFromSuperview()
    }
}