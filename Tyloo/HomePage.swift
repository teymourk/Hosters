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

enum Events_Entities_Types: String {
    
    //Entities For Events
    case Events = "Events"
    case Live = "Live"
    case Invited = "Invited"
    case Attending = "Attending"
    case Maybe = "Maybe"
    case NearEvents = "NearEvents"
    
    //Types For API
    case not_replied = "not_replied"
    case attending = "attending"
    case maybe = "maybe"
}

class HomePage: UICollectionViewController, CLLocationManagerDelegate {

    let CELL_FEED = "Cell_FEED"
    let HEADER_ID = "HEADER_ID"
    
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
    
    let navBarSeperator:UIView = {
        let view = UIView()
            view.backgroundColor = orange
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        locationManager?.requestWhenInUseAuthorization()
        
        setupCollectionView()
        setupNavSeperator()
        
        eventTypeFetch(index: 0, typeIndex: 0, entities: entityNames)
    }

    internal func setupNavSeperator() {
        
        view.addSubview(navBarSeperator)
        
        navBarSeperator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        navBarSeperator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBarSeperator.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        let scrollyOffset = scrollView.contentOffset.y
//        let searchHeight = CGFloat(0 + self.navBarSeperator.frame.height)
//    
//        scrollView.contentInset.top = scrollyOffset <= -2 ? searchHeight : heightConst
//        scrollView.scrollIndicatorInsets.top = scrollyOffset <= -2 ? searchHeight : heightConst
    }
    
    internal func setupCollectionView() {
        
        collectionView?.addSubview(refresher)
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: CELL_FEED)
        collectionView?.register(SearchHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_ID)
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
    
    internal func handlePushingToSearchPage() {
        
        let searchController = UITableViewController()
            self.present(searchController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.resignFirstResponder()
    }
    
    func onRefreshPage() {
        
        print("SALAAM")
    }
    
    var entityNames:[Events_Entities_Types] = [.Events, .Invited, .Attending, .Maybe, .Events]
    
    //Recursiviey Adding Existing Events
    internal func eventTypeFetch(index: Int, typeIndex:Int, entities:[Events_Entities_Types]) {
        
        let hasntHappenedPred = NSPredicate(format: "isLive = %d", 1)
        let endedPred = NSPredicate(format: "isLive = %d AND rsvp_status = %@", 2, "attending")
        let livePred = NSPredicate(format: "isLive = %d", 3)
        
        if typeIndex != entityNames.count {
        
            let event = Events.FetchData(predicate: hasntHappenedPred, entity: entityNames[typeIndex].rawValue)
            
            if !event.isEmpty {
                
                self.eventsDictionary?[index] = event
                self.eventTypeFetch(index: index + 1, typeIndex: typeIndex + 1, entities: entityNames)
                
            } else{
                
                self.eventTypeFetch(index: index, typeIndex: typeIndex + 1, entities: entityNames)
            }
            
            let lastIndex = (self.eventsDictionary?.count)! - 1
            let entityNameCount = entityNames.count - 1
            
            if typeIndex == 0 {
                
                let liveEvents = Events.FetchData(predicate: livePred, entity: entityNames[entityNameCount].rawValue)
                
                if !liveEvents.isEmpty {
                    
                    self.eventsDictionary?[typeIndex] = liveEvents
                }
                
            } else if typeIndex == lastIndex {
                
                let endedEvents = Events.FetchData(predicate: endedPred, entity: entityNames[entityNameCount].rawValue)
                
                if !endedEvents.isEmpty{
                    
                    self.eventsDictionary?[typeIndex] = endedEvents
                }
            }
        }
    }
}
