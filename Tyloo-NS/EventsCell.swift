//
//  EventsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/25/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

protocol EventCellDelegate: class {
    
    func handleOnGuest(sender: UIButton)
}

class EventsCell: BaseCell {
    
    var _eventDetails:Events? {
        didSet {
            
            guard let eventDetails = _eventDetails else {return}
            
            setupEventDetails(eventDetails: eventDetails)
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
    
    lazy var guestCountsButton:UIButton = {
        let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont(name: "Prompt", size: 12)
            button.addTarget(self, action: #selector(handleOnGuests(sender:)), for: .touchUpInside)
            button.setTitleColor(buttonColor, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var delegate:EventCellDelegate?
    
    internal func setupEventDetails(eventDetails: Events) {
        
        headerView.eventDetails = eventDetails
        
        if let coverURL = eventDetails.coverURL {
            
            coverImage.getImagesBack(url: coverURL, placeHolder: "emptyImage")
            
        } else {
            
            coverImage.image = UIImage(named: "emptyCover")
        }
        
        if let eventTitle = eventDetails.name {
            
            title.text = eventTitle
        }
        
        if let place_name = eventDetails.place_name, let city = eventDetails.city, let state = eventDetails.state {
            
            location.text = "📍\(place_name) - \(city), \(state)"
            
        } else {
            
            location.text = "Location Not Available 💩"
        }
        
        if let interestedCount = eventDetails.interested_count, let declinedCount = eventDetails.declined_count, let attendingCount = eventDetails.attending_count, let guest_list_Enabled = eventDetails.guest_list_enabled {
            
            let color = guest_list_Enabled == true ? buttonColor : darkGray
            
            guestCountsButton.setTitle("✅ Going: \(attendingCount) • 🤔 Interested: \(interestedCount) • ❌ Not Going: \(declinedCount)", for: .normal)
            guestCountsButton.setTitleColor(color, for: .normal)
        }
    }

    override func setupView() {
        
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.cornerRadius = 2
        layer.borderColor = darkGray.cgColor
        setShadow()
        handleCellAnimation()
        
        backgroundColor = .white
        
        setupViewHeader()
        
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
        
        addSubview(seperator)
        
        seperator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 5).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        addSubview(guestCountsButton)
        
        guestCountsButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        guestCountsButton.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 10).isActive = true
        guestCountsButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    internal func setupViewHeader() {
        
        addSubview(headerView)
        
        headerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(coverImage)
        
        coverImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        coverImage.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: FEED_CELL_HEIGHT / 2.3).isActive = true
    }
    
    internal func handleOnGuests(sender: UIButton) {
        
        if delegate != nil {
            delegate?.handleOnGuest(sender: sender)
        }
    }
}

class HeaderView:BaseView {
    
    var eventDetails:Events? {
        
        didSet {
            
            guard let headerDetail = eventDetails, let eventDate = headerDetail.start_time, let eventHost = headerDetail.owner_name else {return}
            
            date.text = eventDate.produceDate()
            host.text = "By \(eventHost)"
            
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
        
        if let event = eventDetails, let isLive = event.isLive, let eventTime = event.start_time, let endTime = event.end_time {
            
            switch isLive {
            case 1:
                countDown.text = "Starting: \(eventTime.countDown())"
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
