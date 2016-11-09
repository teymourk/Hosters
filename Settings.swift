//
//  SettingsVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/30/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase

class Settings: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        setupView()
    }
    
    func setupView() {
    
        let logOutButton = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogout(_ :)))
        navigationItem.rightBarButtonItem = logOutButton
    }
    
    func handleLogout(_ sender: UIButton) {
        
        do {
            
            try FIRAuth.auth()?.signOut()
            
        } catch let error {
            print(error)
        }
    
        UserDefaults.standard.setValue(nil, forKey: KEY_UID)
    }
}
