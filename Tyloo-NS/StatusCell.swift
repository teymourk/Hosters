//
//  StatusCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class StatusCell: BaseCell {
    
    var eventDetails:Events? {
        
        didSet {
            
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
            timer.fire()
        }
    }

    let date:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.font = UIFont(name: "Prompt", size: 15)
        return label
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(date)
        
        addConstrainstsWithFormat("H:|-5-[v0]|", views: date)
        addConstrainstsWithFormat("V:|[v0]|", views: date)
    }
    
    internal func startCountDown() {
        
        if let event = eventDetails, let isLive = event.isLive, let eventTime = event.start_time, let endTime = event.end_time {
            
            switch isLive {
            case 1:
                date.text = "⏰ Starting: \(eventTime.countDown())"
                date.textColor = .rgb(24, green: 201, blue: 86)
                break
            case 2:
                date.text = "❌ Event Ended"
                date.textColor = .rgb(181, green: 24, blue: 34)
                break
            case 3:
                date.text = "⏰ Ending: \(endTime.countDown())"
                date.textColor = .rgb(181, green: 24, blue: 34)
                break
                
            default: break
                
            }
        }
    }
}
