//
//  EventDetailsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/1/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EventDetailCell:EventsCell {
    
    override var _eventDetails: Events? {
        didSet {
            
            guard let eventDetails = _eventDetails, let eventHost = eventDetails.owner_name else {return}
            
            setupEventDetails(eventDetails: eventDetails)
            
            if let eventDetails = eventDetails.descriptions {
                
                detailsTextView.text = eventDetails
                
            } else {
                
                detailsTextView.text = "No Details Available 😯"
            }
            
            host.text = "👤 \(eventHost)"
            location.textColor = .lightGray //Override Color
            
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
        
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
    
    var detailsTextView:UITextView = {
        let textView = UITextView()
            textView.font = UIFont(name: "NotoSans", size: 12)
            textView.isEditable = false
            textView.isSelectable = false
            textView.isScrollEnabled = false
            textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var moreBtn:UIButton = {
        let btn = UIButton()
            btn.setImage(UIImage(named: "down"), for: .normal)
            btn.addTarget(self, action: #selector(onMoreBtn(sender :)), for: .touchUpInside)
       return btn
    }()
    
    override func setupView() {
        
        backgroundColor = .white
        
        handleLayout()
    }
    
    @objc private func startCountDown() {
        
        if let event = _eventDetails, let isLive = event.isLive, let eventTime = event.start_time, let endTime = event.end_time {
            
            switch isLive {
            case 1:
                countDown.text = "⏰ Starting: \(eventTime.countDown())"
                countDown.textColor = .rgb(24, green: 201, blue: 86)
                break
            case 2:
                countDown.text = "❌ Event Ended"
                countDown.textColor = .rgb(181, green: 24, blue: 34)
                break
            case 3:
                countDown.text = "⏰ Ending: \(endTime.countDown())"
                countDown.textColor = .rgb(181, green: 24, blue: 34)
                break
                
            default: break
                
            }
        }
    }
    
    internal func onMoreBtn(sender: UIButton) {
        
        if delegate != nil {
            delegate?.onMoreBtn(sender: sender)
        }
    }
    
    override func handleLayout() {
        
        addSubview(title)
        
        title.textAlignment = .center
        title.font = UIFont(name: "Prompt", size: 20)
        
        title.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        
        addSubview(location)
        
        location.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        location.topAnchor.constraint(equalTo: title.bottomAnchor, constant:25).isActive = true
        location.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(guestCountsButton)
        
        guestCountsButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        guestCountsButton.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 25).isActive = true
        guestCountsButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(host)
        
        host.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        host.rightAnchor.constraint(equalTo: centerXAnchor).isActive = true
        host.topAnchor.constraint(equalTo: guestCountsButton.bottomAnchor, constant: 25).isActive = true
        host.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(countDown)
        
        countDown.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        countDown.centerYAnchor.constraint(equalTo: host.centerYAnchor).isActive = true
        countDown.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(seperator)
        
        seperator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: countDown.bottomAnchor, constant: 10).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        //addSubview(detailsTextView)
        
        //detailsTextView.leftAnchor.constraint(equalTo: host.leftAnchor).isActive = true
        //detailsTextView.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 5).isActive = true
        //detailsTextView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(moreBtn)
        
        addConstrainstsWithFormat("H:|[v0]|", views: moreBtn)
        addConstrainstsWithFormat("V:[v0(40)]-5-|", views: moreBtn)
        
        moreBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
