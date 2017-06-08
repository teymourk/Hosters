//
//  ProfileHeader.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/7/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class ProfileHeader: BaseCell {

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
            label.font = UIFont(name: "Prompt", size: 15)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        addSubview(profileImage)
        
        profileImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        
        profileImage.layer.cornerRadius = 40
        
        addSubview(name)
        
        name.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true

        getUserData()
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
