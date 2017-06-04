//
//  RegisterVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/29/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

protocol RegisterCellDelegate: class {
    
    func onFacebookLogin(sender: UIButton)
}

class RegisterCell: BaseCell, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let logo:UIImageView = {
        let img = UIImageView()
            img.image = UIImage(named: "TylooLogo")
            img.contentMode = .scaleAspectFill
            img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var WelcomeLabel:UILabel = {
        let label = UILabel()
            label.text = "Welcome To Tyloo"
            label.font = UIFont(name: "Prompt", size: 27)
            label.textAlignment = .center
            label.textColor = darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
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
    
    var delegate:RegisterCellDelegate?

    var pageNotification:PageNotifications = {
        let pn = PageNotifications()
        return pn
    }()
    
    func onFaceBookSignUp(_ sender: UIButton) {
        
        if delegate != nil {
            delegate?.onFacebookLogin(sender: sender)
        }
    }
    
    var registerBtnXAnchor:NSLayoutConstraint?
    var registeBtnTopAnchar:NSLayoutConstraint?
    
    override func setupView() {
        
        backgroundColor = .white
        
        addSubview(WelcomeLabel)
        addSubview(logo)
        addSubview(facebookBtn)
        
        addConstrainstsWithFormat("H:|-10-[v0]-10-|", views: facebookBtn)
        addConstrainstsWithFormat("V:[v0(40)]-100-|", views: facebookBtn)
        
    }
}
