//
//  HomeController.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/27/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import FirebaseMessaging

class HomeController: UIViewController {
    
    let instructionPages:HomeAudit = {
        
        let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
        let page = HomeAudit(frame: .zero, collectionViewLayout: layout)
            page.translatesAutoresizingMaskIntoConstraints = false
        return page
        
    }()
    
    let seperator:UIView = {
        let view = UIView()
            view.backgroundColor = .lightGray
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupView()
        setupAuditPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            
            let tabarController = CostumeTabBar()
            self.navigationController?.pushViewController(tabarController, animated: true)
            self.navigationController?.navigationBar.isHidden = true
            
        } else {
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    lazy var register:UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: UIControlState())
        button.setBackgroundImage(UIImage(named: "signin"), for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSans", size: 16)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 7
        button.addTarget(self, action: #selector(self.onRegisterBtn(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var login:UIButton = {
        let button = UIButton()
        button.setTitle("LogIn", for: UIControlState())
        button.titleLabel?.font = UIFont(name: "NotoSans", size: 16)
        button.setTitleColor(.lightGray, for: UIControlState())
        button.addTarget(self, action: #selector(self.onLoginBtn(_:)), for: .touchUpInside)
        return button
    }()
    
    func setupAuditPage() {
        
        view.addSubview(instructionPages)
        view.addSubview(seperator)
        
        //Pages Constrains
        instructionPages.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        instructionPages.bottomAnchor.constraint(equalTo: login.topAnchor, constant: -50).isActive = true
        instructionPages.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        instructionPages.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        //Seperatro Constraints
        seperator.topAnchor.constraint(equalTo: instructionPages.bottomAnchor).isActive = true
        seperator.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    func setupView() {
        
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
    
    func onRegisterBtn(_ sender:UIButton) {
        
        let regsiterView = RegisterVC()
        self.navigationController?.pushViewController(regsiterView, animated: true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func onLoginBtn(_ sender:UIButton) {
        
        let loginView = LoginVC()
        self.navigationController?.pushViewController(loginView, animated: true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
