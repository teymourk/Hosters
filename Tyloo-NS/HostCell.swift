//
//  HoseCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class HostCell: StatusCell {

    override var eventDetails: Events? {
        
        didSet {
            
            if let host = eventDetails?.owner_name {
                
                date.text = "👤 \(host)"
            }
        }
    }
    
    override func startCountDown() {}
}
