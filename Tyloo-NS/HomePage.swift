//
//  FriendsPostsView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/11/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//
import UIKit
import MBProgressHUD
import MapKit
import CoreData
import FBSDKCoreKit

private let CELL_FEED = "Cell_FEED"
private let HEADER_ID = "Header_ID"

class HomePage: UICollectionViewController, CLLocationManagerDelegate {
    
    var events:[[Events]]? {
        didSet {
            
            self.collectionView?.reloadData()
        }
    }
    
    lazy var locationManager:CLLocationManager? = {
        let manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    lazy var refresher:UIRefreshControl = {
        let refresh = UIRefreshControl()
            refresh.tintColor = orange
            refresh.addTarget(self, action: #selector(onRefreshPage), for: .valueChanged)
        return refresh
    }()
    
    let pageNotification:PageNotifications = {
        let notification = PageNotifications()
        return notification
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
    
        locationManager?.requestWhenInUseAuthorization()

        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: CELL_FEED)
        collectionView?.register(EventHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_ID)
        collectionView?.addSubview(refresher)
        collectionView?.backgroundColor = .white
        
        fetchEvents()
    }
    
    func fetchEvents() {
        
        Events.fetchEventsFromFacebook(refresher:refresher, type: "not_replied") { (events) in
            
            self.events = events
        }
    }
    
    func onRefreshPage() {
        
        if Reachability.isInternetAvailable() {
            
        } else {
            
            pageNotification.showNotification("Not Connected To The Internet 😭")
        }
        
        refresher.endRefreshing()
    }
    

    var seperator:UIView = {
        let seperator = UIView()
            seperator.backgroundColor = orange
            seperator.translatesAutoresizingMaskIntoConstraints = false
        return seperator
    }()
    
}
