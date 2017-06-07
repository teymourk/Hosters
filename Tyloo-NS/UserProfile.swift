//
//  UserProfile.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/26/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class UserProfile: UIViewController {
    
    let pageNotfication:PageNotifications = {
        let pg = PageNotifications()
        return pg
    }()
    
    var profileImage:UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "Profile"))
            image.contentMode = .scaleAspectFit
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let navBarSeperator:UIView = {
        let view = UIView()
            view.backgroundColor = orange
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        let logout = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logout(sender: )))
        navigationItem.leftBarButtonItem = logout
        
        setupView()
    }
    
    @objc private func logout(sender: UIBarButtonItem) {
        
        let facebookManager = FBSDKLoginManager()
        
        let logoutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logout = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            
            facebookManager.logOut()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        logoutAlert.addAction(logout)
        logoutAlert.addAction(cancel)
        
        self.present(logoutAlert, animated: true, completion: nil)
    }

    func setupView() {
        
        
        view.addSubview(profileImage)
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        profileImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        
        view.addSubview(navBarSeperator)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: navBarSeperator)
        view.addConstrainstsWithFormat("V:|[v0(2)]", views: navBarSeperator)
    }
}
