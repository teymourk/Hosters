//
//  LoginView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/11/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import FBSDKLoginKit

class LoginVC: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
    }
    
    lazy var backBtn:UIButton = {
        let btn = UIButton()
            btn.setImage(UIImage(named: "back"), for: UIControlState())
            btn.setTitleColor(goldColor, for: UIControlState())
            btn.addTarget(self, action: #selector(onBackBtn(_ :)), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return btn
    }()
    
    
    let logo:UIImageView = {
        let img = UIImageView()
            img.image = UIImage(named: "TylooLogo")
            img.contentMode = .scaleAspectFill
        return img
    }()

    lazy var WelcomeLabel:UILabel = {
        let label = UILabel()
            label.text = "Welcome To Tyloo"
            label.font = UIFont(name: "Prompt", size: 27)
            label.textAlignment = .center
            label.textColor = darkGray
        return label
    }()
    
    lazy var emailTxtFiled:UITextField = {
        let txtField = UITextField()
            txtField.borderStyle = .none
            txtField.placeholder = "Email"
            txtField.textColor = .gray
            txtField.textAlignment = .center
            txtField.delegate = self
        return txtField
        
    }()
    
    lazy var passwordTxtField:UITextField = {
        let txtField = UITextField()
        txtField.borderStyle = .none
        txtField.placeholder = "Password"
        txtField.textColor = .gray
        txtField.textAlignment = .center
        txtField.isSecureTextEntry = true
        txtField.delegate = self
        return txtField
        
    }()
    
    var seperator:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var loginBtn:UIButton = {
        let button = UIButton()
            button.setTitle("Sign in", for: UIControlState())
            button.titleLabel?.font = UIFont(name: "NotoSans", size: 20)
            button.setTitleColor(.white, for: UIControlState())
            button.setBackgroundImage(UIImage(named: "signin"), for: UIControlState())
            button.addTarget(self, action: #selector(self.onLoginFireBase(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var facebookBtn:UIButton = {
        let button = UIButton()
            button.setTitle("Sign in with Facebook", for: UIControlState())
            button.titleLabel?.font = UIFont(name: "NotoSans", size: 20)
            button.setTitleColor(.white, for: UIControlState())
            button.setBackgroundImage(UIImage(named: "fb"), for: UIControlState())
            button.addTarget(self, action: #selector(onFacebookLogin(_ :)), for: .touchUpInside)
        return button
    }()
    
    lazy var forgotPasswordBtn:UIButton = {
        let button = UIButton()
            button.setTitle("Forgot Password?", for: UIControlState())
            button.setTitleColor(.lightGray, for: UIControlState())
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(self.onForgotPassword(_:)), for: .touchUpInside)
        return button
    }()
    
    var seperator2:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func onFacebookLogin(_ sender: UIButton) {
    
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Sigin In..."
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                progressHUD.hide(animated: true)
                print(error)
                return
                
            } else if (result?.isCancelled)! {
                progressHUD.hide(animated: true)
                print("Canceled Facebook Request")
                
            } else {
                
                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
                    
                    if let userId = user?.uid {
                    
                        progressHUD.hide(animated: true)
                        self.handlePushingToHomePage(userId)
                    }
                })
            }
        }
    }
    
    func onBackBtn(_ sender:UIButton) {
        
        _ = navigationController?.popViewController(animated: true)
        emailTxtFiled.text = ""
        passwordTxtField.text = ""
    }
    
    var pageNotification:PageNotifications = {
        let pn = PageNotifications()
        return pn
    }()

    func onLoginFireBase(_ sender:UIButton) {
        
        if let email = emailTxtFiled.text , email != "", let password = passwordTxtField.text , password != "" {
            
            let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
             
                if error != nil {
                    
                    guard let errorDescription = error?.localizedDescription else { return }
                    
                    self.pageNotification.showNotification(errorDescription as NSString)
                    progressHUD.hide(animated: true)
                    
                } else{
                    
                    if let currentUserUID = user?.uid {
                    
                        progressHUD.hide(animated: true)
                        self.handlePushingToHomePage(currentUserUID)
                    }
                }
            })
            
        } else {
            
            //Eror with username password
            print("ERROR WITH USER NAME PASSWORD TEXTFIELD")
        }
    }
    
    func handlePushingToHomePage(_ id:String) {
        
        UserDefaults.standard.setValue(id, forKey: KEY_UID)
        let tabarController = CostumeTabBar()
        self.navigationController?.pushViewController(tabarController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTxtFiled {
            passwordTxtField.becomeFirstResponder()
        }
        
        return true
    }
    
    func onForgotPassword(_ sender:UIButton) {
        
        print("Forgot Password")
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func setupView() {
    
        view.addSubview(backBtn)
        view.addSubview(logo)
        view.addSubview(WelcomeLabel)
        view.addSubview(emailTxtFiled)
        view.addSubview(seperator)
        view.addSubview(passwordTxtField)
        view.addSubview(loginBtn)
        view.addSubview(facebookBtn)
        view.addSubview(seperator2)
        view.addSubview(forgotPasswordBtn)
        
        //BackBtn
        view.addConstrainstsWithFormat("H:|-15-[v0]", views: backBtn)
        view.addConstrainstsWithFormat("V:|-10-[v0]", views: backBtn)
        
        //Logo Contraints
        view.addConstrainstsWithFormat("H:|-130-[v0]-130-|", views: logo)
        view.addConstrainstsWithFormat("V:[v0]", views: logo)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: logo, attribute: .top, relatedBy: .equal, toItem: backBtn, attribute: .bottom, multiplier: 1, constant: 20))
        
        //WelcomeLabel Constraints
        view.addConstrainstsWithFormat("H:[v0]", views: WelcomeLabel)
        view.addConstrainstsWithFormat("V:[v0]", views: WelcomeLabel)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: WelcomeLabel, attribute: .top, relatedBy: .equal, toItem: logo, attribute: .bottom, multiplier: 1, constant: 10))
        
        //CenterX
        view.addConstraint(NSLayoutConstraint(item: WelcomeLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
        //Email Constraints
        view.addConstrainstsWithFormat("H:|-50-[v0]-50-|", views: emailTxtFiled)
        view.addConstrainstsWithFormat("V:[v0]", views: emailTxtFiled)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: emailTxtFiled, attribute: .top, relatedBy: .equal, toItem: WelcomeLabel, attribute: .bottom, multiplier: 1, constant: 40))
        
        //Seperator Constrain
        view.addConstrainstsWithFormat("H:|-60-[v0]-60-|", views: seperator)
        view.addConstrainstsWithFormat("V:[v0(0.5)]", views: seperator)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: seperator, attribute: .top, relatedBy: .equal, toItem: emailTxtFiled, attribute: .bottom, multiplier: 1, constant: 20))
        
        //Pasword Constraints
        view.addConstrainstsWithFormat("H:|-50-[v0]-50-|", views: passwordTxtField)
        view.addConstrainstsWithFormat("V:[v0]", views: passwordTxtField)
        
        //
        view.addConstraint(NSLayoutConstraint(item: passwordTxtField, attribute: .top, relatedBy: .equal, toItem: seperator, attribute: .bottom, multiplier: 1, constant: 20))
        
        //Button Constrains
        view.addConstrainstsWithFormat("H:|-70-[v0]-70-|", views: loginBtn)
        view.addConstrainstsWithFormat("V:[v0]", views: loginBtn)
        view.addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .top, relatedBy: .equal, toItem: passwordTxtField, attribute: .bottom, multiplier: 1, constant: 60))
        
        //Facebook Constrains
        view.addConstrainstsWithFormat("H:|-70-[v0]-70-|", views: facebookBtn)
        view.addConstrainstsWithFormat("V:[v0]", views: facebookBtn)
        view.addConstraint(NSLayoutConstraint(item: facebookBtn, attribute: .top, relatedBy: .equal, toItem: loginBtn, attribute: .bottom, multiplier: 1, constant: 20))
        

        //Forgot Password Constrains
        view.addConstrainstsWithFormat("H:|-120-[v0]-120-|", views: forgotPasswordBtn)
        view.addConstrainstsWithFormat("V:[v0(24)]", views: forgotPasswordBtn)
        view.addConstraint(NSLayoutConstraint(item: forgotPasswordBtn, attribute: .top, relatedBy: .equal, toItem: facebookBtn, attribute: .bottom, multiplier: 1, constant: 20))
        
        
        //Seperator2 Constrains
        view.addConstrainstsWithFormat("H:|-120-[v0]-120-|", views: seperator2)
        view.addConstrainstsWithFormat("V:[v0(0.5)]", views: seperator2)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: seperator2, attribute: .top, relatedBy: .equal, toItem: forgotPasswordBtn, attribute: .bottom, multiplier: 1, constant: 5))
    }
}
