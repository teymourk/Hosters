//
//  CompleterRegisterVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/29/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Cloudinary
import MBProgressHUD

class CompleteRegisterVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, CLUploaderDelegate {
    
    var userEmailInfo:String? {
        didSet {
            
            guard let userEmail = userEmailInfo else { return }
            email = userEmail
        }
    }
    
    var userPassword:String? {
        didSet {
            
            guard let userPass = userPassword else { return }
            password = userPass
        }
    }

    lazy var backBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle(" < ", forState: .Normal)
        btn.setTitleColor(goldColor, forState: .Normal)
        btn.addTarget(self, action: #selector(onBackBtn(_ :)), forControlEvents: .TouchUpInside)
        btn.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        return btn
    }()
    
    let profileImage:UIImageView = {
        let image = UIImageView()
            image.image = UIImage(named: "Profile")
            image.layer.masksToBounds = true
            image.layer.cornerRadius = 50
            image.layer.borderWidth = 1
            image.alpha = 0
            image.layer.borderColor = goldColor.CGColor
            image.contentMode = .ScaleToFill
        return image
    }()
    
    let guideLabel:UILabel = {
        let label = UILabel()
            label.textColor = .lightGrayColor()
            label.textAlignment = .Center
            label.text = "Tap Photo To Set Picture"
            label.font = UIFont.systemFontOfSize(13)
        return label
    }()
        
    lazy var usernameTxtFiled:UITextField = {
        let txtField = UITextField()
        txtField.borderStyle = .None
        txtField.placeholder = "Username"
        txtField.textColor = .blackColor()
        txtField.textAlignment = .Center
        txtField.becomeFirstResponder()
        txtField.delegate = self
        return txtField
        
    }()
    
    var seperator:UIView = {
        let view = UIView()
            view.backgroundColor = darkGray
        return view
    }()

    lazy var displayNameTxtFiled:UITextField = {
        let txtField = UITextField()
        txtField.borderStyle = .None
        txtField.placeholder = "Whats Your Name?"
        txtField.textColor = .blackColor()
        txtField.textAlignment = .Center
        txtField.delegate = self
        return txtField
        
    }()
    
    lazy var bioText:UITextView = {
        let txt = UITextView()
            txt.text = "Bio"
            txt.font = UIFont.systemFontOfSize(15)
            txt.textColor = .lightGrayColor()
            txt.scrollEnabled = false
            txt.backgroundColor = .clearColor()
            txt.delegate = self
        return txt
    }()
    
