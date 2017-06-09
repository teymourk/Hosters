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

struct Images {
    
    let img:String
}

extension AllEventPhotos: UICollectionViewDelegateFlowLayout {

    var postedImages:[Images]? {
        
        let image1 = Images(img: "https://firebasestorage.googleapis.com/v0/b/tyloo-5bcf5.appspot.com/o/288293611629956%2F6826BA69-91E6-4491-AC77-A96E28D46FEC.png?alt=media&token=ac440d2a-9317-4f68-8bf9-2f0748905696")
        let image2 = Images(img: "https://firebasestorage.googleapis.com/v0/b/tyloo-5bcf5.appspot.com/o/728991830611993%2FA2EDB055-FD13-4E2D-84E1-C078ADEB9157.png?alt=media&token=015da72c-c16a-4a87-b45c-65e3f4a2ffbb")
        let image3 = Images(img: "https://firebasestorage.googleapis.com/v0/b/tyloo-5bcf5.appspot.com/o/728991830611993%2F46AE4340-8B23-4DF0-8780-39C60A9E7C18.png?alt=media&token=2f68f3a5-7a73-4729-bba0-28cea99a988c")
        let image4 = Images(img: "https://i.ytimg.com/vi/ZTWzEShwsJQ/maxresdefault.jpg")
        
        let image5 = Images(img: "http://mikeposnerhits.com/wp-content/uploads/2014/06/OSU-DamJam2014-05312014-2.jpg")
        
        let image6 = Images(img: "https://s.aolcdn.com/dims-shared/dims3/GLOB/crop/2094x1309+0+57/resize/1400x875!/format/jpg/quality/85/http://hss-prod.hss.aol.com/hss/storage/midas/8cf7e00a4df3ebee6ff77100a6ce06c5/203138988/484533465.jpg")
        
        let image7 = Images(img: "http://www.billboard.com/files/media/drake-performance-sept-04-billboard-1548.jpg")
        
        let image8 = Images(img: "https://firebasestorage.googleapis.com/v0/b/tyloo-5bcf5.appspot.com/o/161954997675468%2F87A9707E-39DB-45A3-A627-6BD0AB9A4A89.png?alt=media&token=065c5160-92ae-4b1f-acdb-62d22f195a38")
        
        return [image1,image2,image3,image4,image5,image6,image7,image8]
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return postedImages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SEGMENT_CELL, for: indexPath) as? SegmentCell {
                
                cell.delegate = self
                
                return cell
            }
            
        } else {
            
            if !grid {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? AllEventPhotosCell {
                    
                    cell.postImages = postedImages?[indexPath.item]
                    return cell
                }
                
            } else {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GRID_ID, for: indexPath) as? GridCell {
                    
                    cell.postImages = postedImages?[indexPath.item]
                    return cell
                }
            }
        }
    
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
          
            return CGSize(width: view.frame.width,
                          height: 40)
        }
        
        let width:CGFloat = grid == true ? view.frame.width / 3 : view.frame.width
        let height:CGFloat = grid == true ? HEIGHE_IMAGE / 3 : HEIGHE_IMAGE + 20
        
        return CGSize(width: width, height: height)
    }
        
    //Mark: HeaderDelegate
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath) as? EventDetailsHeader {
            
            if let eventDetilas = _eventDetails {
                
                header._eventDetails = eventDetilas
            }
            
            return header
        }
        
        return BaseCell()
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width,
                      height: FEED_CELL_HEIGHT / 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 15,
                            left: 0, bottom: 0, right: 0)
    }
}

extension AllEventPhotos: onSegmentDelegate {
    
    func onSegment(sender: UISegmentedControl) {
        
        let segmentIndex = sender.selectedSegmentIndex
        
        grid = segmentIndex == 0 ? true : false
        
        collectionView?.reloadData()
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
        
        dismiss(animated: true, completion: nil)
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
                    
                    spiningHud.label.text = "\(percentage)%"
                    spiningHud.hide(animated: true)
                }
            })
        }
    }
}
