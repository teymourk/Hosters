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
//Internal extension?

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


//let imageCache = NSCache<AnyObject, AnyObject>()
//
//// Mark: ImageFrom Data Helper
//extension UIImageView {
//    
//    //Download Image usig Heneke
//    func getImagesBack(_ urlString:String, placeHolder:String, loader:UIActivityIndicatorView) {
//        
//        loader.startAnimating()
//        self.image = nil
//        
//        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
//            
//            self.image = cachedImage
//            return
//        }
//        
//        let imgURL = URL(string: urlString)
//        
//        if let imageURL = imgURL {
//            
//            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
//                
//                if error != nil {
//                    print(error)
//                    return
//                }
//                
//                DispatchQueue.main.async(execute: {
//                    
//                    if let downloadedImage = UIImage(data: data!) {
//                        
//                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
//                        self.image = downloadedImage
//                        loader.stopAnimating()
//                    }
//                })
//                
//                }.resume()
//        }
//    }
//}

//Cell Animation
extension UICollectionViewCell {
    
    func handleCellAnimation() {
        
        transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        alpha = 0.5
        
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.alpha = 1
        })
    }
    
    func handleFeedCellAnimation() {
        
        alpha = 0.2
        
        UIView.animate(withDuration: 0.7, animations: {
            self.alpha = 1
        })
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

extension UIImageView {
    
    func setRating(rating:Double) {
        
        switch rating {
            
        case 0:
            self.image = UIImage(named: "0")
        case 1:
            self.image = UIImage(named: "1")
        case 1.1...1.9:
            self.image = UIImage(named: "15")
        case 2:
            self.image = UIImage(named: "2")
        case 2.1...2.9:
            self.image = UIImage(named: "25")
        case 3:
            self.image = UIImage(named: "3")
        case 3.1...3.9:
            self.image = UIImage(named: "35")
        case 4:
            self.image = UIImage(named: "4")
        case 4.1...4.9:
            self.image = UIImage(named: "45")
        case 5:
            self.image = UIImage(named: "5")
        default: break
            
        }
    }
}

//Clear Footer For table
extension UITableView {
    
    func clearFooter() {
        
        let view = UIView(frame: CGRect.zero)
        self.tableFooterView = view
    }
}

extension UIButton {
    
    func handleFinidinTrackersForUser(_ userKey:String) {
        
        FirebaseRef.database.currentUser.child("user/Friends/Tracking").observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let trackingDic = snapshot.value as? [String:AnyObject] {
                
                trackingDic.contains(where: {$0.0 == userKey}) ? self.setTitle("Following", for: UIControlState()) : self.setTitle("Follow", for: UIControlState())
                
                self.backgroundColor = trackingDic.contains(where: {$0.0 == userKey}) ? orange :  .white
            }
        })
    }
}

//extension UITabBar {
//    
//    override public func sizeThatFits(size: CGSize) -> CGSize {
//        super.sizeThatFits(size)
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 35
//        return sizeThatFits
//    }
//}


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

//Temp 
func cameraPicker(_ view:AnyObject, cameraPicker:UIImagePickerController) {
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
        
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        
        view.present(cameraPicker, animated: true, completion: nil)
    }
}

func photoLibrary(_ view:AnyObject, photoPicker:UIImagePickerController) {
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        
        photoPicker.sourceType = .photoLibrary
        photoPicker.allowsEditing = false
        
        view.present(photoPicker, animated: true, completion: nil)
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
            let nextdate = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)!
            
            let timeLeft = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: now, to: nextdate)
            
            if let _ = timeLeft.month, let daysLeft = timeLeft.day, let hoursLeft = timeLeft.hour, let minutesLeft = timeLeft.minute, let secondsLeft = timeLeft.second {
                
                return "\(daysLeft)d:\(hoursLeft)h:\(minutesLeft)m:\(secondsLeft):s"
            }
        }
        
        return ""
    }
}
