//
//  CompleteFacebookRegister.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 9/9/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import MBProgressHUD

class CompleteFacebookRegister: UIViewController, UITextFieldDelegate {
    
    let profileImage:UIImageView = {
        let image = UIImageView()
            image.image = UIImage(named: "Profile")
            image.layer.masksToBounds = true
            image.layer.cornerRadius = 50
            image.layer.borderWidth = 1
            image.alpha = 0
            image.contentMode = .scaleToFill
        return image
    }()
    
    let guideLabel:UILabel = {
        let label = UILabel()
            label.textColor = .lightGray
            label.textAlignment = .center
            label.text = "Tap To Change Photo"
            label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var userFacebookName:UILabel = {
        let label = UILabel()
            label.text = "Whats Your Name?"
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "PROMPT", size: 15)
        return label
    }()
    
    lazy var usernameTxtFiled:UITextField = {
        let txtField = UITextField()
            txtField.borderStyle = .none
            txtField.placeholder = "Choose a Username"
            txtField.textColor = .black
            txtField.textAlignment = .center
            txtField.delegate = self
            txtField.font = UIFont(name: "PROMPT", size: 15)
        return txtField
        
    }()
    
    lazy var continueBtn:UIButton = {
        let button = UIButton()
            button.setTitle("Continue", for: UIControlState())
            button.addTarget(self, action: #selector(onContinue(_ :)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.backgroundColor = .gray
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 5
        return button
    }()
    
    var seperator:UIView = {
        let view = UIView()
            view.backgroundColor = darkGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white
        
        setupNavBar()
        setupView()
        handleFetchingUserFromFacebook()
    }
    
    func setupNavBar() {
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onCancel(_ :)))
        navigationItem.leftBarButtonItem = cancel
    }
    
    func onCancel(_ sender: UIButton) {
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func onContinue(_ sender:UIButton) {
        
        handleFirebaseAuth()
    }
    
    private func handleFetchingUserFromFacebook() {
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
    
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, results, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            if let result = results as? NSDictionary {
              
                if let first_name = result["first_name"] as? String, let last_name = result["last_name"] as? String {
                    
                    self.userFacebookName.text  = ("\(first_name) \(last_name)")
                }
                
                if let picture = result["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                    
                    self.profileImage.getImagesBack(url: url, placeHolder: "Profile")
                }
            }
        }
    }
    
    func handleCompleteRegister(_ user: FIRUser?) {
        
        guard let name = self.userFacebookName.text, let username = self.usernameTxtFiled.text, let userUID = user?.uid, let profileImg = self.profileImage.image else { return }
        
        let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        let imageKey = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageKey).png")
        
        if let uploadData = UIImageJPEGRepresentation(profileImg, 0.1) {
            
            storageRef.put(uploadData, metadata: nil) { (metaData, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let imageURL = metaData?.downloadURL()?.absoluteString {
                
                    let userInfoDic = ["username":username, "name":name, "profileImage":imageURL, "likes": 0, "provider":"Facebook"] as [String : Any]
                    
                    FirebaseRef.database.createFireBaseUser(userUID, user: userInfoDic as Dictionary<String, AnyObject>)
                    
                    print("Successfully Created The User")
                    UserDefaults.standard.setValue(userUID, forKey: KEY_UID)
                    let tabarController = CostumeTabBar()
                    self.navigationController?.setNavigationBarHidden(true, animated: false)
                    self.navigationController?.pushViewController(tabarController, animated: true)
                    progressHUD.hide(animated: true)
                }
            }
        }
    }
    
    func handleFirebaseAuth() {
        
        let facebookCredentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: facebookCredentials, completion: { (facebookUser, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            print("USER LOGGED IN TO FIREBASE")
            self.handleCompleteRegister(facebookUser)
        })
    }
    
    func animateProfileImage() {
        
        profileImage.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        
        UIView.animate(withDuration: 1, animations: {
            
            self.profileImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.profileImage.alpha = 1
        })
    }

    func setupView() {
        
        view.addSubview(profileImage)
        view.addSubview(guideLabel)
        view.addSubview(seperator)
        view.addSubview(userFacebookName)
        view.addSubview(usernameTxtFiled)
        view.addSubview(continueBtn)
        
        perform(#selector(animateProfileImage), with: nil, afterDelay: 0.2)
        
        //ProfileImage Constraints
        view.addConstrainstsWithFormat("H:[v0(100)]", views: profileImage)
        view.addConstrainstsWithFormat("V:|-30-[v0(100)]", views: profileImage)
        
        //CenterX
        view.addConstraint(NSLayoutConstraint(item: profileImage, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
        
        //GuideLabel Constraints
        view.addConstrainstsWithFormat("H:[v0]", views: guideLabel)
        view.addConstrainstsWithFormat("V:[v0]", views: guideLabel)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: guideLabel, attribute: .top, relatedBy: .equal, toItem: profileImage, attribute: .bottom, multiplier: 1, constant: 10))
        
        //CenterX
        view.addConstraint(NSLayoutConstraint(item: guideLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
        //Seperator 
        view.addConstrainstsWithFormat("H:|-20-[v0]-20-|", views: seperator)
        view.addConstrainstsWithFormat("V:[v0(0.5)]", views: seperator)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: seperator, attribute: .top, relatedBy: .equal, toItem: guideLabel, attribute: .bottom, multiplier: 1, constant: 10))
        
        //Username Constrains
        view.addConstrainstsWithFormat("H:|[v0]|", views: userFacebookName)
        view.addConstrainstsWithFormat("V:[v0]", views: userFacebookName)

        //Top
        view.addConstraint(NSLayoutConstraint(item: userFacebookName, attribute: .top, relatedBy: .equal, toItem: seperator, attribute: .bottom, multiplier: 1, constant: 20))
        
        //displayName Constrains
        view.addConstrainstsWithFormat("H:|[v0]|", views: usernameTxtFiled)
        view.addConstrainstsWithFormat("V:[v0]", views: usernameTxtFiled)

        //Top
        view.addConstraint(NSLayoutConstraint(item: usernameTxtFiled, attribute: .top, relatedBy: .equal, toItem: userFacebookName, attribute: .bottom, multiplier: 1, constant: 15))

        //Continue Constraints
        view.addConstrainstsWithFormat("H:|-100-[v0]-100-|", views: continueBtn)
        view.addConstrainstsWithFormat("V:[v0(50)]", views: continueBtn)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: continueBtn, attribute: .top, relatedBy: .equal, toItem: usernameTxtFiled, attribute: .top, multiplier: 1, constant: 100))
    }
}
