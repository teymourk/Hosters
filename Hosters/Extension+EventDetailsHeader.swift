//
//  Extension+EventsHeader.swift
//  Tyloo
//
//  Created by Kiarash Teymoury on 7/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import Foundation

extension EventDetailsHeader {
    
    internal func setupOptionsView() {
        
        addSubview(optionsView)
        
        optionsView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        optionsView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        optionsView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    internal func setupShareOptions() {
        
        optionsView.removeFromSuperview()
        
        backgroundColor = .white
        
        addSubview(shareOptionCV)
        
        shareOptionCV.topAnchor.constraint(equalTo: topAnchor).isActive = true
        shareOptionCV.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        shareOptionCV.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    internal func handleNoImagesView() {
        
        addSubview(noImagesView)
        
        noImagesView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        noImagesView.rightAnchor.constraint(equalTo: optionsView.leftAnchor).isActive = true
        noImagesView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        noImagesView.topAnchor.constraint(equalTo: optionsView.topAnchor).isActive = true
    }
    
    internal func handleWithImagesView() {
        
        addSubview(collectionView)
        
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: optionsView.leftAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: optionsView.topAnchor).isActive = true
        
    }
}
