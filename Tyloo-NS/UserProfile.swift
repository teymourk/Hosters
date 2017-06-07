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
    
    lazy var profileImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.masksToBounds = true
            image.layer.borderWidth = 1
            image.layer.borderColor = orange.cgColor
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let name:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.font = UIFont(name: "NotoSans-Bold", size: 15)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let navBarSeperator:UIView = {
        let view = UIView()
            view.backgroundColor = orange
        return view
    }()
    
    let seperator:UIView = {
        let view = UIView()
            view.backgroundColor = orange
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        let logout = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logout(sender: )))
        navigationItem.leftBarButtonItem = logout
        
        setupView()
        
        getUserData()
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
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        
        profileImage.layer.cornerRadius = 50
        
        view.addSubview(name)
  
        name.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(seperator)
        
        seperator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 40).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(navBarSeperator)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: navBarSeperator)
        view.addConstrainstsWithFormat("V:|[v0(2)]", views: navBarSeperator)
    }
    
    private func getUserData() {
        
        FirebaseRef.database.currentUser.observe(.value, with: { (snapshot) in
            
            if let userDic = snapshot.value as? [String:AnyObject] {
                
                if let userObj = userDic["user"] as? NSDictionary, let name = userObj["name"] as? String, let profile_Image = userObj["profileImage"] as? String {
                
                    DispatchQueue.main.async {
                        
                        self.profileImage.getImagesBack(url: profile_Image, placeHolder: "Profile")
                        self.name.text = name
                    }
                }
            }
        })
    }
}
