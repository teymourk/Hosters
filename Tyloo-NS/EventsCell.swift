//
//  EventsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/25/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EventsCell: BaseCell {
    
        var _eventDetails:Events? {
            didSet {
                
                guard let eventDetails = _eventDetails else {return}
                    
                    headerView.eventDetails = eventDetails
                
                if let coverURL = eventDetails.coverURL {
                    
                    coverImage.getImagesBack(url: coverURL, placeHolder: "emptyImage")
                }
                
                if let eventTitle = eventDetails.name {
                    
                    title.text = eventTitle
                }
                
                if let place_name = eventDetails.place_name, let city = eventDetails.city, let state = eventDetails.state {
                    
                    location.text = "📍\(place_name) - \(city), \(state)"
                    
                } else {
                    
                    location.text = "Location Not Available 🤔"
                }
                
                if let interestedCount = eventDetails.interested_count, let declinedCount = eventDetails.declined_count, let attendingCount = eventDetails.attending_count {
                    
                    guestCounts.text = "✅ Going: \(attendingCount) . 🤔 Interested: \(interestedCount) . ❌ Not Going: \(declinedCount)"
                }
            }
        }
    
    let headerView:HeaderView = {
        let hd = HeaderView()
            hd.translatesAutoresizingMaskIntoConstraints = false
        return hd
    }()
    
    let coverImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.masksToBounds = true
            image.image = UIImage(named: "emptyCover")
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let title:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.font = UIFont(name: "Prompt", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let location:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.font = UIFont(name: "Prompt", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let guestCounts:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.font = UIFont(name: "Prompt", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {

        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = darkGray.cgColor
        
        addSubview(headerView)
        
        addConstrainstsWithFormat("H:|[v0]|", views: headerView)
        addConstrainstsWithFormat("V:|[v0(40)]", views: headerView)
        
        addSubview(coverImage)
        
        addConstrainstsWithFormat("H:|[v0]|", views: coverImage)
        
        coverImage.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: FEED_CELL_HEIGHT / 2.3).isActive = true
        
        addSubview(title)
        
        title.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        title.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant:5).isActive = true
        title.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(location)
        
        location.widthAnchor.constraint(equalTo: title.widthAnchor).isActive = true
        location.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        location.topAnchor.constraint(equalTo: title.bottomAnchor, constant:5).isActive = true
        location.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(guestCounts)
        
        guestCounts.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        guestCounts.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        guestCounts.topAnchor.constraint(equalTo: location.bottomAnchor, constant:5).isActive = true
        guestCounts.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
}



class HeaderView:BaseView {
    
    var eventDetails:Events? {
        
        didSet {
            
            guard let headerDetail = eventDetails, let eventDate = headerDetail.start_time, let eventHost = headerDetail.owner_name else {return}
            
            date.text = eventDate.produceDate()
            host.text = "Hosted By \(eventHost)"
            
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
            timer.fire()
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
            label.font = UIFont(name: "Prompt", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal func startCountDown() {
        
        if let eventTime = eventDetails?.start_time {
            
            countDown.text = eventTime.countDown()
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
