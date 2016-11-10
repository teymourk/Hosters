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
    
    lazy var emailTxtFiled:UITextField = {
        let txtField = UITextField()
            txtField.borderStyle = .none
            txtField.placeholder = "Email"
            txtField.textColor = .gray
            txtField.textAlignment = .center
            txtField.delegate = self
            txtField.font = UIFont(name: "NotoSans", size: 13)
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
            txtField.font = UIFont(name: "NotoSans", size: 13)
        return txtField
        
    }()
    
    let profileImage:UIImageView = {
        let image = UIImageView()
            image.image = UIImage(named: "Profile")
            image.layer.masksToBounds = true
            image.layer.cornerRadius = 35
            image.layer.borderWidth = 1
            image.contentMode = .scaleAspectFill
            image.isUserInteractionEnabled = true
        return image
    }()
    
    var seperator:UIView = {
        let view = UIView()
            view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var registerBtn:UIButton = {
        let button = UIButton()
            button.setBackgroundImage(UIImage(named: "signin"), for: UIControlState())
            button.setTitle("Sign Up", for: UIControlState())
            button.titleLabel?.font = UIFont(name: "NotoSans", size: 20)
            button.setTitleColor(.white, for: UIControlState())
            button.addTarget(self, action: #selector(self.onRegisterFireBase(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var displayNameTxtFiled:UITextField = {
        let txtField = UITextField()
            txtField.borderStyle = .none
            txtField.placeholder = "Whats Your Name?"
            txtField.textColor = .black
            txtField.textAlignment = .left
            txtField.font = UIFont(name: "NotoSans", size: 13)
            txtField.delegate = self
        return txtField
        
    }()
    
    lazy var usernameTxtFiled:UITextField = {
        let txtField = UITextField()
            txtField.borderStyle = .none
            txtField.placeholder = "Whats Your Username"
            txtField.textColor = .black
            txtField.textAlignment = .left
            txtField.font = UIFont(name: "NotoSans", size: 13)
            txtField.delegate = self
        return txtField
        
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
        
        tapGesture(self, actions: "onProfileImage:", object: profileImage, numberOfTaps: 1)
    }
    
    func onBackBtn(_ sender:UIButton) {
        
        _ = navigationController?.popToRootViewController(animated: true)
        emailTxtFiled.text = ""
        passwordTxtField.text = ""
    }
    
    func onProfileImage(_ sender: UITapGestureRecognizer) {
        
        handleAlert()
    }
    
    func handleAlert() {
        
        view.endEditing(true)
        
        let alertController = UIAlertController(title: "Choose", message: "Choose one of the following option.", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            
            let camera:UIImagePickerController! = UIImagePickerController()
                camera.delegate = self
            photoLibrary(self, photoPicker: camera)
        }))
        
            
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
    
            let photo:UIImagePickerController! = UIImagePickerController()
                photo.delegate = self
            cameraPicker(self, cameraPicker:photo)
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let profileImages = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImageDown(profileImages, newSize: CGSize(width: 100, height: 100))
        
        profileImage.image = scaledImage
        
        picker.dismiss(animated: true, completion: nil)
    }

    func onRegisterFireBase(_ sender:UIButton) {
        
        handleRegister()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTxtFiled {
            passwordTxtField.becomeFirstResponder()
            
        } else if textField == passwordTxtField {
            usernameTxtFiled.becomeFirstResponder()
            
        } else if textField == usernameTxtFiled {
            displayNameTxtFiled.becomeFirstResponder()
        }
        
        return true
    }
    
    var pageNotification:PageNotifications = {
        let pn = PageNotifications()
        return pn
    }()
    
    func handleRegister() {
        
        guard let email = emailTxtFiled.text , email != "", let password = passwordTxtField.text , password != "" else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            let spiningHud = MBProgressHUD.showAdded(to: self.view, animated: true)
            spiningHud.label.text = "Creating User..."
            
            if error != nil {
                
                self.pageNotification.showNotification((error?.localizedDescription)! as NSString)
                spiningHud.hide(animated: true)
                return
            }
            
            guard let name = self.displayNameTxtFiled.text, let username = self.usernameTxtFiled.text, let userUID = user?.uid, let profileImg = self.profileImage.image else { return }
            
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(userUID).png")
            
            if let uploadData = UIImageJPEGRepresentation(profileImg, 0.1) {
                
                storageRef.put(uploadData, metadata: nil) { (metaData, error) in
                    
                    if error != nil {
                        
                        return
                    }
                    
                    if let imageURL = metaData?.downloadURL()?.absoluteString, let provider = user?.providerID {
                        
                        let userInfoDic = ["username":username, "name":name, "profileImage":imageURL, "likes": 0, "provider":provider] as [String : Any]
                        
                        FirebaseRef.database.createFireBaseUser(userUID, user: userInfoDic as [String:AnyObject])
                        
                        print("Successfully Created The User")
                        UserDefaults.standard.setValue(userUID, forKey: KEY_UID)
                        spiningHud.hide(animated: true)
                        let tabarController = CostumeTabBar()
                        self.navigationController?.pushViewController(tabarController, animated: true)
                        
                    }
                }
            }
        })
    }
    
    func onFaceBookSignUp(_ sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
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
    
    func setupButtons() {
        
        view.addSubview(registerBtn)
        view.addSubview(facebookBtn)
        
        //Register Button
        registerBtnXAnchor = registerBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        registerBtnXAnchor?.isActive = true
        registeBtnTopAnchar = registerBtn.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 30)
        registeBtnTopAnchar?.isActive = true
        
        //Facebook Button
        facebookBtn.leftAnchor.constraint(equalTo: profileImage.leftAnchor, constant: 20).isActive = true
        facebookBtn.topAnchor.constraint(equalTo: registerBtn.bottomAnchor, constant: 20).isActive = true
        
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
        view.addSubview(emailTxtFiled)
        view.addSubview(seperator)
        view.addSubview(passwordTxtField)
        view.addSubview(profileImage)
        view.addSubview(usernameTxtFiled)
        view.addSubview(displayNameTxtFiled)
        
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
        view.addConstraint(NSLayoutConstraint(item: emailTxtFiled, attribute: .top, relatedBy: .equal, toItem: WelcomeLabel, attribute: .bottom, multiplier: 1, constant: 30))
        
        //Seperator Constrain
        view.addConstrainstsWithFormat("H:|-60-[v0]-60-|", views: seperator)
        view.addConstrainstsWithFormat("V:[v0(0.5)]", views: seperator)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: seperator, attribute: .top, relatedBy: .equal, toItem: emailTxtFiled, attribute: .bottom, multiplier: 1, constant: 20))
        
        //Pasword Constraints
        view.addConstrainstsWithFormat("H:|-50-[v0]-50-|", views: passwordTxtField)
        view.addConstrainstsWithFormat("V:[v0]", views: passwordTxtField)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: passwordTxtField, attribute: .top, relatedBy: .equal, toItem: seperator, attribute: .bottom, multiplier: 1, constant: 10))
        
        //ProfileImage Constraints
        view.addConstrainstsWithFormat("H:|-50-[v0(70)]", views: profileImage)
        view.addConstrainstsWithFormat("V:[v0(70)]", views: profileImage)
        view.addConstraint(NSLayoutConstraint(item: profileImage, attribute: .top, relatedBy: .equal, toItem: passwordTxtField, attribute: .bottom, multiplier: 1, constant: 30))
        
        //UsernameContraints
        view.addConstrainstsWithFormat("H:[v0]", views: usernameTxtFiled)
        view.addConstrainstsWithFormat("V:[v0(30)]", views: usernameTxtFiled)
        
        //Left
        view.addConstraint(NSLayoutConstraint(item: usernameTxtFiled, attribute: .left, relatedBy: .equal, toItem: profileImage, attribute: .right, multiplier: 1, constant: 10))
        
        //CenterY
        view.addConstraint(NSLayoutConstraint(item: usernameTxtFiled, attribute: .centerY, relatedBy: .equal, toItem: profileImage, attribute: .centerY, multiplier: 1, constant: -5))
        
        //DisplayName Constraints
        view.addConstrainstsWithFormat("H:[v0]", views: displayNameTxtFiled)
        view.addConstrainstsWithFormat("V:[v0(30)]", views: displayNameTxtFiled)
        
        //Left
        view.addConstraint(NSLayoutConstraint(item: displayNameTxtFiled, attribute: .left, relatedBy: .equal, toItem: profileImage, attribute: .right, multiplier: 1, constant: 10))
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: displayNameTxtFiled, attribute: .centerY, relatedBy: .equal, toItem: usernameTxtFiled, attribute: .centerY, multiplier: 1, constant: 30))
        
        setupButtons()
    }
}
