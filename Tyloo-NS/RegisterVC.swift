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

class RegisterCell: BaseCollectionViewCell, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let backgroundCover:UIImageView = {
        let img = UIImageView()
            img.contentMode = .scaleAspectFill
            img.getImagesBack(url: "https://s-media-cache-ak0.pinimg.com/564x/60/f4/23/60f423b13552e142687132f9a220e81f.jpg", placeHolder: "emptyImage")
            img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
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
            label.textColor = orange
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
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 5
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
    
    
    var registeBtnYAnchar:NSLayoutConstraint?
    var logoYAncher:NSLayoutConstraint?
    
    override func setupView() {
        
        backgroundColor = .white
        
        addSubview(backgroundCover)
        addSubview(WelcomeLabel)
        addSubview(logo)
        addSubview(facebookBtn)
        
        backgroundCover.topAnchor.constraint(equalTo: topAnchor, constant: -40).isActive = true
        backgroundCover.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundCover.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        logo.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoYAncher = logo.topAnchor.constraint(equalTo: topAnchor, constant: -140)
        logoYAncher?.isActive = true
        
        WelcomeLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 10).isActive = true
        WelcomeLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        WelcomeLabel.centerXAnchor.constraint(equalTo: logo.centerXAnchor).isActive = true
        
        facebookBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        facebookBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        facebookBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        registeBtnYAnchar = facebookBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        registeBtnYAnchar?.isActive = true
        
        animatePage()

    }
    
    internal func animatePage() {
     
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.layoutIfNeeded()
            
            self.registeBtnYAnchar?.constant = -70
            self.logoYAncher?.constant = 40
            
        }, completion: nil)

    }
}
