//
//  Facebook+NearEvents.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/22/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class Facebook_NearEvents: NSObject {

    static let facebookNearPlaces = Facebook_NearEvents()
    
    typealias locationsCompleteion = (_ homes: [Location]) -> ()
    
    internal func findNearPalces(comepletionHandler: @escaping locationsCompleteion) {
        
        var locations = [Location]()
        
        guard let accessToken = FBSDKAccessToken.current().tokenString else {return}
        let website = "https://graph.facebook.com/v2.9"
        let longtitude = -122.8008315
        let latitude = 45.4488967
        let distance = 1000
        let limit = 25
        
        let filePath = "\(website)/search?type=place&value=1&center=\(latitude),\(longtitude)&distance=\(distance)&limit=\(limit)&fields=location,name&access_token=\(accessToken)"
    
        guard let URL = URL(string: filePath) else {return}
        var request = URLRequest(url: URL)
            request.httpMethod = "GET"
        
        print(filePath)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        URLSession.shared.dataTask(with: request) { (results, response, error) in
            
            if error != nil {
                fatalError("Error Getting Locations")
            }
            
            do {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let dataResults = results, let jsonResults = try JSONSerialization.jsonObject(with: dataResults, options: .mutableContainers) as? NSDictionary, let jsonArray = jsonResults.value(forKey: "data") as? NSArray {
                    
                    for json in jsonArray {
                        
                        if let locationData = json as? NSDictionary {
                            
                            //Get Near Location Place IDs
                            guard let placesID = locationData["id"] as? String else { return }
                            
                            let locationObj = Location(placeID: placesID, locationInfo: locationData, insertInto:context)
                            
                            DispatchQueue.main.async {
                                
                                locations.append(locationObj)
                                comepletionHandler(locations)
                            }
                        }
                    }
                }

            } catch {
                fatalError("Error Parsing Json")
            }
            
        }.resume()
    }
    
    class func getPlacesinfo(placeID:String) {
        
        let path = "/\(placeID)/"
        
        FBSDKGraphRequest(graphPath: path, parameters: ["fields":"location, name"]).start { (connection, results, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            if let jsonResult = results as? NSDictionary {
                
                _ = Location(placeID: placeID, locationInfo: jsonResult, insertInto: context)
                
            }
            
            CoreDataStack.coreData.saveContext()
        }
    }
}

