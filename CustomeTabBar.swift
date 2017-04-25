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
            layout.sectionHeadersPinToVisibleBounds = true
        
        let invitedEvents = HomePage(collectionViewLayout: layout)
        invitedEvents.navigationItem.title = "Invited"
        let navigationController = UINavigationController(rootViewController: invitedEvents)
        navigationController.tabBarItem.title = "Invited"
        
        let attendingEvents = AttendingPage(collectionViewLayout: UICollectionViewFlowLayout())
        attendingEvents.navigationItem.title = "Attending"
        let secondNavigationController = UINavigationController(rootViewController: attendingEvents)
        secondNavigationController.tabBarItem.title = "Attending"

        let declinedEvents = DeclinedPage(collectionViewLayout: UICollectionViewFlowLayout())
        declinedEvents.navigationItem.title = "Declined"
        let thirdNavigationController = UINavigationController(rootViewController: declinedEvents)
        thirdNavigationController.tabBarItem.title = "Declined"
        
        let UnsureEvents = UnsurePage(collectionViewLayout: UICollectionViewFlowLayout())
        UnsureEvents.navigationItem.title = "Unsure"
        let fourthNavigationController = UINavigationController(rootViewController: UnsureEvents)
        fourthNavigationController.tabBarItem.title = "Unsure"
        
        let myEvents = MyPage(collectionViewLayout: UICollectionViewLayout())
        myEvents.navigationItem.title = "Created"
        let fifthNavigationController = UINavigationController(rootViewController: myEvents)
        fifthNavigationController.tabBarItem.title = "Created"
        
        self.navigationItem.hidesBackButton = true
        viewControllers = [navigationController, secondNavigationController, thirdNavigationController,fourthNavigationController, fifthNavigationController]
    }
    
}
