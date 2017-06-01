//
//  EventPage.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/26/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import TGCameraViewController
import Firebase
import MBProgressHUD


private let CELL_FEED = "Cell_FEED"
private let CELL_DETAILS = "Cell_Details"
private let CELL_IMAGES = "CELL_IMAGES"
private let CELL_OPTIONS = "CELL_OPTIONS"
private let CELL_STATUS = "CELL_STATUS"
private let CELL_HOST = "CELL_HOST"
private let HEADER_ID = "HEADER_ID"

class EventDetailsPage: UICollectionViewController {
    
    var _eventDetails:Events? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Event Page"

        navigationController?.navigationBar.isTranslucent = false
        collectionView?.backgroundColor = .white
        collectionView?.register(EventDetailsCell.self, forCellWithReuseIdentifier: CELL_FEED)
        collectionView?.register(DetailsCell.self, forCellWithReuseIdentifier: CELL_DETAILS)
        collectionView?.register(ImagesCell.self, forCellWithReuseIdentifier: CELL_IMAGES)
        collectionView?.register(OptionsCell.self, forCellWithReuseIdentifier: CELL_OPTIONS)
        collectionView?.register(StatusCell.self, forCellWithReuseIdentifier: CELL_STATUS)
        collectionView?.register(HostCell.self, forCellWithReuseIdentifier: CELL_HOST)
    }
}

extension EventDetailsPage:  UICollectionViewDelegateFlowLayout {
    
    //Mark: CollectionView Delegate/DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let eventDetails = _eventDetails {
            
            if indexPath.item == 0 {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGES, for: indexPath) as? ImagesCell {
                    
                    cell.eventDetails = eventDetails
                    cell.eventPhotosCV.eventDetailPage = self
                    return cell
                }
                
            } else if indexPath.item == 1 {
        
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_FEED, for: indexPath) as? EventDetailsCell {
                    
                    cell.eventDetails = eventDetails
                    
                    return cell
                }
                
            } else if indexPath.item == 2 {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_OPTIONS, for: indexPath) as? OptionsCell {
                    
                    cell.eventDetails = eventDetails
                    cell.delegate = self
                    
                    return cell
                }
                
            } else if indexPath.item == 3 {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_STATUS, for: indexPath) as? StatusCell {
                    
                    cell.eventDetails = eventDetails
                    
                    return cell
                }
                
            } else if indexPath.item == 4 {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_HOST, for: indexPath) as? HostCell {
                    
                    cell.eventDetails = eventDetails
                    
                    return cell
                }
            }
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_DETAILS, for: indexPath) as? DetailsCell {
                
                cell.eventDetails = eventDetails
                
                return cell
            }
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        if indexPath.item == 0 {
            
            return CGSize(width: view.frame.width,
                          height: FEED_CELL_HEIGHT / 1.7)
            
        } else if indexPath.item == 1  {
            
            return CGSize(width: view.frame.width,
                          height: FEED_CELL_HEIGHT / 7)

        } else if indexPath.item == 2 {
            
            return CGSize(width: view.frame.width,
                          height: FEED_CELL_HEIGHT / 6)
            
        } else if indexPath.item == 3 || indexPath.item == 4 {
            
            return CGSize(width: view.frame.width,
                          height: FEED_CELL_HEIGHT / 8)
            
        } else {
            
            if let eventDescription = _eventDetails?.descriptions {
                
                let size = CGSize(width: view.frame.width, height: 1000)
                
                let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
                
                let estimatedFrame = NSString(string: eventDescription).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                
                return CGSize(width: view.frame.width,
                              height: estimatedFrame.height + 20)
                
            } else {
                
                return CGSize(width: view.frame.width,
                              height: 25)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func pushToAllImages(images:[Images]) {
        
        let eventPhotos = AllEventPhotos(collectionViewLayout: UICollectionViewFlowLayout())
            eventPhotos.postedImages = images
        self.navigationController?.pushViewController(eventPhotos, animated: true)
    }
}

extension EventDetailsPage: onOptionsDelegate, TGCameraDelegate {
    
    func onCamera(sender: UIButton) {
        
        TGCameraColor.setTint(darkGray)
        TGCamera.setOption(kTGCameraOptionHiddenFilterButton, value: true)
    
        let currentIamge = sender.currentImage
        
        let share = UIImage(named: "sh")
        let camera = UIImage(named: "c")
        
        if currentIamge == share {
         
            print("HELLO")
            return
            
        } else if currentIamge == camera {
            
            TGCamera.setOption(kTGCameraOptionHiddenAlbumButton, value: true)
            
        } else {
            
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
        
        guard let eventKey = _eventDetails?.event_id else {return}
        
        uploadImage(image, postKey: eventKey)
        
        dismiss(animated: true, completion: nil)

    }
    
    func cameraDidSelectAlbumPhoto(_ image: UIImage!) {
        
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
