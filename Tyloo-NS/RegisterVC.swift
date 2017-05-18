//
//  RegisterVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/29/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import FBSDKLoginKit

class RegisterVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var backBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "back"), for: UIControlState())
        btn.setTitleColor(goldColor, for: UIControlState())
        btn.addTarget(self, action: #selector(onBackBtn(_ :)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
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
    
    
    lazy var facebookBtn:UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up With Facebook", for: UIControlState())
        button.addTarget(self, action: #selector(onFaceBookSignUp(_ :)), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "NotoSans", size: 20)
        button.setTitleColor(.white, for: UIControlState())
        button.setBackgroundImage(UIImage(named: "fb"), for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
    }
    
    func onBackBtn(_ sender:UIButton) {
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    var pageNotification:PageNotifications = {
        let pn = PageNotifications()
        return pn
    }()
    
    func onFaceBookSignUp(_ sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email", "user_events"], from: self) { (result, error) in
            
            if error != nil {
                
                return
                
            } else if result?.isCancelled == true {
                print("Process FOR FACEBOOK was cancelled")
                
            } else {
                print("LOGGED IN TO FACEBOOK SUCCESSFULLY")
                let completeFacebookRegister = CompleteFacebookRegister()
                let navController = UINavigationController(rootViewController: completeFacebookRegister)
                self.navigationController?.present(navController, animated: true, completion: nil)
                
            }
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    var registerBtnXAnchor:NSLayoutConstraint?
    var registeBtnTopAnchar:NSLayoutConstraint?
    
    func setupView() {
        
        view.addSubview(backBtn)
        view.addSubview(WelcomeLabel)
        view.addSubview(logo)
        view.addSubview(facebookBtn)
        
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
        
        //FacebookBtn
        view.addConstrainstsWithFormat("H:|[v0]|", views: facebookBtn)
        view.addConstrainstsWithFormat("V:[v0(40)]-10-|", views: facebookBtn)
    }
}
