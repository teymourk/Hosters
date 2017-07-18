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

class CompleteFacebookRegister: UIViewController {
    
    let profileImage:UIImageView = {
        let image = UIImageView()
            image.image = UIImage(named: "Profile")
            image.layer.masksToBounds = true
            image.layer.borderWidth = 1
            image.layer.cornerRadius = 5
            image.contentMode = .scaleAspectFill
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var userFacebookName:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "PROMPT", size: 15)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var seperator:UIView = {
        let view = UIView()
            view.backgroundColor = darkGray
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let permissionPages:ScrollPage = {
        let pages = ScrollPage()
            pages.isPagingEnabled = true
            pages.showsHorizontalScrollIndicator = false
            pages.translatesAutoresizingMaskIntoConstraints = false
        return pages
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
                print(error ?? "")
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
    
    func handleCompleteRegister(_ user: User?) {
        
        guard let name = self.userFacebookName.text, let userID = FBSDKAccessToken.current().userID, let profileImg = self.profileImage.image else { return }
        
        let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        //let imageKey = UUID().uuidString //Create Random String
        let storageRef = Storage.storage().reference().child("profile_images").child("\(userID).png")
        
        if let uploadData = UIImageJPEGRepresentation(profileImg, 0.1) {
            
            storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                if let imageURL = metaData?.downloadURL()?.absoluteString {
                
                    let userInfoDic = ["name":name, "profileImage":imageURL]
                    
                    FirebaseRef.database.createFireBaseUser(userID, user: userInfoDic as Dictionary<String, AnyObject>)
                    
                    print("Successfully Created The User")
                    
                    let tabarController = CostumeTabBar()
                    self.navigationController?.pushViewController(tabarController, animated: true)
                    self.navigationController?.navigationBar.isHidden = true
                    progressHUD.hide(animated: true)
                }
            }
        }
    }
    
    func handleFirebaseAuth() {
        
        let facebookCredentials = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: facebookCredentials, completion: { (facebookUser, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            print("USER LOGGED IN TO FIREBASE")
            self.handleCompleteRegister(facebookUser)
        })
    }
    
    fileprivate func setupView() {
        
        view.addSubview(profileImage)
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
        view.addSubview(userFacebookName)
        
        userFacebookName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userFacebookName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(seperator)

        seperator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        seperator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        view.addSubview(permissionPages)
        
        permissionPages.widthAnchor.constraint(equalToConstant: view.frame.width * 3).isActive = true
        permissionPages.topAnchor.constraint(equalTo: seperator.bottomAnchor).isActive = true
        permissionPages.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        permissionPages.contentSize = CGSize(width: view.bounds.width * 3, height: 200)
    }
}
