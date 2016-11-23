//
//  GooglePlace.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/28/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import SwiftyJSON

class GooglePlace {
    
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    var photoReference: String?
    var photo: UIImage?
    
    init(dictionary:[String : AnyObject])
    {
        
        let json = JSON(dictionary)
        name = json["name"].stringValue
        address = json["vicinity"].stringValue
        
        let lat = json["geometry"]["location"]["lat"].doubleValue as CLLocationDegrees
        let lng = json["geometry"]["location"]["lng"].doubleValue as CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        
        photoReference = json["photos"][0]["photo_reference"].string
    }
}
