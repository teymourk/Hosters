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
import EPCalendarPicker

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
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            indicator.center = self.view.center
            indicator.color = .white
        return indicator
    }()
    
    lazy var refresher:UIRefreshControl = {
        let refresh = UIRefreshControl()
            refresh.addTarget(self, action: #selector(onRefreshPage), for: .valueChanged)
        return refresh
    }()
    
    let pageNotification:PageNotifications = {
        let notification = PageNotifications()
        return notification
    }()
    
    let navBarSeperator:UIView = {
        let view = UIView()
            view.backgroundColor = orange
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        locationManager?.requestWhenInUseAuthorization()
        
        setupCollectionView()
        setupNavSeperator()
        
        eventTypeFetch(index: 0, typeIndex: 0)
        
        guard let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        AppDelegate.loadDataFromFacebook()
    }

    internal func setupNavSeperator() {
        
        view.addSubview(navBarSeperator)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: navBarSeperator)
        view.addConstrainstsWithFormat("V:|[v0(2)]", views: navBarSeperator)
    }
    
    fileprivate func setupCollectionView() {
        
        collectionView?.addSubview(refresher)
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: CELL_FEED)
        collectionView?.backgroundColor = UIColor.rgb(231, green: 236, blue: 240)
    }
        
    internal func navigateToEventDetails(eventDetail:Events) {
        
        let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        
        let eventPage = AllEventPhotos(collectionViewLayout: layout)
            eventPage._eventDetails = eventDetail
        self.navigationController?.pushViewController(eventPage, animated: true)
    }
    
    internal func handlePushingToGuestPage(_eventId:String) {
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
    }
    
    func onRefreshPage() {
        
        if Reachability.isInternetAvailable() {
            
        } else {
            
            pageNotification.showNotification("Not Connected To The Internet 😭")
        }
        
        refresher.endRefreshing()
    }
    
    private func eventTypeFetch(index: Int, typeIndex:Int) {

        var indexs:Int = Int()
        var typeIndexs:Int = Int()
        
        let hasntHappenedPred = NSPredicate(format: "isLive = %d", 1)
        let endedPred = NSPredicate(format: "isLive = %d AND rsvp_status = %@", 2, "attending")
        let livePred = NSPredicate(format: "isLive = %d", 3)
        
        var entityNames = ["Events", "Invited","Attending", "Maybe", "Events"]
        
        if typeIndex != entityNames.count {
        
            let event = Events.FetchData(predicate: hasntHappenedPred, entity: entityNames[typeIndex])
            
            if !event.isEmpty {
                
                self.eventsDictionary?[index] = event
                indexs = index + 1
                typeIndexs = typeIndex + 1
                self.eventTypeFetch(index:indexs, typeIndex: typeIndexs)
                
            } else{
                
                typeIndexs = typeIndex + 1
                self.eventTypeFetch(index: index, typeIndex: typeIndexs)
            }
            
            let lastIndex = (self.eventsDictionary?.count)! - 1
            
            if typeIndex == lastIndex {
                
                let endedEvents = Events.FetchData(predicate: endedPred, entity: entityNames[entityNames.count - 1])
                
                if !endedEvents.isEmpty{
                    
                    self.eventsDictionary?[typeIndex] = endedEvents
                    
                } else {
                    return
                }
                
            } else if typeIndex == 0 {
                
                let liveEvents = Events.FetchData(predicate: livePred, entity: entityNames[entityNames.count - 1])
                
                if !liveEvents.isEmpty {
                    
                    self.eventsDictionary?[typeIndex] = liveEvents
                    
                } else {
                    return
                }
            }
        }
    }
}
