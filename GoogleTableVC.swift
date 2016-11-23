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

class GoogleLocationsVC: UITableViewController, CLLocationManagerDelegate, UITextFieldDelegate  {

    var nearPlaces: [GooglePlace]? {
        
        didSet {
            
            activityIndicator.stopAnimating()
            tableView.reloadData()
        }
    }
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            indicator.center = self.view.center
            indicator.color = darkGray
            indicator.startAnimating()
        return indicator
    }()
    
    let GoogleAPIVC = GoogleAPI()
    var cordinate = CLLocationCoordinate2D()
    let radius = 1000.0
    
    lazy var locationManager:CLLocationManager? = {
        let lm = CLLocationManager()
            lm.startUpdatingLocation()
            lm.delegate = self
            lm.desiredAccuracy = kCLLocationAccuracyBest
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tag Location"
        navigationController?.navigationBar.isTranslucent = false
        tableView.register(GoogleLocationsCell.self, forCellReuseIdentifier: CELL_ID)
    
        guard let userLatitude = locationManager?.location?.coordinate.latitude, let userLongitude = locationManager?.location?.coordinate.longitude else { return }
        
        cordinate = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
        
        self.GoogleAPIVC.fetchPlacesNearCoordinate(coordinate: self.cordinate, radius: self.radius, name: "", completion: { (places) in
            
            self.nearPlaces = places
        })
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return nearPlaces?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID) as? GoogleLocationsCell {
         
            if let place = nearPlaces?[indexPath.row] {
                
                cell.textLabel?.text = place.name
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                cell.detailTextLabel?.text = place.address
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    var createPostVC:CreatePostCell?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let place = nearPlaces?[indexPath.item] {
        
            self.createPostVC?.locationCordinates = place.coordinate
            self.createPostVC?._locationlabel.text = place.name
            self.createPostVC?._addLocation.setImage(UIImage(named: "geo_fence_filled-1"), for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

class GoogleLocationsCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
