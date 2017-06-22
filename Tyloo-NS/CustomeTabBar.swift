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
        
        setupTopBorderLayer()
        
        let layout = UICollectionViewFlowLayout()
    
        let invitedEvents = HomePage(collectionViewLayout: layout)
            invitedEvents.navigationItem.title = "Home"
        let navigationController = UINavigationController(rootViewController: invitedEvents)
            navigationController.tabBarItem.image = UIImage(named: "home-normal")
        
        let explore = Explore(collectionViewLayout: layout)
            explore.navigationItem.title = "Explore"
        let navigationController2 = UINavigationController(rootViewController: explore)
            navigationController2.tabBarItem.image = UIImage(named: "search-normal")
        
        let userProfile = UserProfile(collectionViewLayout: UICollectionViewFlowLayout())
            userProfile.navigationItem.title = "Profile"
        let navigationController3 = UINavigationController(rootViewController: userProfile)
            navigationController3.tabBarItem.image = UIImage(named: "profile-1")
        
        self.navigationItem.hidesBackButton = true
        
        viewControllers = [navigationController,
                           navigationController2,
                           navigationController3]
    }
    
    fileprivate func setupTopBorderLayer() {
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 2)
        topBorder.backgroundColor = orange.cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        tabBar.isTranslucent = false
        tabBar.barStyle = .black
    }
}
