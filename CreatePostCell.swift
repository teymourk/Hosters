//
//  CreatePostCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 8/31/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import MBProgressHUD
import MapKit
import Firebase

class CreatePostCell: BaseCell, UITextFieldDelegate, CLLocationManagerDelegate {
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
    }
        
    var addOrdPostVC:AddOrPost?
    
    lazy var _postTitle:UITextField = {
        let textField = UITextField()
            textField.placeholder = "Enter Your Title"
            textField.font = UIFont(name: "PROMPT", size: 14)
            textField.textAlignment = .center
            textField.delegate = self
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
        label.font = UIFont(name: "NotoSans", size: 16)
        return label
    }()
    
    var _privacyLabel:UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = UIFont(name: "Prompt", size: 16)
        label.text = "Public"
        return label
    }()
    
    lazy var _createPost:UIButton = {
        let button = UIButton()
        button.setTitle("CREATE", for: UIControlState())
        button.setBackgroundImage(UIImage(named: "create-button"), for: UIControlState())
        button.setTitleColor(.black, for: UIControlState())
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.addTarget(self, action: #selector(onCreatePost(_ :)), for: .touchUpInside)
        return button
    }()
    
    let _characterCount:UILabel = {
        let label = UILabel()
        label.text = "\(40)"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    lazy var _tagFriends:UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setImage(UIImage(named:"conference_call"), for: UIControlState())
        button.addTarget(self, action: #selector(onTagFriends(_ :)), for: .touchUpInside)
        return button
    }()
    
    lazy var _addLocation:UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(onAddLocation(_ :)), for: .touchUpInside)
        return button
    }()
    
    lazy var _privacy:UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(onPrivacy(_ :)), for: .touchUpInside)
        button.setImage(UIImage(named:"privacy"), for: UIControlState())
        return button
    }()
    
    var postOptionsView:UIView = {
        let view = UIView()
        view.backgroundColor = darkGray
        return view
    }()
    
    var placeAddress:String? = String()
    //var latitude:CLLocationDegrees! = CLLocationDegrees()
    //var longtitude:CLLocationDegrees! = CLLocationDegrees()
    var taggedFriends = [String:Bool]()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupPostOptions()
        setupCreateConstrains()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        handleButtonColor()
    }
    
    func handleChangingTagFriendsBtn() {
        
        if taggedFriends.count != 0 {
            
            _tagFriends.setImage(UIImage(named: "conference_G"), for: UIControlState())
            
        } else {
            _tagFriends.setImage(UIImage(named:"conference_call"), for: UIControlState())
        }
    }
    
    func handleGettingTaggedUsersFromFirebase() {
        

    }
    
    func handleButtonColor() {
        
        _addLocation.handleCheckingLocationEnabled { (success) in
            
            if !success {
                
                let locationDisable = UIImage(named: "marker")
                self._addLocation.setImage(locationDisable, for: UIControlState())
                
            } else {
                
                let locationImage = self._locationlabel.text == nil ? UIImage(named: "pin") :  UIImage(named: "geo_fence_filled-1")
                
                self._addLocation.setImage(locationImage, for: UIControlState())
            }
        }
    }
    
    var bottomViewConstraint:NSLayoutConstraint?
    
    func handleKeyboardNotification(_ notification: Notification) {
        
        if let userInfo = (notification as NSNotification).userInfo {
            
            let isKeyBoardShowin = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            if let keyBoardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
                bottomViewConstraint?.constant = isKeyBoardShowin ? -keyBoardFrame.height + 10 : -40
            }
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                
                self.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    func onTagFriends(_ sender:UIButton) {
        
        let tagFriends = TagFriends()
            tagFriends.createPost = self
        
        let navController = UINavigationController(rootViewController: tagFriends)
        navController.navigationBar.isTranslucent = false

        addOrdPostVC?.present(navController, animated: true, completion: nil)
    }
    
    func onAddLocation(_ sender:UIButton) {
        
        _addLocation.handleCheckingLocationEnabled { (success) in
            
            if !success {
                
                print("Locations are disable. please go to settings to enable them")
                
            } else {
                
                self.handlePushingToLocation()
            }
        }
    }
    
    func handlePushingToLocation() {

        _locationlabel.text = "Current Location"
    }

    func onPrivacy(_ sender:UIButton) {

        privacyMenu()
    }

    func onCreatePost(_ sender:UIButton) {
        
        handleCreatingPost()
    }
    
    var notficationView:PageNotifications = {
        let nv = PageNotifications()
        return nv
    }()
    
    lazy var locationManager:CLLocationManager? = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        return lm
    }()
    
    
    fileprivate func handleCreatingPost() {
        
        guard let latitude = locationManager?.location?.coordinate.latitude, let longtitude = locationManager?.location?.coordinate.longitude else { return }
        
        //let latitude =
        //let longtitude = self.longtitude
        let poster = FirebaseRef.database.currentUser.key
        let privacy = _privacyLabel.text
        let timeStamp = Date().timeIntervalSince1970
        
        guard let address = placeAddress else { return }
        
        guard let postTitle = _postTitle.text , postTitle != "", let location = _locationlabel.text , location != "" else {
            
            let errorTitle = _postTitle.text!.isEmpty ? "Your Title is empty" : "Please pick a location to continue"
            
            notficationView.showNotification(errorTitle as NSString)
            return
        }
        
        let postData = ["Description": postTitle, "Poster":poster, "Address":address, "Location":location, "Status":true, "Privacy":privacy!,"Latitude":latitude, "Longtitude":longtitude, "Time":timeStamp, "TimeEnded":timeStamp, "Tagged":taggedFriends] as [String : Any]
        
        let spiningHud = MBProgressHUD.showAdded(to: self, animated: true)
        let postRef = FirebaseRef.database.REF_POSTS.childByAutoId()
        
        spiningHud.label.text = "Creating..."
        
        postRef.setValue(postData)
        
        spiningHud.hide(animated: true)
        self._postTitle.text = ""
        self._locationlabel.text = ""
        self._addLocation.setImage(UIImage(named: "pin"), for: UIControlState())
        self.notficationView.showNotification("Your post was successfully created.")
        
        let index = IndexPath(item: 0, section: 0)
        
        taggedFriends.removeAll()
        peopleTagged.removeFromSuperview()
        addOrdPostVC?.scrollToMenuIndex(0)
        addOrdPostVC?.menuBar.menuCollectionView.selectItem(at: index, animated: true, scrollPosition: UICollectionViewScrollPosition())
        _tagFriends.setImage(UIImage(named: "conference_call"), for: UIControlState())
    }
    
    var pageNotification:PageNotifications = {
        let pn = PageNotifications()
        return pn
    }()
    
    fileprivate func privacyMenu() {

        self.endEditing(true)

        let alertController = UIAlertController(title: "Privacy", message: "Choose Your Post Privacy", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Public (Everyone)", style: .default, handler: { (action) in
            self._privacyLabel.text = "Public"
        }))

        alertController.addAction(UIAlertAction(title: "Private (Tagged Users)", style: .default, handler: { (action) in
            self._privacyLabel.text = "Private"
        }))

        alertController.addAction(UIAlertAction(title: "Friends", style: .default, handler: { (action) in
            self._privacyLabel.text = "Friends"
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        addOrdPostVC?.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength: Int = _postTitle.text == "" ? (_postTitle.text! as NSString).length + 1 - range.length : (_postTitle.text! as NSString).length - range.length
        
        let remainChar:Int = 40 - newLength
        
        _characterCount.text = "\(remainChar)"
        _postTitle.text = textField.text
        
        return (newLength >= 40) ? false : true
        
    }
    
    fileprivate func setupPostOptions() {
        
        postOptionsView.addSubview(_addLocation)
        postOptionsView.addSubview(_tagFriends)
        postOptionsView.addSubview(_privacy)
        postOptionsView.addSubview(_createPost)
        postOptionsView.addSubview(_characterCount)
        
        //Post Options Constraints
        postOptionsView.addConstrainstsWithFormat("H:|-15-[v0(20)]-25-[v1]-25-[v2(20)]", views: _addLocation,_tagFriends,_privacy)
        postOptionsView.addConstrainstsWithFormat("V:[v0(20)]", views: _addLocation)
        postOptionsView.addConstrainstsWithFormat("V:[v0]", views: _tagFriends)
        postOptionsView.addConstrainstsWithFormat("V:[v0(20)]", views: _privacy)
        
        //CenterY
        postOptionsView.addConstraint(NSLayoutConstraint(item: _addLocation, attribute: .centerY, relatedBy: .equal, toItem: postOptionsView, attribute: .centerY, multiplier: 1, constant: 0))
        
        //CenterY
        postOptionsView.addConstraint(NSLayoutConstraint(item: _tagFriends, attribute: .centerY, relatedBy: .equal, toItem: postOptionsView, attribute: .centerY, multiplier: 1, constant: 0))
        
        //CenterY
        postOptionsView.addConstraint(NSLayoutConstraint(item: _privacy, attribute: .centerY, relatedBy: .equal, toItem: postOptionsView, attribute: .centerY, multiplier: 1, constant: 0))
        
        //CreatePost Constraints
        postOptionsView.addConstrainstsWithFormat("H:[v0(80)]-10-|", views: _createPost)
        postOptionsView.addConstrainstsWithFormat("V:[v0]", views: _createPost)
        
        //CenterY
        postOptionsView.addConstraint(NSLayoutConstraint(item: _createPost, attribute: .centerY, relatedBy: .equal, toItem: postOptionsView, attribute: .centerY, multiplier: 1, constant: 0))
        
        //Character Count Label
        postOptionsView.addConstrainstsWithFormat("H:[v0]", views: _characterCount)
        postOptionsView.addConstrainstsWithFormat("V:|[v0]|", views: _characterCount)
        
        //Right
        postOptionsView.addConstraint(NSLayoutConstraint(item: _characterCount, attribute: .right, relatedBy: .equal, toItem: _createPost, attribute: .left, multiplier: 1, constant: -10))
    }
    
    var capturedImageTopConstraint:NSLayoutConstraint?
    
    
    var peopleTagged:peopleWith = {
        let pw = peopleWith()
        return pw
    }()
    
    func setupCreateConstrains() {
        
        addSubview(_postTitle)
        addSubview(seperator)
        addSubview(_locationlabel)
        addSubview(peopleTagged)
        addSubview(postOptionsView)
        addSubview(_privacyLabel)
        
        //PostTile Constraints
        addConstrainstsWithFormat("H:[v0]", views: _postTitle)
        addConstrainstsWithFormat("V:[v0(24)]", views: _postTitle)
        
        //Width
        addConstraint(NSLayoutConstraint(item: _postTitle, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: frame.width))
        
        //Top
        addConstraint(NSLayoutConstraint(item: _postTitle, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 50))
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: _postTitle, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        //Seperator
        addConstrainstsWithFormat("H:|-20-[v0]-20-|", views: seperator)
        addConstrainstsWithFormat("V:[v0(0.5)]", views: seperator)
        
        //Top
        addConstraint(NSLayoutConstraint(item: seperator, attribute: .top, relatedBy: .equal, toItem: _postTitle, attribute: .bottom, multiplier: 1, constant: 15))
        
        //Location Constraints
        addConstrainstsWithFormat("H:[v0]", views: _locationlabel)
        addConstrainstsWithFormat("V:[v0(24)]", views: _locationlabel)
        
        //Top
        addConstraint(NSLayoutConstraint(item: _locationlabel, attribute: .top, relatedBy: .equal, toItem: seperator, attribute: .bottom, multiplier: 1, constant: 10))
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: _locationlabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        //PostOptionview Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: postOptionsView)
        addConstrainstsWithFormat("V:[v0(48)]", views: postOptionsView)
        
        //Bottom
        bottomViewConstraint = NSLayoutConstraint(item: postOptionsView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -40)
        
        addConstraint(bottomViewConstraint!)
        
        addConstrainstsWithFormat("H:|-10-[v0]", views: _privacyLabel)
        addConstrainstsWithFormat("V:[v0]", views: _privacyLabel)
        
        //Top
        addConstraint(NSLayoutConstraint(item: _privacyLabel, attribute: .bottom, relatedBy: .equal, toItem: postOptionsView, attribute: .top, multiplier: 1, constant: -4))
    
    }
    
    func setupPeopleTaggedView() {
    
        addSubview(peopleTagged)
        
        peopleTagged.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.6, animations: {
          
            self.peopleTagged.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        //PeopleTagged
        addConstrainstsWithFormat("H:|[v0]|", views: peopleTagged)
        addConstrainstsWithFormat("V:[v0(85)]", views: peopleTagged)
        
        //Top
        addConstraint(NSLayoutConstraint(item: peopleTagged, attribute: .top, relatedBy: .equal, toItem: _locationlabel, attribute: .bottom, multiplier: 1, constant: 25))
    }
}
