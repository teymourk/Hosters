//
//  UploadProgressView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/8/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class UploadProgressView: NSObject {

    var blackView:UIView = {
        let view = UIView()
            view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    
    var uploadView:UIView = {
        let view = UIView()
            view.backgroundColor = .white
       return view
    }()
    
    let progressBar:UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
            progress.progressTintColor = orange
            progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    func showUplodView(_ progress:Double) {
        
        if let window = UIApplication.shared.keyWindow {
            
            window.addSubview(blackView)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(uploadView)
            
            uploadView.addSubview(progressBar)
            
            //ProgressBar Constraints
            progressBar.centerXAnchor.constraint(equalTo: uploadView.centerXAnchor).isActive = true
            progressBar.centerYAnchor.constraint(equalTo: uploadView.centerYAnchor).isActive = true
            progressBar.leftAnchor.constraint(equalTo: uploadView.leftAnchor, constant: 25).isActive = true
            progressBar.rightAnchor.constraint(equalTo: uploadView.rightAnchor, constant: -25).isActive = true
            
            let height = FEED_CELL_HEIGHT * 0.25
            let width = window.frame.width
            let y = window.frame.height - height
            
            self.uploadView.frame = CGRect(x: 0, y: window.frame.height, width: width, height: height)
            
            UIView.animate(withDuration: 0.7, animations: {
                
                self.blackView.alpha = 1
                self.uploadView.frame = CGRect(x: 0, y: y, width: width, height: height)
            })
        }
    }
}
