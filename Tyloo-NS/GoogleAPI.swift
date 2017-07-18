//
//  GoogleAPI.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/28/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import GoogleMaps
import SwiftyJSON

class GoogleAPI {
    
    let apiKey = "AIzaSyC4StcqHSO6EuYx56D_mCoUJBCwvHSo8Xo"
    var photoCache = [String:UIImage]()
    var placesTask: NSURLSessionDataTask?
    var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    
    var placesArray = [GooglePlace]()
    
    func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, name:String,
                                   completion: (([GooglePlace]) -> Void)) -> ()
    {
        var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(apiKey)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true"
        urlString += "&name=\(name)"
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        if let task = placesTask where task.taskIdentifier > 0 && task.state == .Running {
            task.cancel()
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        placesTask = session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            var placesArray = [GooglePlace]()
            if let aData = data {
                let json = JSON(data:aData, options:NSJSONReadingOptions.MutableContainers, error:nil)
                if let results = json["results"].arrayObject as? [[String : AnyObject]] {
                    for rawPlace in results {
                        let place = GooglePlace(dictionary: rawPlace as Dictionary<String, AnyObject>)
                        placesArray.append(place)
                        
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                completion(placesArray)
            }
        }
        
        self.placesTask?.resume()
    }
}
