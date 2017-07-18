//
//  Extensions.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/11/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Alamofire
import Haneke
import Cloudinary
import MBProgressHUD

// Mark RGB Helper
extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    class func hex (hexStr : NSString, alpha : CGFloat) -> UIColor {
        
        let realHexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: realHexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string", terminator: "")
            return UIColor.whiteColor()
        }
    }
}
//Internal extension?

// Mark: Constraints Helper
extension UIView {
    
    func addConstrainstsWithFormat(format:String, views:UIView...) {
        var viewDictionary = [String:AnyObject]()
        for(index, view) in views.enumerate() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}

// Mark: ImageFrom Data Helper
extension UIImageView {

    //Download Image usig Heneke
    func getImagesBack(url:String, placeHolder:String, loader:UIActivityIndicatorView) {
        
        let imgUrl = NSURL(string: url)
        
        //Caching With Haneke
        self.hnk_setImageFromURL(imgUrl!, placeholder: UIImage(named: placeHolder), format: Format<UIImage>(name: "image"), failure: {
            (error) in
            
        }) { (img) in
            
            dispatch_async(dispatch_get_main_queue(), {
                loader.stopAnimating()
                self.image = img
            })
        }
    }
}

//Clear Footer For table

extension UITableView {
    
    func clearFooter() {
        
        let view = UIView(frame: CGRectZero)
        self.tableFooterView = view
        self.backgroundView = view
        
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

//Upload To Cloudinary
func uploadImageToCloud(image: UIImage, delegate:CLUploaderDelegate, onCompletion: (status: Bool, url: String?) -> Void, onProgress: (progress:String?) -> Void) {
    
    let cloudinaryURL = "loudinary://319939918633478:POeeSeH5PnEDUeGrVt7zWf_B6dU@dhzbgbaw7"
    let clouder = CLCloudinary(url: cloudinaryURL)
    let forUpload = UIImagePNGRepresentation(image)
    let uploader:CLUploader = CLUploader(clouder, delegate: delegate)
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            uploader.upload(forUpload, options: nil, withCompletion: {
                (dataDic:[NSObject : AnyObject]!, error:String!, code:Int!, nil) in
        
                if error != nil {
                    
                    onCompletion(status: false, url: nil)
                    print("FAILED")
                    
                } else {
                    
                    onCompletion(status: true, url: dataDic["url"] as? String)
                    print("Successfully Uploaded Image")
                }
                
            }) { (bytesWritten:Int, totalBytesWritten:Int, totalBytesExpectedToWrite:Int, context:AnyObject!) in
                
                let progress = "Upload progress: \((totalBytesWritten * 100)/totalBytesExpectedToWrite) %"
                onProgress(progress: progress)
            }
        })
    })
}

func scaleImageDown(image: UIImage, newSize: CGSize) -> UIImage {
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
    
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}


// MARK: Gesture Helpers
func tapGesture(target:AnyObject, actions:String, object:AnyObject, numberOfTaps:Int) {
    
    let tapGesture = UITapGestureRecognizer(target: target, action: Selector(actions))
    tapGesture.numberOfTapsRequired = 1
    object.addGestureRecognizer(tapGesture)        
}
