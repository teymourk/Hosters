//
//  LoginView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/11/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        setupView()

    }
    
    let wallpaper:UIImageView = {
        let image = UIImageView()
            image.contentMode = .ScaleAspectFit
            image.image = UIImage(named: "p5")
        return image
    }()
    
    let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .Dark)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    lazy var backBtn:UIButton = {
        let btn = UIButton()
            btn.setTitle(" < ", forState: .Normal)
            btn.setTitleColor(goldColor, forState: .Normal)
            btn.addTarget(self, action: #selector(onBackBtn(_ :)), forControlEvents: .TouchUpInside)
            btn.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        return btn
    }()
    
//    lazy var loginWithFacebook:UIButton = {
//        let button = UIButton()
//            button.setTitle("Register With Facebook", forState: .Normal)
//            button.backgroundColor = .grayColor()
//            button.addTarget(self, action: #selector(self.onLoginWithFB(_:)), forControlEvents: .TouchUpInside)
//            button.hidden = true
//        return button
//    }()
    
    lazy var loginLabel:UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.textAlignment = .Center
        label.textColor = .whiteColor()
        label.font = UIFont.systemFontOfSize(27)
        return label
    }()
    
    var emailTxtFiled:UITextField = {
        let image = UIImageView(image: UIImage(named: "message_outline"))
            image.frame = CGRectMake(0, 0, 30, 30)
        let txtField = UITextField()
            txtField.borderStyle = .None
            txtField.leftView = image
            txtField.leftViewMode = UITextFieldViewMode.Always
            txtField.textColor = .whiteColor()
            txtField.attributedPlaceholder = NSMutableAttributedString(string: "E-mail address", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
            txtField.textAlignment = .Center
        return txtField
        
    }()
    
    var seperator:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrayColor()
        return view
    }()
    
    var passwordTxtField:UITextField = {
        let image = UIImageView(image: UIImage(named: "password1"))
            image.frame = CGRectMake(0, 0, 30, 30)
        let txtField = UITextField()
            txtField.borderStyle = .None
            txtField.leftView = image
            txtField.leftViewMode = UITextFieldViewMode.Always
            txtField.textColor = .whiteColor()
            txtField.textAlignment = .Center
        txtField.attributedPlaceholder = NSMutableAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
            txtField.secureTextEntry = true
        return txtField
        
    }()
    
    lazy var loginBtn:UIButton = {
        let button = UIButton()
            button.setTitle("Sign in", forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(20)
            button.setTitleColor(.whiteColor(), forState: .Normal)
            button.backgroundColor = goldColor
            button.addTarget(self, action: #selector(self.onLoginFireBase(_:)), forControlEvents: .TouchUpInside)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var forgotPasswordBtn:UIButton = {
        let button = UIButton()
            button.setTitle("Forgot Password?", forState: .Normal)
            button.setTitleColor(.whiteColor(), forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(17)
            button.addTarget(self, action: #selector(self.onForgotPassword(_:)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func onBackBtn(sender:UIButton) {
        
    }
    
    func onLoginWithFB(sender:UIButton) {
        
        print("Facebook Login")
    }
    
    func onLoginFireBase(sender:UIButton) {
        
        if let email = emailTxtFiled.text where email != "", let password = passwordTxtField.text where password != "" {
            
            FirebaseRef.Fb.REF_USERS.authUser(email, password: password, withCompletionBlock: { (error, authData) in
                
                if error != nil {
                 
                    //ERROR TYPE (Switch)
                    
                } else{
                    
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                    //Transition
                    let tabarController = CostumeTabBar()
                    self.navigationController?.pushViewController(tabarController, animated: true)
                }
            })
            
        } else {
            
            //Eror with username password
        }
    }
    
    func onForgotPassword(sender:UIButton) {
        
        print("Forgot Password")
    }
    
    func setupView() {
    
        view.addSubview(wallpaper)
        view.addSubview(blurView)
        view.addSubview(backBtn)
        view.addSubview(loginLabel)
        view.addSubview(emailTxtFiled)
        view.addSubview(seperator)
        view.addSubview(passwordTxtField)
        view.addSubview(loginBtn)
        view.addSubview(forgotPasswordBtn)
        
        //Back Constraints
        view.addConstrainstsWithFormat("H:|-10-[v0(30)]", views: backBtn)
        view.addConstrainstsWithFormat("V:|-20-[v0(30)]", views: backBtn)
        
        
        //LoginWith Facebook Constraints
        view.addConstrainstsWithFormat("H:[v0]", views: loginLabel)
        view.addConstrainstsWithFormat("V:|-100-[v0(45)]", views: loginLabel)
        
        //CenterX
        view.addConstraint(NSLayoutConstraint(item: loginLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //Email Constraints
        view.addConstrainstsWithFormat("H:|-50-[v0]-50-|", views: emailTxtFiled)
        view.addConstrainstsWithFormat("V:[v0(45)]", views: emailTxtFiled)
        view.addConstraint(NSLayoutConstraint(item: emailTxtFiled, attribute: .Top, relatedBy: .Equal, toItem: loginLabel, attribute: .Bottom, multiplier: 1, constant: 80))
        
        //Seperator Constrain
        view.addConstrainstsWithFormat("H:|-60-[v0]-60-|", views: seperator)
        view.addConstrainstsWithFormat("V:[v0(0.5)]", views: seperator)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: seperator, attribute: .Top, relatedBy: .Equal, toItem: emailTxtFiled, attribute: .Bottom, multiplier: 1, constant: 20))
        
        //Pasword Constraints
        view.addConstrainstsWithFormat("H:|-50-[v0]-50-|", views: passwordTxtField)
        view.addConstrainstsWithFormat("V:[v0(45)]", views: passwordTxtField)
        view.addConstraint(NSLayoutConstraint(item: passwordTxtField, attribute: .Top, relatedBy: .Equal, toItem: seperator, attribute: .Bottom, multiplier: 1, constant: 20))
        
        //Button Constrains
        view.addConstrainstsWithFormat("H:|-70-[v0]-70-|", views: loginBtn)
        view.addConstrainstsWithFormat("V:[v0(45)]", views: loginBtn)
        view.addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .Top, relatedBy: .Equal, toItem: passwordTxtField, attribute: .Bottom, multiplier: 1, constant: 60))
        
        //Forgot Password Constrains
        view.addConstrainstsWithFormat("H:|-120-[v0]-120-|", views: forgotPasswordBtn)
        view.addConstrainstsWithFormat("V:[v0(24)]", views: forgotPasswordBtn)
        view.addConstraint(NSLayoutConstraint(item: forgotPasswordBtn, attribute: .Top, relatedBy: .Equal, toItem: loginBtn, attribute: .Bottom, multiplier: 1, constant: 20))
        
        //Wallpaper
        view.addConstrainstsWithFormat("H:|[v0]|", views: wallpaper)
        view.addConstrainstsWithFormat("V:|[v0]|", views: wallpaper)
        
        //BlurView Constraints
        view.addConstrainstsWithFormat("H:|[v0]|", views: blurView)
        view.addConstrainstsWithFormat("V:|[v0]|", views: blurView)
    }
}
