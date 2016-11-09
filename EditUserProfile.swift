//
//  EditProfileVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/13/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase

class EditUserProfile: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentUserProfile:Users? {
        didSet {
            
            if let imageURL = currentUserProfile?.profileImage {
                profileImage.getImagesBack(url: imageURL, placeHolder: "Profile")
            }
            
            if let changeDisplayNamePlaceHolder = currentUserProfile?.name {
                changeDisplayName.attributedPlaceholder = NSAttributedString(string: changeDisplayNamePlaceHolder, attributes: [NSForegroundColorAttributeName: UIColor.black])
            }
            
            if let changeUsernamePlace = currentUserProfile?.username {
                changeName.attributedPlaceholder = NSAttributedString(string: changeUsernamePlace, attributes: [NSForegroundColorAttributeName: UIColor.black])
            }
        }
    }

    var profileImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.masksToBounds = true
            image.layer.borderColor = darkGray.cgColor
            image.layer.borderWidth = 2
            image.layer.cornerRadius = 50
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var changeProfileImage:UIButton = {
        let btn = UIButton(type: .system)
            btn.setTitle("Change Profile Photo", for: .normal)
            btn.titleLabel?.font = UIFont(name: "NotoSans", size: 15)
            btn.addTarget(self, action: #selector(onChangeProfilePhoto(_ :)), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
       return btn
    }()
    
    let changeDisplayName:UITextField = {
        let txtField = UITextField()
            txtField.borderStyle = .none
            txtField.font = UIFont(name: "NotoSans", size: 15)
            txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    let changeName:UITextField = {
        let txtField = UITextField()
            txtField.borderStyle = .none
            txtField.font = UIFont(name: "NotoSans", size: 15)
            txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    let progressBar:UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
            progress.progressTintColor = .red
            progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Edit Profile"
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        setupView()
        setupNavBar()
    }
    
    func onChangeProfilePhoto(_ sender:UIButton) {
        
        handleAlert()
    }
    
    func setupNavBar() {
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onCancel(_ :)))
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onDone(_ :)))
        
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = done
    }
    
    func onCancel(_ sender: UIButton) {
    
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func onDone(_ sender: UIButton) {
        
        uploadImage()
    }
    
    func uploadImage() {
        
        let userKey = FirebaseRef.database.currentUser.key
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(userKey).png")
        let currentUserRef = FirebaseRef.database.currentUser.child("user")
        
        if let uploadData = UIImageJPEGRepresentation(profileImage.image!, 0.1) {
            
            let uploadTask = storageRef.put(uploadData, metadata: nil) { (metaData, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let imageURL = metaData?.downloadURL()?.absoluteString {
                    
                    currentUserRef.updateChildValues(["profileImage":imageURL])
                }
            }
            
            uploadTask.observe(.progress, handler: {
                snapshot in
                
                guard let progressPercentage = snapshot.progress?.fractionCompleted else {return}
                
                self.progressBar.progress = Float(progressPercentage)
                
                if progressPercentage == 1.0 {
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
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
    
    func setupView() {
        
        view.addSubview(profileImage)
        view.addSubview(changeProfileImage)
        view.addSubview(changeDisplayName)
        view.addSubview(changeName)
        view.addSubview(progressBar)
        
        //ProfileImage Contraints
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        //ChangeProfileImageLabel Constrains
        changeProfileImage.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
        changeProfileImage.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 5).isActive = true

        //ChangeDisplayName Constraints
        changeDisplayName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        changeDisplayName.topAnchor.constraint(equalTo: changeProfileImage.bottomAnchor, constant: 30).isActive = true
        
        //ChangeName Constrainsts
        changeName.leftAnchor.constraint(equalTo: changeDisplayName.leftAnchor).isActive = true
        changeName.topAnchor.constraint(equalTo: changeDisplayName.bottomAnchor, constant: 15).isActive = true
        
        //ProgressBar Constraints
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        progressBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        progressBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
    }
}

