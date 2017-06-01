//
//  Extensions.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/11/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MBProgressHUD
import Firebase
import Haneke

// Mark RGB Helper
extension UIColor {
    
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        
    }
}


// Mark: Constraints Helper
extension UIView {
    
    func addConstrainstsWithFormat(_ format:String, views:UIView...) {
        var viewDictionary = [String:AnyObject]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}


// Mark: ImageFrom Data Helper
extension UIImageView {
    
    //Download Image usig Heneke
    func getImagesBack(url:String, placeHolder:String) {
        
        let imgUrl = NSURL(string: url)
        
        //Caching With Haneke
        self.hnk_setImageFromURL(imgUrl! as URL, placeholder: UIImage(named: placeHolder), format: Format<UIImage>(name: "image"), failure: {
            (error) in
            
        }) { (img) in
            
            DispatchQueue.main.async(execute: {
                
                self.image = img
            })
        }
    }
}

//Cell Animation
extension UICollectionViewCell {
    
    func handleCellAnimation() {
        
        transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        alpha = 0.5
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
            
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.alpha = 1
            
        }, completion: nil)
    }
}

extension UINavigationController {
    
    func removeBackButtonText() {
        
        if let BackButtonText = self.navigationBar.topItem {
            
            BackButtonText.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}

extension UIView {
    
    func setShadow() {
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 3.0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowColor = UIColor.rgb(157, green: 157, blue: 157).cgColor
    }
}

func scaleImageDown(_ image: UIImage, newSize: CGSize) -> UIImage {
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return newImage
}

// MARK: Gesture Helpers
func tapGesture(_ target:AnyObject, actions:String, object:AnyObject, numberOfTaps:Int) {
    
    let tapGesture = UITapGestureRecognizer(target: target, action: Selector(actions))
    tapGesture.numberOfTapsRequired = 1
    object.addGestureRecognizer(tapGesture)
}

func swipeGesture(_ target:AnyObject, actions:String, object:AnyObject, direction:UISwipeGestureRecognizerDirection) {
    
    let swipeGesture = UISwipeGestureRecognizer(target: target, action: Selector(actions))
    swipeGesture.direction = direction
    object.addGestureRecognizer(swipeGesture)
}


// MARK: Time Helper
extension Date {
    
    func Time() -> String {
        let secondsInOneDay = CGFloat(60 * 60 * 24)
        let secondsInOneHour = CGFloat(60 * 60)
        
        let seconds = CGFloat(Date().timeIntervalSince(self))
        let days = seconds / secondsInOneDay
        let hours = (seconds.truncatingRemainder(dividingBy: secondsInOneDay)) / secondsInOneHour
        let minutes = (seconds.truncatingRemainder(dividingBy: secondsInOneHour)) / 60
        
        var string = "-"
        
        if (days > 1) {
            string = "\(Int(days))d"
        } else if (hours > 1) {
            string = "\(Int(hours))h"
        } else if (minutes > 1) {
            string = "\(Int(minutes))m"
        } else if (seconds > 1) {
            string = "\(Int(seconds))s"
        }
        
        return string
    }
}

extension Date {
    
    func produceDate() -> String {
        
        var month = String()
        var am_pm = String()
        var formatterHour = Int()
        
        let calender = NSCalendar.current
        var dateSet = Set<Calendar.Component>()
            dateSet.insert(.month)
            dateSet.insert(.day)
            dateSet.insert(.year)
            dateSet.insert(.hour)
        
        let date = calender.dateComponents(dateSet, from: self)
        
        if let _month = date.month, let day = date.day, let year = date.year, let hour = date.hour {
            
            if hour > 12 {
                
                formatterHour = hour - 12
                am_pm = "PM"
                
            } else {
             
                am_pm = "AM"
                formatterHour = hour
            }
            
            switch _month {
            case 1:
                month = "January"
                break
            case 2:
                month = "February"
                break
            case 3:
                month = "March"
                break
            case 4:
                month = "April"
                break
            case 5:
                month = "May"
                break
            case 6:
                month = "June"
                break
            case 7:
                month = "July"
                break
            case 8:
                month = "August"
                break
            case 9:
                month = "September"
                break
            case 10:
                month = "October"
                break
            case 11:
                month = "November"
                break
            case 12:
                month = "December"
                break
            default: break
                
            }
            
            return "\(month) \(day), \(year) at \(formatterHour) \(am_pm) 🗓"
        }
        
        return ""
    }
    
    func countDown() -> String {
        
        let calender = NSCalendar.current
        var dateSet = Set<Calendar.Component>()
        dateSet.insert(.month)
        dateSet.insert(.day)
        dateSet.insert(.year)
        dateSet.insert(.hour)
        
        let date = calender.dateComponents(dateSet, from: self)
        
        if let _month = date.month, let _day = date.day, let _year = date.year, let _hour = date.hour {
        
            let now = Date()
            let calendar = Calendar.current
            let components = DateComponents(calendar: calendar, year:_year, month: _month, day:_day, hour: _hour)
            
            if let nextdate = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime) {
                
                let timeLeft = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: now, to: nextdate)
                
                if let _ = timeLeft.month, let daysLeft = timeLeft.day, let hoursLeft = timeLeft.hour, let minutesLeft = timeLeft.minute, let secondsLeft = timeLeft.second {
                    
                    return "\(daysLeft)d:\(hoursLeft)h:\(minutesLeft)m:\(secondsLeft):s"
                }
            }
        }
        
        return ""
    }
    
    func AddEndTime() -> Date {
    
        let minute:TimeInterval = 60.0
        let hour:TimeInterval = 60.0 * minute * 12
        
        let date = Date(timeInterval: hour, since: self)
    
        return date
    }
}
