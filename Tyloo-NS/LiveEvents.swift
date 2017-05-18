//
//  LiveEvents.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/30/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CELL_FEED"

class LiveEvents: HomeCVCell {
    
    override var events: [Events]? {
        
        didSet {
            
            guard let events = events else {return}
            
            if events.isEmpty {
                
                setupNoLiveLabel()
                return
                
            }
                
            self.eventCollectionView.reloadData()
            self.noLiveLabel.removeFromSuperview()
        }
    }
    
    let noLiveLabel:UILabel = {
        let label = UILabel()
            label.text = "There Are No Live Events 🙄"
            label.font = UIFont(name: "NotoSans", size: 14)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    internal func setupNoLiveLabel() {
        
        addSubview(noLiveLabel)
        
        noLiveLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        noLiveLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        noLiveLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}


