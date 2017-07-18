//
//  Extension+HeaderView.swift
//  Tyloo
//
//  Created by Kiarash Teymoury on 7/18/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

extension HeaderView {
    
    func setupLayout() {
        
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
