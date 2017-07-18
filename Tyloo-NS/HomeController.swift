//
//  ViewController.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/11/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupView()
        view.backgroundColor = .whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            
            let tabarController = CostumeTabBar()
            self.navigationController?.pushViewController(tabarController, animated: true)
            self.navigationController?.navigationBar.hidden = true
            
        } else {
            
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    lazy var register:UIButton = {
        let button = UIButton()
            button.setTitle("Register", forState: .Normal)
            button.backgroundColor = .grayColor()
            button.addTarget(self, action: #selector(self.onRegisterBtn(_:)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var login:UIButton = {
        let button = UIButton()
            button.setTitle("LogIn", forState: .Normal)
            button.setTitleColor(.blueColor(), forState: .Normal)
            button.addTarget(self, action: #selector(self.onLoginBtn(_:)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    func setupView() {
        
        self.title = "Welcome"
        view.backgroundColor = .grayColor()
        view.addSubview(register)
        view.addSubview(login)
        
        //Register Button Cosntraints
        self.view.addConstrainstsWithFormat("H:|-20-[v0]-20-|", views: register)
        self.view.addConstrainstsWithFormat("V:[v0(40)]-80-|", views: register)

        //LogIn Button Constrains
        self.view.addConstrainstsWithFormat("H:[v0]-40-|", views: login)
        self.view.addConstrainstsWithFormat("V:[v0]-40-|", views: login)
    }
    
    //Mark - OnButtons
    
    func onRegisterBtn(sender:UIButton) {
        
        let regsiterView = RegisterVC()
        self.navigationController?.pushViewController(regsiterView, animated: true)
        self.navigationController?.navigationBar.hidden = true
    }
    
    func onLoginBtn(sender:UIButton) {
        
        let loginView = LoginVC()
        self.navigationController?.pushViewController(loginView, animated: true)
        self.navigationController?.navigationBar.hidden = true
    }
}