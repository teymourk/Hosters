//
//  UserProfile.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/26/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class UserProfile: UIViewController {
    
    let pageNotfication:PageNotifications = {
        let pg = PageNotifications()
        return pg
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        pageNotfication.showNotification("Working On The Layout")
    }
}
