//
//  GoogleTableVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/1/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MapKit

private let CELL_ID = "CELL_ID"

class GoogleLocationsVC: UITableViewController, CLLocationManagerDelegate, UISearchResultsUpdating, UISearchDisplayDelegate, UITextFieldDelegate  {

    var place: [GooglePlace]? {
        
        didSet {
            
            activityIndicator.stopAnimating()
            tableView.reloadData()
        }
    }
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
            indicator.center = self.view.center
            indicator.color = darkGray
            indicator.startAnimating()
        return indicator
    }()
    
    lazy var searchBarController:UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Search For Users"
        search.hidesNavigationBarDuringPresentation = false
        search.dimsBackgroundDuringPresentation = false
        search.searchBar.sizeToFit()
        return search
    }()
        
    let GoogleAPIVC = GoogleAPI()
    let locationManager:CLLocationManager! = CLLocationManager()
    var cordinate = CLLocationCoordinate2D()
    let radius = 500.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tag Location"
        navigationController?.navigationBar.translucent = false
        tableView.registerClass(GoogleLocationsCell.self, forCellReuseIdentifier: CELL_ID)
        tableView.tableHeaderView = searchBarController.searchBar
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        setupView()
        
        guard let userLatitude = locationManager.location?.coordinate.latitude, userLongitude = locationManager.location?.coordinate.longitude else { return }
        
        cordinate = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
        
        doLocationsearching("")
    }
    
    var createPostVC:CreatePostVC?
    
    func pushLocationInfo(places:GooglePlace) {
        
        createPostVC?.locationDetails = places
    }
    
    //Mark: - SearchBarDelegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        guard let searchText = searchBarController.searchBar.text else {return}
        
        activityIndicator.startAnimating()
        doLocationsearching(searchText)
    }
    
    func doLocationsearching(text:String) {
        
        if text.isEmpty {
            
            dispatch_async(dispatch_get_main_queue(),{
                
                self.GoogleAPIVC.fetchPlacesNearCoordinate(self.cordinate, radius: self.radius, name: "", completion: { (places) in
                
                    self.place = places
                })
            })
            
        } else {
            
            self.GoogleAPIVC.fetchPlacesNearCoordinate(self.cordinate, radius: self.radius, name: text, completion: { (places) in
                
                let filteredPlaces = places.filter({$0.name.containsString(text)})
                self.place = filteredPlaces
            })
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return place?.count == 0 ? 1 : place?.count ?? 0

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: CELL_ID)
        
        if place?.count == 0 {
            
            cell.textLabel?.text = searchBarController.searchBar.text
            cell.detailTextLabel?.text = "Press To Make it your location"
            
        } else {
            
            let places = place![indexPath.item]
            
            cell.textLabel?.text = places.name
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(14)
            cell.detailTextLabel?.text = places.address
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if place?.count != 0 {
        
            pushLocationInfo(place![indexPath.item])
            
        } else {
            
            createPostVC?._locationlabel.text = searchBarController.searchBar.text
        }
        
        searchBarController.active = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupView() {
     
        view.addSubview(activityIndicator)
    }
}

class GoogleLocationsCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}