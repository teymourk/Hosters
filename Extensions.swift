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

//Clear Footer For table
extension UITableView {
    
    func clearFooter() {
        
        let view = UIView(frame: CGRect.zero)
        self.tableFooterView = view
        self.backgroundView = view
        
    }
}

extension UINavigationController {
    
    func pushingNavigationControllerHelper(_ viewController:UIViewController) {
        
        self.pushViewController(viewController, animated: true)
        self.navigationBar.isHidden = true
    }
}

extension UIButton {
    
    func handleFinidinTrackersForUser(_ userKey:String) {
        
        FirebaseRef.database.currentUser.child("user/Friends/Tracking").observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let trackingDic = snapshot.value as? [String:AnyObject] {
                
                trackingDic.contains(where: {$0.0 == userKey}) ? self.setTitle("Tracking", for: UIControlState()) : self.setTitle("Track", for: UIControlState())
                
                self.backgroundColor = trackingDic.contains(where: {$0.0 == userKey}) ? orange :  .white
            }
        })
    }
        
    func handleUnTracking(_ sender:UIButton, users:[Users]?) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let userToUntrack = users![(indexPath as NSIndexPath).item]
        
        let trackingRef = FirebaseRef.database.currentUser.child("user/Friends/Tracking").child(userToUntrack.userKey!)
        let userTrackersRef = FirebaseRef.database.REF_USERS.child(userToUntrack.userKey!).child("user/Friends/Trackers").child(FirebaseRef.database.currentUser.key)
        
        DispatchQueue.main.async(execute: {
          
            trackingRef.removeValue()
            userTrackersRef.removeValue()
            sender.setTitle("Track", for: UIControlState())
            sender.backgroundColor = .white
        })
    }
    
    func handleTracking(_ sender:UIButton, users:[Users]?) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let userTotrack = users![(indexPath as NSIndexPath).item]
        
        let trackingRef = FirebaseRef.database.currentUser.child("user/Friends/Tracking")
        let userTrackersRef = FirebaseRef.database.REF_USERS.child(userTotrack.userKey!).child("user/Friends/Trackers")
        
        DispatchQueue.main.async(execute: {
        
            trackingRef.updateChildValues([userTotrack.userKey! : true])
            userTrackersRef.updateChildValues([FirebaseRef.database.currentUser.key : true])
            sender.setTitle("Tracking", for: UIControlState())
            sender.backgroundColor = orange
            
            
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
