//
//  LoginVC2.swift
//  
//
//  Created by Kiarash Teymoury on 11/10/16.
//
//

import UIKit
import Firebase
import MBProgressHUD
import FBSDKLoginKit

class LoginVC: RegisterVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.removeFromSuperview()
        displayNameTxtFiled.removeFromSuperview()
        usernameTxtFiled.removeFromSuperview()
    }
    
    override func setupButtons() {
        
        view.addSubview(registerBtn)
        view.addSubview(facebookBtn)
        
        registerBtn.setTitle("Login", for: .normal)
        facebookBtn.setTitle("Login With Facebook", for: .normal)
        
        //Register Button
        registerBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerBtn.topAnchor.constraint(equalTo: passwordTxtField.bottomAnchor, constant: 30).isActive = true
        
        //Facebook Button
        facebookBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookBtn.topAnchor.constraint(equalTo: registerBtn.bottomAnchor, constant: 20).isActive = true
    }
    
    override func onRegisterFireBase(_ sender: UIButton) {
        
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
    
    override func onFaceBookSignUp(_ sender: UIButton) {
        
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Sigin In..."
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                progressHUD.hide(animated: true)
        
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
    
    func handlePushingToHomePage(_ id:String) {
        
        UserDefaults.standard.setValue(id, forKey: KEY_UID)
        let tabarController = CostumeTabBar()
        self.navigationController?.pushViewController(tabarController, animated: true)
    }
}
