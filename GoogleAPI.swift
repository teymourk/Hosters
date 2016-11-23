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

//PHOTO REFRENCE
//https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=&key=AIzaSyC4StcqHSO6EuYx56D_mCoUJBCwvHSo8Xo


class GoogleAPI {
    
    let apiKey = "AIzaSyC4StcqHSO6EuYx56D_mCoUJBCwvHSo8Xo"
    var photoCache = [String:UIImage]()
    var placesTask: URLSessionDataTask?
    var session: URLSession {
        return URLSession.shared
    }
    
    var placesArray = [GooglePlace]()
    
    func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, name:String,
                                   completion: @escaping (([GooglePlace]) -> Void)) -> ()
    {
        var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(apiKey)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true"
        urlString += "&name=\(name)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                
//        if let task = placesTask where task.taskIdentifier > 0 && task.state == .Running {
//            task.cancel()
//        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        placesTask = session.dataTask(with: NSURL(string: urlString)! as URL) {data, response, error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var placesArray = [GooglePlace]()
            if let aData = data {
                let json = JSON(data:aData, options:JSONSerialization.ReadingOptions.mutableContainers, error:nil)
                if let results = json["results"].arrayObject as? [[String : AnyObject]] {
                    
                    for rawPlace in results {
                        
                        let place = GooglePlace(dictionary: rawPlace as Dictionary<String, AnyObject>)
                        placesArray.append(place)
                        
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(placesArray)
            }
        }
        
        self.placesTask?.resume()
    }
}
