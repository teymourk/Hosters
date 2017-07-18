//
//  AddImageCameraVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/20/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Cloudinary
import Firebase
import MBProgressHUD

class AddImageCameraVC: UIViewController, CLUploaderDelegate {

    var activePostsDetails:Posts?
    var createPostVC:CreatePostVC?
    var croppedImage:UIImage = UIImage()
    
    lazy var _upload_Crop:UIButton = {
        let button = UIButton()
            button.setTitle("Upload", forState: .Normal)
            button.setTitleColor(.whiteColor(), forState: .Normal)
            button.addTarget(self, action: #selector(onNextButton(_ :)), forControlEvents: .TouchUpInside)
        return button
    }()
        
    var _pageTitle:UILabel = {
        let label = UILabel()
            label.text = "Photo"
            label.textColor = .whiteColor()
            label.font = UIFont.boldSystemFontOfSize(17)
        return label
    }()
    
    lazy var _cancel:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named: "ic_close"), forState: .Normal)
            button.addTarget(self, action: #selector(onExitCamera(_ :)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var cameraVC:CameraVC = {
        let cv = CameraVC()
            cv.addImageVC = self
        return cv
    }()
    
    func onNextButton(sender:UIBarButtonItem) {
        
        if cameraVC._capturedImage.image != nil {
            
            if _upload_Crop.currentTitle == "Upload" {
                
                if let postKey = activePostsDetails?.postKey, let capturedImage = cameraVC._capturedImage.image, let description = cameraVC._description.text {
                    
                    uploadImage(capturedImage, postKey: postKey, description: description)
                }
                
            } else {
                
                if let createVC = createPostVC {
                    
                    cropImage(cropView, completion: { (image) in
                        
                        self.dismissViewControllerAnimated(true, completion: {
                            
                            createVC._capturedImage.image = image
                            createVC._postTitle.becomeFirstResponder()
                            createVC.capturedImageTopConstraint?.constant = 0
                            //createVC._capturedImage.alpha = 0
                            createVC._capturedImage.transform = CGAffineTransformMakeScale(0, 0)
                            
                            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: {
                                
                                createVC._capturedImage.transform = CGAffineTransformMakeScale(1, 1)
                                //createVC._capturedImage.alpha = 1
                            
                            }, completion: nil)
                        })
                    })
                }
            }
            
        } else {
            
            print("Image IS NILL")
        }
    }
    
    var cropView:CropView = {
        let cp = CropView()
            cp.hidden = true
        return cp
    }()
    
    func setupCropView() {
        
        if createPostVC != nil {
            
            _upload_Crop.setTitle("Crop", forState: .Normal)
            cameraVC._capturedImage.addSubview(cropView)
            cameraVC._description.removeFromSuperview()
            cameraVC._capturedImage.addConstrainstsWithFormat("H:|[v0]|", views: cropView)
            cameraVC._capturedImage.addConstrainstsWithFormat("V:|[v0]|", views: cropView)
            cameraVC._capturedImage.addConstraint(NSLayoutConstraint(item: cropView, attribute: .Height, relatedBy: .Equal, toItem: cropView, attribute: .Height, multiplier: 0, constant: FEED_CELL_HEIGHT))
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCropView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo"
        view.backgroundColor = darkGray
        
        setupView()
    }
    
    func cropImage(cropFrame:UIView ,completion: (UIImage)-> ()) {
        
        if let cameraImage = cameraVC._capturedImage.image {
        
            let top = CGRectGetMinY(cropFrame.frame)
            
            let requiredImageSize = cameraImage.size
            var displaySize: CGSize = CGSizeZero
            var aspect:CGFloat = CGFloat()
            
            displaySize.width = min(requiredImageSize.width, cameraVC.frame.width)
            displaySize.height = min(requiredImageSize.height, cameraVC.frame.height)
            let heightAsepct: CGFloat = displaySize.height/requiredImageSize.height
            let widthAsepct: CGFloat = displaySize.width/requiredImageSize.width
            aspect = min(heightAsepct, widthAsepct)
            displaySize.height = requiredImageSize.height * aspect
            displaySize.width = requiredImageSize.width * aspect
            
            let imageRect = CGRectMake(0, -top, displaySize.width + 112, displaySize.height)
            
            UIGraphicsBeginImageContextWithOptions(cropFrame.layer.bounds.size, true, 1)
            
            cameraImage.drawInRect(imageRect)
            let result = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext();
        
            dispatch_async(dispatch_get_main_queue(), {
                completion(result)
            })
        }
    }
    
    func uploadImage(capturedImage:UIImage, postKey:String, description:String) {
        
        let spiningHud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        let ref = FirebaseRef.Fb.REF_PHOTO.childByAppendingPath(postKey).childByAutoId()
        var picturesDic = Dictionary<String,AnyObject>()
        
        let recizedImage = scaleImageDown(capturedImage, newSize: CGSizeMake(cameraVC.frame.width, cameraVC.frame.height))
        
        uploadImageToCloud(recizedImage, delegate: self, onCompletion: {
            (status, url) in
            
            if let ImgUrl = url {
                
                let posterKey = currentUser.key
                
                picturesDic = ["ImgURL":ImgUrl, "description":description, "poster":posterKey]
                
            }
            
            ref.setValue(picturesDic)
            
            self.dismissViewControllerAnimated(true, completion: {
                self.cameraVC._capturedImage.image = nil
                self.cameraVC._description.text.isEmpty
            })
            
        }) { (progress) in
            
            spiningHud.labelText = "Uploading"
            spiningHud.dimBackground = true
            spiningHud.detailsLabelText = progress
        }
    }
    
    func onExitCamera(sender:UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupView() {
        
        view.addSubview(_upload_Crop)
        view.addSubview(_cancel)
        view.addSubview(_pageTitle)
        view.addSubview(cameraVC)
        
        //Upload_Crop Constraints
        view.addConstrainstsWithFormat("H:[v0(60)]-14-|", views: _upload_Crop)
        view.addConstrainstsWithFormat("V:|-10-[v0(30)]", views: _upload_Crop)
        
        //Cancel Constraints
        view.addConstrainstsWithFormat("H:|-2-[v0(60)]", views: _cancel)
        view.addConstrainstsWithFormat("V:|-10-[v0(30)]", views: _cancel)
        
        //Page Title Constraints
        view.addConstraint(NSLayoutConstraint(item: _pageTitle, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: _pageTitle, attribute: .CenterY, relatedBy: .Equal, toItem: _upload_Crop, attribute: .CenterY, multiplier: 1, constant: 0))
        
        view.addConstrainstsWithFormat("V:[v0(30)]", views: _pageTitle)
        
        //CameraVC Cosntraints
        view.addConstrainstsWithFormat("H:|[v0]|", views: cameraVC)
        view.addConstrainstsWithFormat("V:[v0]", views: cameraVC)
        
        //Height
        view.addConstraint(NSLayoutConstraint(item: cameraVC, attribute: .Height, relatedBy: .Equal, toItem: cameraVC, attribute: .Height, multiplier: 0, constant: HEIGHE_IMAGE))
        
        //Top
       view.addConstraint(NSLayoutConstraint(item: cameraVC, attribute: .Top, relatedBy: .Equal, toItem: _upload_Crop, attribute: .Bottom, multiplier: 1, constant: 60))
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
