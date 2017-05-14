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
import SCLAlertView

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
        collectionView?.backgroundColor = UIColor.rgb(231, green: 236, blue: 240)
        
        let filterDateButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(onDatePicker(sender:)))
        navigationItem.rightBarButtonItem = filterDateButton
        
        eventTypeFetch(index: 0, typeIndex: 0)
    }
    
    internal func onDatePicker(sender: UIBarButtonItem) {
        
        SCLAlertView().showInfo("Adding Calendar", subTitle: "Be Patient")
    }
    
    internal func eventTypeFetch(index: Int, typeIndex:Int) {
        
        var indexs:Int = Int()
        var typeIndexs:Int = Int()
        let type = ["not_replied", "attending", "maybe"]
        
        if typeIndex != type.count {
            
            Events.fetchEventsFromFacebook(refresher:refresher, type: type[typeIndex]) { (allEvents, live) in
                
                if !allEvents.isEmpty {
                    
                    self.eventsDictionary?[index] = allEvents
                    indexs = index + 1
                    typeIndexs = typeIndex + 1
                    self.eventTypeFetch(index:indexs, typeIndex: typeIndexs)
                    
                } else{
                    
                    typeIndexs = typeIndex + 1
                    self.eventTypeFetch(index: index, typeIndex: typeIndexs)
                    
                }
                
                if !live.isEmpty {
                    
                    self.liveEventArray = live
                }
            }
        }
        
        self.collectionView?.reloadData()
    }
    
    internal func navigateToEventDetails(eventDetail:Events) {
        
        let eventPage = EventDetailsPage(collectionViewLayout: UICollectionViewFlowLayout())
            eventPage._eventDetails = eventDetail
        self.navigationController?.pushViewController(eventPage, animated: true)
    }
    
    internal func handlePushingToGuestPage(_eventId:String) {
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
    
        let guestPage = EventGuestsPage(collectionViewLayout: layout)
            guestPage.event_id = _eventId
        navigationController?.pushViewController(guestPage, animated: true)
    }
    
    func onRefreshPage() {
        
        if Reachability.isInternetAvailable() {
            
        } else {
            
            pageNotification.showNotification("Not Connected To The Internet 😭")
        }
        
        refresher.endRefreshing()
    }    
}
