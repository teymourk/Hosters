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
            label.font = UIFont(name: "Prompt", size: 13)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(date)
        
        date.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        date.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        date.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        seperator.leftAnchor.constraint(equalTo: date.leftAnchor).isActive = true
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
