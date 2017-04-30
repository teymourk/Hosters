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
private let HEADER_ID = "HEADER_ID"

class HomePage: UICollectionViewController, CLLocationManagerDelegate {
    
    var eventsDictionary:[Int:[Events]]? = [Int:[Events]]()
    var liveEventArray:[Events]? = [Events]()
    

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
        
        locationManager?.requestWhenInUseAuthorization()

        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: CELL_FEED)
        collectionView?.register(LiveEvents.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_ID)
        collectionView?.addSubview(refresher)
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        fetchEvents()
    }
    
    internal func eventTypeFetch(index:Int, type:String) {
        
        Events.fetchEventsFromFacebook(refresher:refresher, type: type) { (events) in
            
            if !events.isEmpty {
                
                self.eventsDictionary?[index] = events
                self.collectionView?.reloadData()
                
            } else {
                
                print("NO EVENTS FOUND")
            }
        }
    }
    
    func fetchEvents() {
        
        eventTypeFetch(index: 0, type: "not_replied")
        //eventTypeFetch(index: 1, type: "attending")
        eventTypeFetch(index: 1, type: "maybe")
        //eventTypeFetch(index: 3, type: "declined")
    }
    
    internal func navigateToEventDetails(eventDetail:Events) {
        
        let eventPage = EventDetailsPage(collectionViewLayout: UICollectionViewFlowLayout())
            eventPage._eventDetails = eventDetail
        self.navigationController?.pushViewController(eventPage, animated: true)
    }
    
    func onRefreshPage() {
        
        if Reachability.isInternetAvailable() {
            
        } else {
            
            pageNotification.showNotification("Not Connected To The Internet 😭")
        }
        
        refresher.endRefreshing()
    }    
}
