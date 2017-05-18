//
//  EventDetailsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/27/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EventDetailsCell: BaseCell {
    
    var eventDetails:Events? {
        didSet {
            
            if let eventTitle = eventDetails?.name {
                
                title.text = eventTitle
            }
            
            if let place_name = eventDetails?.place_name, let city = eventDetails?.city, let state = eventDetails?.state {
                
                addressLabel.text = "📍\(place_name) - \(city), \(state)"
                
            } else {
                
                addressLabel.text = "Location Not Available 💩"
            }
        }
    }
    
    let title:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.font = UIFont(name: "Prompt", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLabel:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.text = "Address Goes Here"
            label.textColor = buttonColor
            label.font = UIFont(name: "Prompt", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(title)
        
        title.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        
        addSubview(addressLabel)
        
        addressLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
    }
}
