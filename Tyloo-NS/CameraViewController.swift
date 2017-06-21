//
//  CameraViewController.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/20/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//
import UIKit
import Firebase
import MBProgressHUD
import SwiftyCam

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    var liveEventDetails:Events?
    
    lazy var captureButton:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "camera"), for: .normal)
        btn.addTarget(self, action: #selector(onOptions(sender:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var campturedImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var uploadButton:UIButton = {
        let button = UIButton()
            button.addTarget(self, action: #selector(onUpload(sender: )), for: .touchUpInside)
        return button
    }()
    
    lazy var togglerotateButton:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named: "ic_loop"), for: UIControlState())
            button.addTarget(self, action: #selector(onRotateCamera(sender :)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraDelegate = self
        defaultCamera = .front
        doubleTapCameraSwitch = true
        pinchToZoom = true
        tapToFocus = true
        
        allowBackgroundAudio = false
        swipeToZoom = false
        flashEnabled = true
        
        setupCameraLayout()
    }
    
    @objc
    fileprivate func onOptions(sender: UIButton) {
        
        let buttonImage = sender.currentImage
        let cameraButton = UIImage(named: "camera")
        let cancelButton = UIImage(named: "cancel")
        
        if buttonImage == cameraButton {
            
            if isSessionRunning {
                takePhoto()
                sender.setImage(cancelButton, for: .normal)
                return
            }
        } else {
            
            campturedImage.image = nil
            sender.setImage(cameraButton, for: .normal)
        }
    }
    
    @objc
    fileprivate func onUpload(sender: UIButton) {
        

    }
    
    @objc
    fileprivate func onRotateCamera(sender: UIButton) {
        
        
    }
    
    fileprivate func uploadImage(_ capturedImage:UIImage, postKey:String) {
        
        let imageKey = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child(postKey).child("\(imageKey).png")
        let spiningHud = MBProgressHUD.showAdded(to: view, animated: true)
        spiningHud.label.text = "Uploading..."
        
        let timePosted:CFloat = CFloat(Date().timeIntervalSince1970)
        let ref = FirebaseRef.database.REF_PHOTO.child(postKey).childByAutoId()
        var picturesDic = Dictionary<String,AnyObject>()
        
        if let uploadData = UIImagePNGRepresentation(capturedImage) {
            
            let uploadTask = storageRef.put(uploadData, metadata: nil) { (metaData, error) in
                
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                if let imageURL = metaData?.downloadURL()?.absoluteString {
                    
                    picturesDic = ["ImgURL":imageURL as NSString, "poster":FirebaseRef.database.currentUser.key as NSString, "timePosted":timePosted as NSNumber]
                    
                    ref.setValue(picturesDic, withCompletionBlock: {
                        (error, refrence) in
                        
                        if error != nil {
                            
                            spiningHud.hide(animated: true)
                            fatalError("Error Posting Photo")
                        }
                    })
                }
                
                self.dismiss(animated: true, completion: {
                    spiningHud.hide(animated: true)
                })
            }
            
            uploadTask.observe(.progress, handler: {
                snapshot in
                
                if let progressPercentage = snapshot.progress?.fractionCompleted {
                    
                    let percentage = Double(progressPercentage * 100)
                    
                    spiningHud.label.text = "\(percentage)%"
                }
            })
        }
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        
        guard let eventId = liveEventDetails?.event_id else {return}
        
        campturedImage.image = photo
        
        uploadImage(photo, postKey: eventId)
    
    }
    
    private func setupCameraLayout() {
        
        view.addSubview(campturedImage)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: campturedImage)
        view.addConstrainstsWithFormat("V:|[v0]|", views: campturedImage)
        
        view.addSubview(captureButton)
        
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
}
