//
//  CostumeTabBarController.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/11/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit


class CostumeTabBar: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barStyle = .Default
        self.tabBarItem.set
        self.tabBar.translucent = false
        
        //TabbarItem: Friends Feed
        let friendsFeedView = FriendsFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
            friendsFeedView.navigationItem.title = "Following"
        let navigationController = UINavigationController(rootViewController: friendsFeedView)
            navigationController.tabBarItem.image = UIImage(named: "home")
        
        //Search User
        let searchFeedView = SearchUsersVC()
            searchFeedView.navigationItem.title = "Search"
        let secondNavigationController = UINavigationController(rootViewController: searchFeedView)
            secondNavigationController.tabBarItem.image = UIImage(named: "search_filled")
        
        //TabbarItem: Add/Take Images
        let addPictureView = AddView()
            addPictureView.navigationItem.title = "Tyloo"
        let thirdNavigationController = UINavigationController(rootViewController: addPictureView)
            thirdNavigationController.tabBarItem.image = UIImage(named: "Add")
    
        let messagingView = MessaginVC(collectionViewLayout: UICollectionViewLayout())
            addPictureView.navigationItem.title = "Chat"
        let fifthNavigationController = UINavigationController(rootViewController: messagingView)
            fifthNavigationController.tabBarItem.image = UIImage(named: "chat_filled")
        
        //TabbarItem: Notifications
        let quickPicturesView = PicturesVC()
            quickPicturesView.navigationItem.title = "Photos"
        let fourthNavigationController = UINavigationController(rootViewController: quickPicturesView)
            fourthNavigationController.tabBarItem.image = UIImage(named: "stack_of_photos")
        
        self.navigationItem.hidesBackButton = true
        viewControllers = [navigationController, secondNavigationController, thirdNavigationController,fifthNavigationController,fourthNavigationController]
    }

}

