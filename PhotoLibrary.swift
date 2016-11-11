//
//  PhotoLibrary.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 8/11/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Photos
import Firebase
import MBProgressHUD

private let CELL_ID = "Cell"
private let HEADER_ID = "Header"

class PhotoLibrary: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var photoLibraryImages = [UIImage]()
    var postKey:String?
    var selectedIndexPathForPhoto:IndexPath? {
        didSet {
            
            handleSettingImages(selectedIndexPathForPhoto!)
        }
    }
    
    lazy var photoLibraryCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .clear
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()

    var _images:UIImageView = {
        let img = UIImageView()
            img.contentMode = .scaleAspectFill
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white
        title = "Pick Image"
        
        self.photoLibraryCollection.register(PhotoLibraryCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.photoLibraryCollection.backgroundColor = .white
        
        setupView()
        setupNavItmes()
        handleFetchingPhotoLibrary()
        
        let index = IndexPath(item: 0, section: 0)
        
        handleSettingImages(index)
    }
    
    func setupNavItmes() {
    
        let cancel = UIBarButtonItem(image: UIImage(named:"ic_close")?.withRenderingMode(.alwaysOriginal),
                                     style: .plain, target: self,
                                     action: #selector(handleCancel(_ :)))
        
        let createNew = UIBarButtonItem(image: UIImage(named:"create_new")?.withRenderingMode(.alwaysOriginal),
                                        style: .plain,
                                        target: self,
                                        action: #selector(handleDescription(_ :)))
        
        let upload = UIBarButtonItem(title: "Upload",
                                     style: .plain,
                                     target: self,
                                     action: #selector(handleUpload(_ :)))

        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItems = [upload,createNew]
    }
    
    func setupView() {
        
        view.addSubview(photoLibraryCollection)
        view.addSubview(_images)
        
        //Iamges Constraints
        view.addConstrainstsWithFormat("H:|[v0]|", views: _images)
        view.addConstrainstsWithFormat("V:|[v0]", views: _images)
        
        //Height
        view.addConstraint(NSLayoutConstraint(item: _images, attribute: .height, relatedBy: .equal, toItem: _images, attribute: .height, multiplier: 0, constant: HEIGHE_IMAGE))
        
        //Collection Contraints
        view.addConstrainstsWithFormat("H:|[v0]|", views: photoLibraryCollection)
        view.addConstrainstsWithFormat("V:[v0]|", views: photoLibraryCollection)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: photoLibraryCollection, attribute: .top, relatedBy: .equal, toItem: _images, attribute: .bottom, multiplier: 1, constant: 2))
    
    }
    
    lazy var cancel:UIButton = {
        let bt = UIButton()
            bt.setImage(UIImage(named: "ic_close"), for: UIControlState())
            bt.addTarget(self, action: #selector(handleCancel(_ :)), for: .touchUpInside)
        return bt
    }()
    
    func handleCancel(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleDescription(_ sender: UIButton) {
        
        print("Handle Description")
    }
    
    func handleUpload(_ sender:UIButton) {
        
        guard let key = postKey else {return}
        
        uploadImage(key, description: "SAALAAMAMAMA")
    }
    
    func uploadImage(_ postKey:String, description:String) {
        
        let imageKey = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child(postKey).child("\(imageKey).png")
        let spiningHud = MBProgressHUD.showAdded(to: view, animated: true)

        let timePosted:CGFloat = CGFloat(Date().timeIntervalSince1970)
        let ref = FirebaseRef.database.REF_PHOTO.child(postKey).childByAutoId()
        var picturesDic = Dictionary<String,AnyObject>()
        
        if let uploadData = UIImagePNGRepresentation(_images.image!) {
            
            let uploadTask = storageRef.put(uploadData, metadata: nil) { (metaData, error) in
            
                if error != nil {
                    print(error)
                    return
                }
                
                if let imageURL = metaData?.downloadURL()?.absoluteString {
                    
                    picturesDic = ["ImgURL":imageURL as AnyObject, "description":description as AnyObject, "poster":FirebaseRef.database.currentUser.key as AnyObject, "timePosted":timePosted as AnyObject]
                }
                
                ref.setValue(picturesDic)
                
                self.dismiss(animated: true, completion: {
                    
                    spiningHud.hide(animated: true)
                })
            }
            
            uploadTask.observe(.progress, handler: {
                snapshot in
                
                if let progressPercentage = snapshot.progress?.fractionCompleted {
                    
                    let percentage = Int(progressPercentage * 100)
                    
                    spiningHud.label.text = "\(percentage)%"
                }
            })
        }
    }
    
    func handleSettingImages(_ indexPath:IndexPath) {
        
        let images = photoLibraryImages[(indexPath as NSIndexPath).item]
        let resizedImage = scaleImageDown(images, newSize: CGSize(width: view.frame.width, height: HEIGHE_IMAGE))
        _images.image = resizedImage
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return photoLibraryImages.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width / 4, height: view.frame.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! PhotoLibraryCell
    
        let photoImages = photoLibraryImages[(indexPath as NSIndexPath).item]
            
        cell._images.image = photoImages
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndexPathForPhoto = indexPath
    }
    
    func handleFetchingPhotoLibrary() {
        
        let imageManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOption = PHFetchOptions()
            fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOption)
        
        if fetchResult.count > 0 {
         
            for i in 0..<fetchResult.count {
                
                imageManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                    
                    image, error in
                    
                    if let images = image {
                        
                        self.photoLibraryImages.append(images)
                    }
                })
            }
        }
        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

class PhotoLibraryCell: BaseCell {
    
    var _images:UIImageView = {
        let img = UIImageView()
            img.contentMode = .scaleAspectFill
            img.clipsToBounds = true
            img.layer.borderWidth = 1
            img.layer.borderColor = UIColor.black.cgColor
        return img
    }()
    
    override var isHighlighted: Bool {
        didSet {
            
            _images.layer.borderColor = isHighlighted ? UIColor.black.cgColor : orange.cgColor
        }
    }
    
    override var isSelected: Bool {
        didSet {
            
            _images.layer.borderColor = isHighlighted ? UIColor.black.cgColor : orange.cgColor
        }
    }
    
    override func setupView() {
        super.setupView()
        
        addSubview(_images)
        
        backgroundColor = .red
        
        //AllImages Constrains
        addConstrainstsWithFormat("H:|[v0]|", views: _images)
        addConstrainstsWithFormat("V:|[v0]|", views: _images)
    }
}