    lazy var continueBtn:UIButton = {
        let button = UIButton()
            button.setTitle("Continue", forState: .Normal)
            button.addTarget(self, action: #selector(onContinue(_ :)), forControlEvents: .TouchUpInside)
            button.titleLabel?.font = UIFont.systemFontOfSize(17)
            button.backgroundColor = .grayColor()
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var registerVC:RegisterVC = {
        let register = RegisterVC()
            register.completeRegisterVC = self
        return register
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        view.backgroundColor = .whiteColor()
        
        navigationController?.navigationBar.translucent = false
        title = "Register"
    }
    
    
    func onBackBtn(sender:UIBarButtonItem) {
        
        dismissViewControllerAnimated(true) {
            
            FirebaseRef.Fb.REF_BASE.removeUser(self.email, password: self.password, withCompletionBlock: { (error) in
                
                if error == nil {
                    
                    print("Succesfully Removed User")
                    
                } else {
                    
                    print("Error Occured")
                    return
                }
            })
        }
    }
    
    func onContinue(sender:UIButton) {
        
        if sender.backgroundColor == UIColor.darkGrayColor() {
            
            print("CANT BE CREATED")
            
        } else {
            
            uploadImageToData()
        }
    }
    
    var email:String = String()
    var password:String = String()
    
    func handleCompleteRegistration(imageLink:String?) {
        
        guard let imgURL = imageLink, bio = bioText.text, username = usernameTxtFiled.text, name = displayNameTxtFiled.text else { return }

        let userInfoDic = ["username":username, "name":name, "profileImage":imgURL , "bio":bio, "likes": "\(0)"]
        
        handleCreatingUserInFireBase(userInfoDic) { (error) in
            
            if !error {
                
                let tabarController = CostumeTabBar()
                self.navigationController?.pushViewController(tabarController, animated: true)
            }
        }
    }
    
    func handleCreatingUserInFireBase(userDicInfo:[String:String], compeltion: (Bool) -> Void) {
        
        FirebaseRef.Fb.REF_BASE.authUser(email, password: password) { (error, fbData) in
         
            if error != nil {
                
                compeltion(true)
                print(error.localizedDescription)
                return
                
            } else {
                
                compeltion(false)
                FirebaseRef.Fb.createFireBaseUser(fbData.uid, user: userDicInfo)
            }
        }
    }
    
    func uploadImageToData() {
        
        let progressHUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
        guard let image = profileImage.image else { return }
        
        uploadImageToCloud(image, delegate: self, onCompletion: { (status, url) in
            
            guard let imgURL = url else {return}
            
            self.handleCompleteRegistration(imgURL)
            
            }) { (progress) in
                
            progressHUD.detailsLabelText = "Creating Account"
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        continueBtn.backgroundColor = textField.text!.isEmpty ? .darkGrayColor() : goldColor
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        continueBtn.backgroundColor = textField.text!.isEmpty ? .darkGrayColor() : goldColor
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        textView.text = textView.text == "Bio" ? nil : "Bio"
        textView.textColor = textView.text == "Bio" ? .lightGrayColor() : .blackColor()
    }
    
    func animateProfileImage() {
    
        profileImage.transform = CGAffineTransformMakeScale(2.5, 2.5)
    
        UIView.animateWithDuration(1, animations: {
            
            self.profileImage.transform = CGAffineTransformMakeScale(1, 1)
            self.profileImage.alpha = 1
        })
    }
    
    func setupView() {
        
        view.addSubview(backBtn)
        view.addSubview(guideLabel)
        view.addSubview(usernameTxtFiled)
        view.addSubview(seperator)
        view.addSubview(displayNameTxtFiled)
        view.addSubview(profileImage)
        view.addSubview(bioText)
        view.addSubview(continueBtn)
        
        performSelector(#selector(animateProfileImage), withObject: nil, afterDelay: 0.2)
        
        //Back Constraints
        view.addConstrainstsWithFormat("H:|-10-[v0(30)]", views: backBtn)
        view.addConstrainstsWithFormat("V:|-20-[v0(30)]", views: backBtn)
        
        //ProfileImage Constraints
        view.addConstrainstsWithFormat("H:[v0(100)]", views: profileImage)
        view.addConstrainstsWithFormat("V:|-70-[v0(100)]", views: profileImage)
        
        //CenterX
        view.addConstraint(NSLayoutConstraint(item: profileImage, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
        
        
        //GuideLabel Constraints
        view.addConstrainstsWithFormat("H:[v0]", views: guideLabel)
        view.addConstrainstsWithFormat("V:[v0]", views: guideLabel)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: guideLabel, attribute: .Top, relatedBy: .Equal, toItem: profileImage, attribute: .Bottom, multiplier: 1, constant: 4))
        
        //CenterX
        view.addConstraint(NSLayoutConstraint(item: guideLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //Username Constrains
        view.addConstrainstsWithFormat("H:|[v0]|", views: usernameTxtFiled)
        view.addConstrainstsWithFormat("V:[v0]", views: usernameTxtFiled)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: usernameTxtFiled, attribute: .Top, relatedBy: .Equal, toItem: guideLabel, attribute: .Bottom, multiplier: 1, constant: 50))
        
        //Seperator Constraints
        view.addConstrainstsWithFormat("H:|-70-[v0]-70-|", views: seperator)
        view.addConstrainstsWithFormat("V:[v0(0.5)]", views: seperator)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: seperator, attribute: .Top, relatedBy: .Equal, toItem: usernameTxtFiled, attribute: .Bottom, multiplier: 1, constant: 10))
        
        //displayName Constrains
        view.addConstrainstsWithFormat("H:|[v0]|", views: displayNameTxtFiled)
        view.addConstrainstsWithFormat("V:[v0]", views: displayNameTxtFiled)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: displayNameTxtFiled, attribute: .Top, relatedBy: .Equal, toItem: seperator, attribute: .Bottom, multiplier: 1, constant: 15))
        
        //Bio Constraints
        view.addConstrainstsWithFormat("H:|-4-[v0]|", views: bioText)
        view.addConstrainstsWithFormat("V:[v0]", views: bioText)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: bioText, attribute: .Top, relatedBy: .Equal, toItem: displayNameTxtFiled, attribute: .Bottom, multiplier: 1, constant: 25))
        
        //Continue Constraints
        view.addConstrainstsWithFormat("H:|-100-[v0]-100-|", views: continueBtn)
        view.addConstrainstsWithFormat("V:[v0(50)]", views: continueBtn)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: continueBtn, attribute: .Top, relatedBy: .Equal, toItem: bioText, attribute: .Top, multiplier: 1, constant: 100))
    }
}
