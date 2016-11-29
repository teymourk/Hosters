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
        let layout = UICollectionViewFlowLayout()
            layout.sectionHeadersPinToVisibleBounds = true
        let friendsFeedView = HomePage(collectionViewLayout: layout)
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
    
        navigationItem.hidesBackButton = true
        viewControllers = [homeNavigationController, addImageNavigationController, searchNavigationController]
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
}
