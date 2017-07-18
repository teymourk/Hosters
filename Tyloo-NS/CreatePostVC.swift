//
//  CreatePostVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/13/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MapKit
import Cloudinary
import YBAlertController
import MBProgressHUD

class CreatePostVC: UIViewController, UITextFieldDelegate, CLUploaderDelegate {
    
    var locationDetails:GooglePlace? {
        didSet{
            
            if let location = locationDetails?.name {
                self._locationlabel.text = location
            }
            
            if let coordinate = locationDetails?.coordinate {
                
                self.latitude = coordinate.latitude
                self.longtitude = coordinate.longitude
            }
            
            if let address = locationDetails?.address {
                self.placeAddress = address
            }
        }
    }
    
    var _capturedImage:UIImageView = {
        let image = UIImageView()
            image.backgroundColor = darkGray
            image.contentMode = .ScaleToFill
            image.userInteractionEnabled = true
        return image
    }()
    
    let dimContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.2)
        return view
    }()
    
    lazy var _camera:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named: "camera-2"), forState: .Normal)
            button.addTarget(self, action: #selector(onCameraStart(_ :)), forControlEvents: .TouchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var _postTitle:UITextField = {
        let textField = UITextField()
            textField.placeholder = "Enter Your Title"
            textField.textAlignment = .Center
            textField.delegate = self
            textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    var seperator:UIView = {
        let view = UIView()
        view.backgroundColor = goldColor
        return view
    }()
    
    var _locationlabel:UILabel = {
        let label = UILabel()
            label.textColor = buttonColor
            label.font = UIFont.systemFontOfSize(16)
        return label
    }()
    
    var _privacyLabel:UILabel = {
        let label = UILabel()
            label.textColor = .blueColor()
            label.font = UIFont.systemFontOfSize(16)
        return label
    }()
    
    lazy var _createPost:UIButton = {
        let button = UIButton()
            button.setTitle("Create", forState: .Normal)
            button.backgroundColor = goldColor
            button.setTitleColor(UIColor.rgb(7, green: 197, blue: 238), forState: .Normal)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 4
            button.addTarget(self, action: #selector(onCreatePost(_ :)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    let _characterCount:UILabel = {
        let label = UILabel()
            label.text = "\(40)"
            label.font = UIFont.systemFontOfSize(14)
            label.textColor = .whiteColor()
        return label
    }()
    
    lazy var _tagFriends:UIButton = {
        let button = UIButton()
            button.titleLabel?.font = UIFont.systemFontOfSize(15)
            button.addTarget(self, action: #selector(onTagFriends(_ :)), forControlEvents: .TouchUpInside)
            button.setImage(UIImage(named:"add_group"), forState: .Normal)
        return button
    }()
    
    lazy var _addLocation:UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.addTarget(self, action: #selector(onAddLocation(_ :)), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named:"geo_fence_filled"), forState: .Normal)
        return button
    }()
    
    lazy var _privacy:UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.addTarget(self, action: #selector(onPrivacy(_ :)), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named:"privacy_filled"), forState: .Normal)
        return button
    }()
    
    var postOptionsView:UIView = {
        let view = UIView()
            view.backgroundColor = darkGray
        return view
    }()
    
    var privacy:String? = String()
    var placeAddress:String? = String()
    var latitude:CLLocationDegrees! = CLLocationDegrees()
    var longtitude:CLLocationDegrees! = CLLocationDegrees()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create New"
        view.backgroundColor = UIColor(white: 0.82, alpha: 1)
        
        setupView()
        setupPostOptions()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardNotification), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardNotification), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        _postTitle.becomeFirstResponder()
    }
    
    var bottomViewConstraint:NSLayoutConstraint?
    
    func handleKeyboardNotification(notification: NSNotification) {
    
        if let userInfo = notification.userInfo {
            
            let keyBoardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
            
            let isKeyBoardShowin = notification.name == UIKeyboardWillShowNotification
            
            bottomViewConstraint?.constant = isKeyBoardShowin ? -keyBoardFrame!.height : 0
            
            UIView.animateWithDuration(0, delay: 0, options: .CurveEaseOut, animations: { 
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    func onCameraStart(sender:UIButton) {
        
        cameraStart()
    }
    
    func cameraStart() {
    
        let addImageVC = AddImageCameraVC()
        addImageVC.createPostVC = self
        self.capturedImageTopConstraint?.constant = -240
        navigationController?.presentViewController(addImageVC, animated: true, completion: nil)
    }
    
    func onTagFriends(sender:UIButton) {
        
        let locationVC = TagFriendsVC()
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    func onAddLocation(sender:UIButton) {
                
        let googleVC = GoogleLocationsVC()
        googleVC.createPostVC = self
        let navigationController = UINavigationController(rootViewController: googleVC)
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func onPrivacy(sender:UIButton) {
        
        privacyMenu()
    }
    
    func onCreatePost(sender:UIButton) {
        
        if _capturedImage.image != nil && _postTitle.text != nil && _privacyLabel.text != nil {
            
            let spiningHud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            
            uploadImageToCloud(_capturedImage.image!, delegate: self, onCompletion: { (status, url) in
                
                self.createPost(url!)
                
            }) { (progress) in
                
                spiningHud.labelText = "Creating..."
                spiningHud.dimBackground = true
                spiningHud.detailsLabelText = progress
            }
        }
    }
    
    private func privacyMenu() {
        
        view.endEditing(true)
        
        let alertController = YBAlertController(title: "Choose One", message: "Choose one of the privacy options.", style: .ActionSheet)
        alertController.buttonTextColor = darkGray
        alertController.addButton("Public") {
            
            self._privacyLabel.text = "Public(Everyone)"
            self._privacyLabel.textColor = .greenColor()
            self.privacy = "Public"
            self._postTitle.becomeFirstResponder()
        }
        
        alertController.addButton("Friends Only") {
            
            self._privacyLabel.text = "Friends Only"
            self._privacyLabel.textColor = .redColor()
            self.privacy = "Friends"
            self._postTitle.becomeFirstResponder()
        }
        
        alertController.addButton("Tagged") {
            
            self._privacyLabel.text = "Tagged Only"
            self._privacyLabel.textColor = .yellowColor()
            self.privacy = "Tagged"
            self._postTitle.becomeFirstResponder()
        }
        
        alertController.show()
    }
    
    private func createPost(imgURL:String) {
        
        let postTitle = _postTitle.text
        let location = self._locationlabel.text
        let address = self.placeAddress
        let latitude = self.latitude
        let longtitude = self.longtitude
        let poster = currentUser.key
        let privacy = self.privacy
        
        let postData = ["Description": postTitle!, "Poster":poster, "ImgURL":imgURL, "Address":address!, "Location":location!, "Status":true, "Privacy":privacy!,"Latitude":latitude!, "Longtitude":longtitude!]
        let postRef = FirebaseRef.Fb.REF_POSTS.childByAutoId()
        
        postRef.setValue(postData)
    
        self.navigationController?.popViewControllerAnimated(true)
        
        self._postTitle.text?.isEmpty
        self._capturedImage.image = nil
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let newLength: Int = _postTitle.text == "" ? (_postTitle.text! as NSString).length + 1 - range.length : (_postTitle.text! as NSString).length - range.length
        
        let remainChar:Int = 40 - newLength
        
        _characterCount.text = "\(remainChar)"
        _postTitle.text = textField.text
        
        return (newLength >= 40) ? false : true
        
    }
    
    private func setupPostOptions() {
        
        postOptionsView.addSubview(_camera)
        postOptionsView.addSubview(_addLocation)
        postOptionsView.addSubview(_tagFriends)
        postOptionsView.addSubview(_privacy)
        postOptionsView.addSubview(_createPost)
        postOptionsView.addSubview(_characterCount)
        
        //Post Options Constraints
        postOptionsView.addConstrainstsWithFormat("H:|-15-[v0(20)]-25-[v1(20)]-25-[v2]-25-[v3(20)]", views: _camera,_addLocation,_tagFriends,_privacy)
        postOptionsView.addConstrainstsWithFormat("V:[v0(20)]", views: _camera)
        postOptionsView.addConstrainstsWithFormat("V:[v0(20)]", views: _addLocation)
        postOptionsView.addConstrainstsWithFormat("V:[v0]", views: _tagFriends)
        postOptionsView.addConstrainstsWithFormat("V:[v0(20)]", views: _privacy)
        
        //CenterY
        postOptionsView.addConstraint(NSLayoutConstraint(item: _camera, attribute: .CenterY, relatedBy: .Equal, toItem: postOptionsView, attribute: .CenterY, multiplier: 1, constant: 0))
        
        //CenterY
        postOptionsView.addConstraint(NSLayoutConstraint(item: _addLocation, attribute: .CenterY, relatedBy: .Equal, toItem: postOptionsView, attribute: .CenterY, multiplier: 1, constant: 0))
        
        //CenterY
        postOptionsView.addConstraint(NSLayoutConstraint(item: _tagFriends, attribute: .CenterY, relatedBy: .Equal, toItem: postOptionsView, attribute: .CenterY, multiplier: 1, constant: 0))
        
        //CenterY
        postOptionsView.addConstraint(NSLayoutConstraint(item: _privacy, attribute: .CenterY, relatedBy: .Equal, toItem: postOptionsView, attribute: .CenterY, multiplier: 1, constant: 0))
        
        //CreatePost Constraints
        postOptionsView.addConstrainstsWithFormat("H:[v0(60)]-10-|", views: _createPost)
        postOptionsView.addConstrainstsWithFormat("V:[v0]", views: _createPost)
        
        //CenterY
        postOptionsView.addConstraint(NSLayoutConstraint(item: _createPost, attribute: .CenterY, relatedBy: .Equal, toItem: postOptionsView, attribute: .CenterY, multiplier: 1, constant: 0))
        
        //Character Count Label
        postOptionsView.addConstrainstsWithFormat("H:[v0]", views: _characterCount)
        postOptionsView.addConstrainstsWithFormat("V:|[v0]|", views: _characterCount)
        
        //Right
        postOptionsView.addConstraint(NSLayoutConstraint(item: _characterCount, attribute: .Right, relatedBy: .Equal, toItem: _createPost, attribute: .Left, multiplier: 1, constant: -10))
    }
    
    var capturedImageTopConstraint:NSLayoutConstraint?
    
    func setupView() {
        
        view.addSubview(_capturedImage)
        view.addSubview(_postTitle)
        view.addSubview(seperator)
        view.addSubview(_locationlabel)
        view.addSubview(postOptionsView)
        view.addSubview(_privacyLabel)
        _capturedImage.addSubview(dimContainerView)
        
        //Height
        view.addConstraint(NSLayoutConstraint(item: _capturedImage, attribute: .Height, relatedBy: .Equal, toItem: _capturedImage, attribute: .Height, multiplier: 0, constant: FEED_CELL_HEIGHT))
        
        //Top
        capturedImageTopConstraint = NSLayoutConstraint(item: _capturedImage, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: -FEED_CELL_HEIGHT)
        
        view.addConstraint(capturedImageTopConstraint!)

        //Cover Constraints
        view.addConstrainstsWithFormat("H:|[v0]|", views: _capturedImage)
        view.addConstrainstsWithFormat("V:[v0]", views: _capturedImage)
        
        //Height
        view.addConstraint(NSLayoutConstraint(item: _capturedImage, attribute: .Height, relatedBy: .Equal, toItem: _capturedImage, attribute: .Height, multiplier: 0, constant: FEED_CELL_HEIGHT))
        
        //PostTile Constraints
        view.addConstrainstsWithFormat("H:[v0]", views: _postTitle)
        view.addConstrainstsWithFormat("V:[v0(24)]", views: _postTitle)
        
        //Width
        view.addConstraint(NSLayoutConstraint(item: _postTitle, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0, constant: view.frame.width))
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: _postTitle, attribute: .Top, relatedBy: .Equal, toItem: _capturedImage, attribute: .Bottom, multiplier: 1, constant: 15))
        
        //CenterX
        view.addConstraint(NSLayoutConstraint(item: _postTitle, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //Seperator
        view.addConstrainstsWithFormat("H:|-20-[v0]-20-|", views: seperator)
        view.addConstrainstsWithFormat("V:[v0(0.5)]", views: seperator)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: seperator, attribute: .Top, relatedBy: .Equal, toItem: _postTitle, attribute: .Bottom, multiplier: 1, constant: 15))
        
        //Location Constraints
        view.addConstrainstsWithFormat("H:[v0]", views: _locationlabel)
        view.addConstrainstsWithFormat("V:[v0(24)]", views: _locationlabel)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: _locationlabel, attribute: .Top, relatedBy: .Equal, toItem: seperator, attribute: .Bottom, multiplier: 1, constant: 10))
        
        //CenterX
        view.addConstraint(NSLayoutConstraint(item: _locationlabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //PostOptionview Constraints
        view.addConstrainstsWithFormat("H:|[v0]|", views: postOptionsView)
        view.addConstrainstsWithFormat("V:[v0(48)]", views: postOptionsView)
        
        //Bottom
        bottomViewConstraint = NSLayoutConstraint(item: postOptionsView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
    
        view.addConstraint(bottomViewConstraint!)
        
        //Dimed Conctainer
        _capturedImage.addConstrainstsWithFormat("H:|[v0]|", views: dimContainerView)
        _capturedImage.addConstrainstsWithFormat("V:|[v0]|", views: dimContainerView)
        
        //Privacy Label Cosntraints
        view.addConstrainstsWithFormat("H:|-10-[v0]", views: _privacyLabel)
        view.addConstrainstsWithFormat("V:[v0]", views: _privacyLabel)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: _privacyLabel, attribute: .Bottom, relatedBy: .Equal, toItem: postOptionsView, attribute: .Top, multiplier: 1, constant: -4))
        
    }
}
