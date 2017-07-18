//
//  SettingsVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/30/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        view.backgroundColor = .whiteColor()
        navigationController?.navigationBar.translucent = false
        
        setupView()
        
        ///Temperary
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    func handleLogout() {
        
        FirebaseRef.Fb.currentUser.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
        navigationController?.dismissViewControllerAnimated(false, completion: nil)
    }

    func setupView() {
    
        
    }
}
