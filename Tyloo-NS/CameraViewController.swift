//
//  CameraViewController.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/20/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import SwiftyCam

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {

    lazy var captureButton:UIButton = {
        let btn = UIButton()
            btn.setImage(UIImage(named: "camera"), for: .normal)
            btn.addTarget(self, action: #selector(onOptions(sender:)), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var campturedImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var uploadButton:UIButton = {
        let button = UIButton()
            button.addTarget(self, action: #selector(onUpload(sender: )), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraDelegate = self
        defaultCamera = .front
        doubleTapCameraSwitch = true
        pinchToZoom = true
        tapToFocus = true
        
        allowBackgroundAudio = false
        swipeToZoom = false
        flashEnabled = true
        
        setupCameraLayout()
    }
    
    @objc
    fileprivate func onOptions(sender: UIButton) {
        
        let buttonImage = sender.currentImage
        let cameraButton = UIImage(named: "camera")
        let cancelButton = UIImage(named: "cancel")
        
        if buttonImage == cameraButton {
            
            if isSessionRunning {
                takePhoto()
                sender.setImage(cancelButton, for: .normal)
                return
            }
        } else {
        
            campturedImage.image = nil
            sender.setImage(cameraButton, for: .normal)
        }
    }
    
    @objc
    fileprivate func onUpload(sender: UIButton) {
        
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        
        campturedImage.image = photo
    }
    
    private func setupCameraLayout() {
        
        view.addSubview(campturedImage)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: campturedImage)
        view.addConstrainstsWithFormat("V:|[v0]|", views: campturedImage)
        
        view.addSubview(captureButton)
        
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
}
