//
//  EventPage.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/26/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EventPage: UIViewController {
    
    var _eventDetails:Events? {
        didSet {
            
            guard let eventDetails = _eventDetails else {return}
            
            if let imageURL = eventDetails.coverURL {
                
                coverImage.getImagesBack(url: imageURL, placeHolder: "emptyImage")
            }
        }
    }
    
    var coverImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.masksToBounds = true
        return image
    }()
    
    
    let pageNotfication:PageNotifications = {
        let pg = PageNotifications()
        return pg
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Event Page"

        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: coverImage)
        view.addConstrainstsWithFormat("V:|[v0(50)]", views: coverImage)
    }
}
