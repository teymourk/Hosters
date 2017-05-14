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

class HomePage: UICollectionViewController, CLLocationManagerDelegate, EPCalendarPickerDelegate {
    
    var eventsDictionary:[Int:[Events]]? = [Int:[Events]]()
    var liveEventArray:[Events]? = [Events]()
    
    var type = ["not_replied", "attending", "maybe"]
    
    lazy var locationManager:CLLocationManager? = {
        let manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    lazy var refresher:UIRefreshControl = {
        let refresh = UIRefreshControl()
            refresh.tintColor = .red
            refresh.addTarget(self, action: #selector(onRefreshPage), for: .valueChanged)
        return refresh
    }()
    
    let pageNotification:PageNotifications = {
        let notification = PageNotifications()
        return notification
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        locationManager?.requestWhenInUseAuthorization()

        collectionView?.addSubview(refresher)
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: CELL_FEED)
        collectionView?.register(LiveEvents.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_ID)
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView?.backgroundColor = UIColor.rgb(231, green: 236, blue: 240)
        
        let filterDateButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(onDatePicker(sender:)))
        navigationItem.rightBarButtonItem = filterDateButton
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let olddate = formatter.date(from: "2017-01-01 7:00:00 +0000") //This Will Be Date of launch
        
        eventTypeFetch(date: olddate!, index: 0, typeIndex: 0)
    }
    
    internal func onDatePicker(sender: UIBarButtonItem) {
        
        let calendarPicker = EPCalendarPicker(startYear: 2015, endYear: 2017, multiSelection: true, selectedDates: nil)
            calendarPicker.calendarDelegate = self
            calendarPicker.multiSelectEnabled = false
        let navigationController = UINavigationController(rootViewController: calendarPicker)
            navigationController.navigationBar.isTranslucent = false
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date: Date) {
        
        eventTypeFetch(date: date, index: 0, typeIndex: 0)
        
        self.collectionView?.reloadData()
    }
    
    internal func eventTypeFetch(date: Date, index: Int, typeIndex:Int) {
        
        var indexs:Int = Int()
        var typeIndexs:Int = Int()
        
        if typeIndex != type.count {
            
            Events.fetchEventsFromFacebook(date: date, refresher:refresher, type: type[typeIndex]) { (allEvents) in
                
                if !allEvents.isEmpty {
                    
                    self.eventsDictionary?[index] = allEvents
                    indexs = index + 1
                    typeIndexs = typeIndex + 1
                    self.eventTypeFetch(date: date, index:indexs, typeIndex: typeIndexs)
                    
                } else{
                    
                    self.type.remove(at: typeIndex)
                    typeIndexs = typeIndex + 1
                    self.eventTypeFetch(date: date, index: index, typeIndex: typeIndexs)
                }
                
                let live = allEvents.filter({$0.isLive == 3})
                
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
