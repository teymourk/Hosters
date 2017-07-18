//
//  HeaderView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/1/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class HeaderView:BaseView {
    
    weak var _eventDetails:Events? {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    let _eventDate:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.font = UIFont(name: "Prompt", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let _countDown:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.font = UIFont(name: "Prompt", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let _eventHost:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.font = UIFont(name: "NotoSans", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal func startCountDown() {
        
        if  let event = _eventDetails,
            let isLive = event.isLive as Int16?,
            let startTime = event.start_time as Date?,
            let endTime = event.end_time as Date?
        
        {
            
            switch isLive {
            case 1:
                _countDown.text = "Starting: \(startTime.countDown())"
                _countDown.textColor = .rgb(24, green: 201, blue: 86)
                break
            case 2:
                _countDown.text = "Event Ended"
                _countDown.textColor = .rgb(181, green: 24, blue: 34)
                break
            case 3:
                _countDown.text = "Ending: \(endTime.countDown())"
                _countDown.textColor = .rgb(181, green: 24, blue: 34)
                break
                
            default: break
                
            }
        }
    }
    
    fileprivate func updateUI() {
    
        guard   let headerDetail = _eventDetails,
                let eventDate = headerDetail.start_time as Date?,
                let hostName = headerDetail.owner_name else { return }
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(startCountDown),
                                         userInfo: nil,
                                         repeats: true)
            timer.fire()
        
        _eventDate.text = eventDate.produceDate()
        _eventHost.text = "By \(hostName)"
    }
    
    override func setupView() {
        
        backgroundColor = .white
        
        addSubview(_eventHost)
        
        _eventHost.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        _eventHost.rightAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _eventHost.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        _eventHost.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(_eventDate)
        
        _eventDate.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        _eventDate.topAnchor.constraint(equalTo: topAnchor, constant:3).isActive = true
        _eventDate.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(_countDown)
        
        _countDown.rightAnchor.constraint(equalTo: _eventDate.rightAnchor).isActive = true
        _countDown.topAnchor.constraint(equalTo: _eventDate.bottomAnchor, constant:5).isActive = true
        _countDown.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
}
