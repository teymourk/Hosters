//
//  CustomeTabBar.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/21/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class CostumeTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barStyle = .default
        self.tabBar.isTranslucent = false
        
        let layout = UICollectionViewFlowLayout()

        let invitedEvents = HomePage(collectionViewLayout: layout)
        invitedEvents.navigationItem.title = "Home"
        let navigationController = UINavigationController(rootViewController: invitedEvents)
        navigationController.tabBarItem.image = UIImage(named: "home-normal")
        
        let userProfile = UserProfile()
        userProfile.navigationItem.title = "Profile"
        let navigationController2 = UINavigationController(rootViewController: userProfile)
        navigationController2.tabBarItem.image = UIImage(named: "profile-1")
        
        self.navigationItem.hidesBackButton = true
        viewControllers = [navigationController, navigationController2]
    }
    
}
