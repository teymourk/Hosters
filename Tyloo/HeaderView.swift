//
//  HeaderView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/1/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class HeaderView:BaseView {
    
    weak var eventDetails:Events? {
        
        didSet {
            
            guard let headerDetail = eventDetails, let eventDate = headerDetail.start_time as Date?, let hostName = headerDetail.owner_name else {return}
            
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
            timer.fire()
            
            date.text = eventDate.produceDate()
            host.text = "By \(hostName)"
        }
    }
    
    let date:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Prompt", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countDown:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Prompt", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let host:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "NotoSans", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal func startCountDown() {
        
        if let event = eventDetails, let isLive = event.isLive as Int16?, let startTime = event.start_time as Date?, let endTime = event.end_time as Date? {
            
            switch isLive {
            case 1:
                countDown.text = "Starting: \(startTime.countDown())"
                countDown.textColor = .rgb(24, green: 201, blue: 86)
                break
            case 2:
                countDown.text = "Event Ended"
                countDown.textColor = .rgb(181, green: 24, blue: 34)
                break
            case 3:
                countDown.text = "Ending: \(endTime.countDown())"
                countDown.textColor = .rgb(181, green: 24, blue: 34)
                break
                
            default: break
                
            }
        }
    }
    
    override func setupView() {
        
        backgroundColor = .white
        
        addSubview(host)
        
        host.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        host.rightAnchor.constraint(equalTo: centerXAnchor).isActive = true
        host.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        host.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(date)
        
        date.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        date.topAnchor.constraint(equalTo: topAnchor, constant:3).isActive = true
        date.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(countDown)
        
        countDown.rightAnchor.constraint(equalTo: date.rightAnchor).isActive = true
        countDown.topAnchor.constraint(equalTo: date.bottomAnchor, constant:5).isActive = true
        countDown.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
}
