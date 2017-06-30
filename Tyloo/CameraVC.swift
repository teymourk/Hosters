//
//  CameraVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/21/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import TGCameraViewController

class CameraVC: UIViewController, TGCameraDelegate {

    
    var photoView:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        let clearButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:#selector(clearTapped))
        navigationItem.rightBarButtonItem = clearButton
    }
    
    
    func cameraDidCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func cameraDidTakePhoto(_ image: UIImage!) {
        photoView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func cameraDidSelectAlbumPhoto(_ image: UIImage!) {
        photoView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: TGCameraDelegate - Optional methods
    
    func cameraWillTakePhoto() {
        print("cameraWillTakePhoto")
    }
    
    func cameraDidSavePhoto(atPath assetURL: URL!) {
        print("cameraDidSavePhotoAtPath: \(assetURL)")
    }
    
    func cameraDidSavePhotoWithError(_ error: Error!) {
        print("cameraDidSavePhotoWithError \(error)")
    }
    
    
    // MARK: Actions

    func clearTapped() {
        photoView.image = nil
    }
}
