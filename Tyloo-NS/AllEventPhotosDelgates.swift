//
//  AllEventPhotosDelgates.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/1/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import FirebaseStorage
import MBProgressHUD
import TGCameraViewController

private let CELL_ID = "CellID"
private let GRID_ID = "GRID_ID"
private let HEADER_ID = "HEADER_ID"
private let SEGMENT_CELL = "SEGMENT_CELL"

extension AllEventPhotos: UICollectionViewDelegateFlowLayout {
    
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 || indexPath.item == 1 {
        
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? EventDetailsCell {
                
                cell.eventDetails = _eventDetails
                 
                return cell
            }
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
          
            return CGSize(width: view.frame.width,
                          height: FEED_CELL_HEIGHT / 1.5)
        }
        
        return CGSize(width: view.frame.height, height: 40)
    }
        
    //Mark: HeaderDelegate
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath) as? EventDetailsHeader {
            
            
            
            return header
        }
        
        return BaseCell()
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if empty {
            return CGSize(width: 0,
                          height: 0)
        }
        
        return CGSize(width: view.frame.width,
                      height: FEED_CELL_HEIGHT * 0.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if empty {
        
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return UIEdgeInsets(top: 15,
                            left: 0, bottom: 0, right: 0)
    }
}


extension AllEventPhotos: TGCameraDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func onOption(sender: UIBarButtonItem) {
        
        TGCameraColor.setTint(orange)
        TGCamera.setOption(kTGCameraOptionHiddenFilterButton, value: true)
        
        guard let image = sender.image else {return}
        
        if image == UIImage(named: "c") {
            
            TGCamera.setOption(kTGCameraOptionHiddenAlbumButton, value: true)
            
            
        } else if image == UIImage(named: "sh") {
        
        
            return
            
        } else if image == UIImage(named: "s") {
            
//            let pickerController:UIImagePickerController = TGAlbum.imagePickerController(withDelegate: self)
//            self.present(pickerController, animated: true, completion: nil)
            
            TGCamera.setOption(kTGCameraOptionHiddenAlbumButton, value: false)
        }
        
        let navigationController = TGCameraNavigationController.new(with: self)
        present(navigationController!, animated: true, completion: nil)
    }
    
    
    // MARK: TGCameraDelegate - Required methods
    func cameraDidCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func cameraDidTakePhoto(_ image: UIImage!) {
        
        postImage(image: image)
    }
    
    func cameraDidSelectAlbumPhoto(_ image: UIImage!) {
        
        postImage(image: image)
    }
    
    private func postImage(image: UIImage) {
        
        guard let eventKey = _eventDetails?.event_id else {return}
        
        uploadImage(image, postKey: eventKey)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(_ capturedImage:UIImage, postKey:String) {
        
        let imageKey = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child(postKey).child("\(imageKey).png")
        let spiningHud = MBProgressHUD.showAdded(to: view, animated: true)
        spiningHud.label.text = "Uploading..."
        
        let timePosted:CFloat = CFloat(Date().timeIntervalSince1970)
        let ref = FirebaseRef.database.REF_PHOTO.child(postKey).childByAutoId()
        var picturesDic = Dictionary<String,AnyObject>()
        
        if let uploadData = UIImagePNGRepresentation(capturedImage) {
            
            let uploadTask = storageRef.put(uploadData, metadata: nil) { (metaData, error) in
                
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                if let imageURL = metaData?.downloadURL()?.absoluteString {
                    
                    picturesDic = ["ImgURL":imageURL as NSString, "poster":FirebaseRef.database.currentUser.key as NSString, "timePosted":timePosted as NSNumber]
                    
                    ref.setValue(picturesDic, withCompletionBlock: {
                        (error, refrence) in
                        
                        if error != nil {
                            
                            print("ERROR")
                            //self.pageNotification.showNotification("Error Posting Photo")
                            spiningHud.hide(animated: true)
                        }
                    })
                }
            }
            
            uploadTask.observe(.progress, handler: {
                snapshot in
                
                if let progressPercentage = snapshot.progress?.fractionCompleted {
                    
                    let percentage = Double(progressPercentage * 100)
                    
                    self.uploadProgressView.showUplodView(percentage)

                }
            })
        }
    }
}
