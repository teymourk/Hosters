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
        
//        let explore = Explore(collectionViewLayout: layout)
//            explore.navigationItem.title = "Explore"
//        let navigationController2 = UINavigationController(rootViewController: explore)
//            navigationController2.tabBarItem.image = UIImage(named: "search-normal")
        
        let userProfile = UserProfile(collectionViewLayout: UICollectionViewFlowLayout())
            userProfile.navigationItem.title = "Profile"
        let navigationController3 = UINavigationController(rootViewController: userProfile)
            navigationController3.tabBarItem.image = UIImage(named: "profile-1")
        
        self.navigationItem.hidesBackButton = true
        viewControllers = [navigationController, navigationController3]
    }
}
