//
//  RegisterVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/29/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

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

    lazy var registerLabel:UILabel = {
        let label = UILabel()
            label.text = "Register"
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
            txtField.textAlignment = .Center
            txtField.attributedPlaceholder = NSMutableAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        return txtField
        
    }()
    
    var passwordTxtField:UITextField = {
        let image = UIImageView(image: UIImage(named: "password1"))
            image.frame = CGRectMake(0, 0, 30, 30)
        let txtField = UITextField()
            txtField.borderStyle = .None
            txtField.attributedPlaceholder = NSMutableAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            txtField.leftView = image
            txtField.leftViewMode = UITextFieldViewMode.Always
            txtField.textColor = .whiteColor()
            txtField.textAlignment = .Center
            txtField.secureTextEntry = true
        return txtField
        
    }()
    
    var seperator:UIView = {
        let view = UIView()
            view.backgroundColor = .lightGrayColor()
        return view
    }()
    
    lazy var registerBtn:UIButton = {
        let button = UIButton()
            button.setTitle("Register", forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(20)
            button.setTitleColor(darkGray, forState: .Normal)
            button.backgroundColor = goldColor
            button.addTarget(self, action: #selector(onRegisterFireBase(_:)), forControlEvents: .TouchUpInside)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 4
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        setupView()
    }
    
    func onBackBtn(sender:UIButton) {
        
    }
    
    func onRegisterFireBase(sender:UIButton) {
        
        handleRegister()
    }
    
    func onRegisterWithFB(sendr:UIButton) {
        
        
    }
    
    var completeRegisterVC:CompleteRegisterVC?
    
    func handleRegister() {
        guard let email = emailTxtFiled.text, password = passwordTxtField.text else { return }
        
        let completeregisterVC = CompleteRegisterVC()
        completeregisterVC.navigationItem.setHidesBackButton(true, animated: false)
        handleRegisterErrors(email, password: password) { (error) -> Void in
            
            if !error {
                
                self.navigationController?.presentViewController(completeregisterVC, animated: false, completion: {
                    
                    self.emailTxtFiled.text = ""
                    self.passwordTxtField.text = ""
                    completeregisterVC.userEmailInfo = email
                    completeregisterVC.userPassword = password
                })
            }
        }
    }
    
    func handleRegisterErrors(email:String, password:String, completion: (Bool) -> Void) {
        
        FirebaseRef.Fb.REF_BASE.createUser(email, password: password) { error, result in
            
            if error != nil {

                completion(true)
                print(error.localizedDescription)
                
            } else {
                
                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                completion(false)
            }
        }
    }
    
    func setupView() {
        
        view.addSubview(wallpaper)
        view.addSubview(blurView)
        view.addSubview(backBtn)
        view.addSubview(registerLabel)
        view.addSubview(emailTxtFiled)
        view.addSubview(seperator)
        view.addSubview(passwordTxtField)
        view.addSubview(registerBtn)
        
        
        //Back Constraints
        view.addConstrainstsWithFormat("H:|-10-[v0(30)]", views: backBtn)
        view.addConstrainstsWithFormat("V:|-20-[v0(30)]", views: backBtn)

        //Register With Facebook Constraint
        view.addConstrainstsWithFormat("H:[v0]", views: registerLabel)
        view.addConstrainstsWithFormat("V:|-100-[v0(45)]", views: registerLabel)
        
        //CenterX
        view.addConstraint(NSLayoutConstraint(item: registerLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))

        //Email Constraints
        view.addConstrainstsWithFormat("H:|-50-[v0]-50-|", views: emailTxtFiled)
        view.addConstrainstsWithFormat("V:[v0(45)]", views: emailTxtFiled)
        view.addConstraint(NSLayoutConstraint(item: emailTxtFiled, attribute: .Top, relatedBy: .Equal, toItem: registerLabel, attribute: .Bottom, multiplier: 1, constant: 80))
        
        //Seperator Constrain
        view.addConstrainstsWithFormat("H:|-60-[v0]-60-|", views: seperator)
        view.addConstrainstsWithFormat("V:[v0(0.5)]", views: seperator)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: seperator, attribute: .Top, relatedBy: .Equal, toItem: emailTxtFiled, attribute: .Bottom, multiplier: 1, constant: 20))
        
        //Pasword Constraints
        view.addConstrainstsWithFormat("H:|-50-[v0]-50-|", views: passwordTxtField)
        view.addConstrainstsWithFormat("V:[v0(45)]", views: passwordTxtField)
        view.addConstraint(NSLayoutConstraint(item: passwordTxtField, attribute: .Top, relatedBy: .Equal, toItem: seperator, attribute: .Bottom, multiplier: 1, constant: 20))
        
        //Register Constrains
        view.addConstrainstsWithFormat("H:|-70-[v0]-70-|", views: registerBtn)
        view.addConstrainstsWithFormat("V:[v0(45)]", views: registerBtn)
        view.addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .Top, relatedBy: .Equal, toItem: passwordTxtField, attribute: .Bottom, multiplier: 1, constant: 60))
        
        //Wallpaper
        view.addConstrainstsWithFormat("H:|[v0]|", views: wallpaper)
        view.addConstrainstsWithFormat("V:|[v0]|", views: wallpaper)
        
        //BlurView Constraints
        view.addConstrainstsWithFormat("H:|[v0]|", views: blurView)
        view.addConstrainstsWithFormat("V:|[v0]|", views: blurView)
    }
}
