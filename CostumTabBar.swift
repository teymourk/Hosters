//
//  CostumTabBar.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/11/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData

class CostumeTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarOptions()
        setupTopBorderLayer()
    }
    
    func setupTabBarOptions() {
        
        //TabbarItem: Home
        let friendsFeedView = HomePage(collectionViewLayout: UICollectionViewFlowLayout())
        friendsFeedView.navigationItem.title = "Home"
        let homeNavigationController = UINavigationController(rootViewController: friendsFeedView)
        homeNavigationController.tabBarItem.image = UIImage(named: "home-normal")
        
        //TabBarItem: Search
        let search = SearchUsers()
        search.navigationItem.title = "Search"
        let searchNavigationController = UINavigationController(rootViewController: search)
        searchNavigationController.tabBarItem.image = UIImage(named: "search-normal")
        
        //TabbarItem: Add/Take Images
        let addPictureView = AddOrPost()
        addPictureView.navigationItem.title = "Active Posts"
        let addImageNavigationController = UINavigationController(rootViewController: addPictureView)
        addImageNavigationController.tabBarItem.image = UIImage(named: "add")
        
        //TabBarItem: Profile
        let profilePage = UsersProfile(collectionViewLayout: UICollectionViewFlowLayout())
        let userProfileNavigationController = UINavigationController(rootViewController: profilePage)
        userProfileNavigationController.tabBarItem.image = UIImage(named: "profile-1")
        
        getCurrentUserInfo(profilePage: profilePage)
        
        //TabBarItem: Notification
        let notifications = Notifications(collectionViewLayout: UICollectionViewFlowLayout())
        notifications.navigationItem.title = "Notifications"
        let notificationsNavigationController = UINavigationController(rootViewController: notifications)
        notificationsNavigationController.tabBarItem.image = UIImage(named: "notifications")
        
        navigationItem.hidesBackButton = true
        viewControllers = [homeNavigationController, searchNavigationController, addImageNavigationController,notificationsNavigationController, userProfileNavigationController]
    }
    
    func setupTopBorderLayer() {
    
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 2)
        topBorder.backgroundColor = orange.cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        tabBar.isTranslucent = false
        tabBar.barStyle = .black
    }
    
    fileprivate func getCurrentUserInfo(profilePage:UsersProfile) {

        FirebaseRef.database.currentUser.observe(.value, with: {
            snapshot in
            
            if let snapshotData = snapshot.value as? [String:AnyObject] {
                
                for(_, userObj) in snapshotData {
                    
                    if let name = userObj["name"] as? String, let username = userObj["username"] as? String, let profileImage = userObj["profileImage"] as? String {
                     
                        let currenUser = Users(context: context)
                    
                        currenUser.name = name
                        currenUser.username = username
                        currenUser.profileImage = profileImage
                        currenUser.userKey = FirebaseRef.database.currentUser.key
                        
                        profilePage.profileDetails = currenUser
                        
                        do {
                            try(context.save())
                            
                        } catch let err {
                            print(err)
                        }
                    }
                }
            }
        })
    }
}
