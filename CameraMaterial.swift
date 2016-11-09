//
//  CameraMaterial.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/10/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MapKit

extension UIButton {
    
    func handleCheckingLocationEnabled(_ success: (Bool)->()) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
                
            case .notDetermined, .restricted, .denied:
                self.setImage(UIImage(named: "marker"), for: UIControlState())
                success(false)
                
            case .authorizedAlways, .authorizedWhenInUse:
                self.setImage(UIImage(named: "pin"), for: UIControlState())
                success(true)
            }
        } else {
            
            print("Location services are not enabled")
            self.setImage(UIImage(named: "marker"), for: UIControlState())
            success(false)
        }
    }
}
