//
//  AddImageCameraVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/20/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import CameraManager

class AddImages: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var activePostsDetails:Posts?
    var photoLibrayImage = UIImage()
        
    var _capturedImage:UIImageView = {
    let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.isUserInteractionEnabled = true
            image.isHidden = true
            image.clipsToBounds = true
        return image
    }()
    
    lazy var _rotate:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named: "ic_loop"), for: UIControlState())
            button.addTarget(self, action: #selector(onRotateCamera(_ :)), for: .touchUpInside)
        return button
    }()
    
    let seperatorView:UIView = {
        let view = UIView()
            view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var _flashToggole:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named:"flash_off_filled"), for: UIControlState())
            button.addTarget(self, action: #selector(onFlash(_ :)), for: .touchUpInside)
        return button
    }()
    
    lazy var captureImage:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named:"camera-2"), for: UIControlState())
            button.addTarget(self, action: #selector(onCaptureImage(_ :)), for: .touchUpInside)
            button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    lazy var _description:UITextField = {
        let txt = UITextField()
            txt.textColor = .white
            txt.backgroundColor = .clear
            txt.placeholder = "Tap here to add caption"
            txt.font = UIFont(name: "NotoSans", size: 14)
            txt.borderStyle = .none
            txt.attributedPlaceholder = NSAttributedString(string: "Tap here to add caption", attributes: [NSForegroundColorAttributeName: UIColor.white])
            txt.isHidden = true
        return txt
    }()
    
    var cameraVC:UIView = {
        let cv = UIView()
            cv.contentMode = .scaleAspectFill
        return cv
    }()
    
    lazy var cameraManager:CameraManager = {
        let cm = CameraManager()
            cm.writeFilesToPhoneLibrary = false
        return cm
    }()
    
    var pageNotification:PageNotifications = {
        let pn = PageNotifications()
        return pn
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    func onUpload(_ sender:UIBarButtonItem) {
        
        guard let image = _capturedImage.image, let key = activePostsDetails?.postKey, let description = self._description.text else {
            
            pageNotification.showNotification("Error!. You must take a picture before continuing!")
            return
            
        }
        
        self.uploadImage(image, postKey: key, description: description)
    }
    

    func onCaptureImage(_ sender:UIButton) {

        if captureImage.currentImage == UIImage(named: "camera-2") {
            
            switch (cameraManager.cameraOutputMode) {
            case .stillImage:
                cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
                    if let errorOccured = error {
                        self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
                    }
                    else {
                        if let capturedImage = image {
                            self._capturedImage.image = capturedImage
                            self._rotate.isHidden = true
                            self._flashToggole.isHidden = true
                            self.seperatorView.isHidden = true
                            self._description.isHidden = false
                            self._capturedImage.isHidden = false
                            self.captureImage.setImage(UIImage(named: "Cancel"), for: .normal)
                        }
                    }
                })
                
            default:break
                
            }
            
        } else if captureImage.currentImage == UIImage(named: "Cancel") {
            self._rotate.isHidden = false
            self._flashToggole.isHidden = false
            self.seperatorView.isHidden = false
            self._description.isHidden = true
            self._capturedImage.isHidden = true
            self.captureImage.setImage(UIImage(named: "camera-2"), for: .normal)
        }
    }
    
    func onExitCamera(_ sender: UIButton) {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func onFlash(_ sender:UIButton) {
        
        switch (cameraManager.changeFlashMode()) {
        case .off:
            sender.setImage(UIImage(named: "flash_off_filled"), for: .normal)
        case .auto:
            sender.setImage(UIImage(named: "flash_auto_filled"), for: .normal)
        case .on:
            sender.setImage(UIImage(named: "flash_on_filled"), for: .normal)
        }
    }
    
    func onRotateCamera(_ sender:UIButton) {

        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
        switch (cameraManager.cameraDevice) {
        case .front:
            sender.setTitle("Front", for: .normal)
        case .back:
            sender.setTitle("Back", for: .normal)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let profileImages = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImageDown(profileImages, newSize: CGSize(width: 100, height: 100))
        
        _capturedImage.isHidden = false
        _capturedImage.image = scaledImage
        
        picker.dismiss(animated: true, completion: nil)
    }

    func uploadImage(_ capturedImage:UIImage, postKey:String, description:String) {
        
        let imageKey = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child(postKey).child("\(imageKey).png")
        let spiningHud = MBProgressHUD.showAdded(to: view, animated: true)
            spiningHud.label.text = "Uploading..."
        
        let timePosted:CFloat = CFloat(Date().timeIntervalSince1970)
        let ref = FirebaseRef.database.REF_PHOTO.child(postKey).childByAutoId()
        var picturesDic = Dictionary<String,AnyObject>()
        
        let resizedImage = scaleImageDown(capturedImage, newSize: CGSize(width: cameraVC.frame.width, height: cameraVC.frame.height))
        
        if let uploadData = UIImagePNGRepresentation(resizedImage) {
            
            let uploadTask = storageRef.put(uploadData, metadata: nil) { (metaData, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let imageURL = metaData?.downloadURL()?.absoluteString {
                    
                    picturesDic = ["ImgURL":imageURL as NSString, "description":description as NSString, "poster":FirebaseRef.database.currentUser.key as NSString, "timePosted":timePosted as NSNumber]
                }
                
                ref.setValue(picturesDic)
                
                self.dismiss(animated: true, completion: { 
                    
                    spiningHud.hide(animated: true)
                })
            }
            
            uploadTask.observe(.progress, handler: {
                snapshot in
                
                if let progressPercentage = snapshot.progress?.fractionCompleted {
                    
                    let percentage = Int(progressPercentage * 100)
                    
                    spiningHud.label.text = "\(percentage)%"
                }
            })
        }
    }
    
    func setupNavBar() {
        
        let upload = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(onUpload(_ :)))
        self.navigationItem.rightBarButtonItem = upload
        
        let cancel = UIBarButtonItem(image: UIImage(named: "ic_close"), style: .plain, target: self, action: #selector(onExitCamera(_ :)))
        self.navigationItem.leftBarButtonItem = cancel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo"
        view.backgroundColor = darkGray
    
        setupView()
        setupNavBar()
        cameraManager.addPreviewLayerToView(self.cameraVC, newCameraOutputMode: .stillImage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraManager.resumeCaptureSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraManager.stopCaptureSession()
    
    }
    
    func setupView() {
        
        view.addSubview(cameraVC)
        view.addSubview(_flashToggole)
        view.addSubview(seperatorView)
        view.addSubview(_rotate)
        view.addSubview(captureImage)
        view.addSubview(_capturedImage)
        view.addSubview(_description)
        
        
        //Flash/Rotate/Seperator Constraints
        view.addConstrainstsWithFormat("H:|-120-[v0(24)]-20-[v1(2)]-20-[v2(24)]-120-|", views: _flashToggole,seperatorView,_rotate)
        view.addConstrainstsWithFormat("V:|-80-[v0(24)]", views: _flashToggole)
        view.addConstrainstsWithFormat("V:[v0(24)]", views: _rotate)
        
        view.addConstrainstsWithFormat("H:[v0]", views: seperatorView)
        view.addConstrainstsWithFormat("V:[v0(30)]", views: seperatorView)
        

        //Rotate CenterY
        view.addConstraint(NSLayoutConstraint(item: _rotate, attribute: .centerY, relatedBy: .equal, toItem: _flashToggole, attribute: .centerY, multiplier: 1, constant: 0))
        
        //Seperator CenterX
        view.addConstraint(NSLayoutConstraint(item: seperatorView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
        //Seperator CenterY
        view.addConstraint(NSLayoutConstraint(item: seperatorView, attribute: .centerY, relatedBy: .equal, toItem: _flashToggole, attribute: .centerY, multiplier: 1, constant: 0))
        
        //CameraVC Cosntraints
        view.addConstrainstsWithFormat("H:|[v0]|", views: cameraVC)
        view.addConstrainstsWithFormat("V:[v0]", views: cameraVC)
        
        //Height
        view.addConstraint(NSLayoutConstraint(item: cameraVC, attribute: .height, relatedBy: .equal, toItem: cameraVC, attribute: .height, multiplier: 0, constant: HEIGHE_IMAGE))

        //Top
        view.addConstraint(NSLayoutConstraint(item: cameraVC, attribute: .top, relatedBy: .equal, toItem: _flashToggole, attribute: .bottom, multiplier: 1, constant: 40))

        //CamptureImage
        view.addConstrainstsWithFormat("H:|[v0]|", views: _capturedImage)
        view.addConstrainstsWithFormat("V:[v0]", views: _capturedImage)
        
        //Height
        view.addConstraint(NSLayoutConstraint(item: _capturedImage, attribute: .height, relatedBy: .equal, toItem: _capturedImage, attribute: .height, multiplier: 0, constant: HEIGHE_IMAGE))
        
        //CenterY
        view.addConstraint(NSLayoutConstraint(item: _capturedImage, attribute: .centerY, relatedBy: .equal, toItem: cameraVC, attribute: .centerY, multiplier: 1, constant: 0))
        
        //CaptuteButton Constraints
        view.addConstrainstsWithFormat("H:[v0(50)]", views: captureImage)
        view.addConstrainstsWithFormat("V:[v0(50)]", views: captureImage)

        //Top
        view.addConstraint(NSLayoutConstraint(item: captureImage, attribute: .top, relatedBy: .equal, toItem: cameraVC, attribute: .bottom, multiplier: 1, constant: 30))
        
        //CenterX
        view.addConstraint(NSLayoutConstraint(item: captureImage, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
        //Description
        view.addConstrainstsWithFormat("H:|-5-[v0]-5-|", views: _description)
        view.addConstrainstsWithFormat("V:[v0]", views: _description)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: _description, attribute: .bottom, relatedBy: .equal, toItem: self.cameraVC, attribute: .top, multiplier: 1, constant: -16))
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
