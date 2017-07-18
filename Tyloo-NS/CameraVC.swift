//
//  CameraVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/13/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: BaseView, UITextViewDelegate {

    private var captureSession: AVCaptureSession?
    private var stillImageOutput: AVCaptureStillImageOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var input:AVCaptureDeviceInput?
    private var captureDevice : AVCaptureDevice?
    private var cameraPosition = AVCaptureDevicePosition.Back
    
    var addImageVC:AddImageCameraVC?
    var sessionIsRunning:Bool?
    var flashToggle:Bool?
    
    var _capturedImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .ScaleToFill
            image.userInteractionEnabled = true
        return image
    }()
    
    lazy var _rotate:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named: "switch_camera"), forState: .Normal)
            button.addTarget(self, action: #selector(onRotateCamera(_ :)), forControlEvents: .TouchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.hidden = true
        return button
    }()
    
    lazy var _flashToggole:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named:"flash_on_filled"), forState: .Normal)
            button.addTarget(self, action: #selector(onFlash(_ :)), forControlEvents: .TouchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.hidden = true
        return button
    }()
    
    lazy var captureImage:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named:"camera-2"), forState: .Normal)
            button.addTarget(self, action: #selector(onCaptureImage(_ :)), forControlEvents: .TouchUpInside)
            button.contentMode = .ScaleAspectFit
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let seperatorView:UIView = {
        let view = UIView()
            view.backgroundColor = .lightGrayColor()
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var _description:UITextView = {
        let txt = UITextView()
            txt.textColor = .whiteColor()
            txt.backgroundColor = .clearColor()
            txt.font = UIFont.systemFontOfSize(16)
            txt.scrollEnabled = false
            txt.hidden = true
            txt.delegate = self
            txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    func onCaptureImage(sender:AnyObject) {
        
        if captureImage.currentImage == UIImage(named:"camera-2") {
            if _capturedImage.image == nil {
             
                capture({ (image) in
                    
                    self._capturedImage.image = image
                    self.captureImage.setImage(UIImage(named: "Cancel"), forState: .Normal)
                })
            }
            
        } else {
            
            self._capturedImage.image = nil
            self.captureImage.setImage(UIImage(named: "camera-2"), forState: .Normal)
            self.sessionIsRunning = true
            self.sessionRunning()
        }
    }
    
    func onCancel(sender: AnyObject) {
        
        if _capturedImage.image != nil {
            
            _capturedImage.image = nil
            sessionIsRunning = true
            sessionRunning()
        }
    }
    
    func onExitCamera(sender: UIButton) {
        
        addImageVC?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onFlash(sender:UIButton) {
        
        if sender.currentImage == UIImage(named: "flash_on_filled") {
            sender.setImage(UIImage(named: "flash_off_filled"), forState: .Normal)
            flashToggle = false
            
        } else {
            sender.setImage(UIImage(named:"flash_on_filled"), forState: .Normal)
            flashToggle = true
        }
    }
    
    func onRotateCamera(sender:UIButton) {
        
    }
    
    func setupSession() {
        
        sessionIsRunning = true
        captureSession?.stopRunning()
        previewLayer?.removeFromSuperlayer()
        
        captureSession = AVCaptureSession()
        //captureSession!.sessionPreset = AVCaptureSessionPreset1920x1080
        
        
        let camera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do { input = try AVCaptureDeviceInput(device: camera) } catch { return }
        
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput!.outputSettings = [ AVVideoCodecKey: AVVideoCodecJPEG ]
        
        guard captureSession!.canAddInput(input) && captureSession!.canAddOutput(stillImageOutput) else { return }
        
        captureSession!.addInput(input)
        captureSession!.addOutput(stillImageOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = AVLayerVideoGravityResize
        previewLayer!.connection?.videoOrientation = .Portrait
        previewLayer?.masksToBounds = true
        previewLayer?.frame = self.layer.bounds
        self.layer.addSublayer(previewLayer!)
        
        //Puts preview layer underneath all the other layers(ex. buttons)
        self.layer.insertSublayer(previewLayer!, atIndex: 0)
        captureSession!.startRunning()
        
    }
    
    private func capture(completion: (UIImage) -> ())  {

        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo) {
            
            videoConnection.videoOrientation = .Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                (sampleBuffer, error) in
                
                if sampleBuffer != nil {
                    
                    let capturedImage = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataPorvider = CGDataProviderCreateWithCFData(capturedImage)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataPorvider, nil, true, .RenderingIntentDefault)
                    
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: .Right)
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(image)
                    })
                    
                    self.sessionIsRunning = false
                    self.sessionRunning()
                }
            })
        }
    }
    
    func sessionRunning() {
        
        if sessionIsRunning == true {
         
            _flashToggole.hidden = false
            _rotate.hidden = false
            seperatorView.hidden = false
            _description.hidden = true
            addImageVC?.cropView.hidden = true
            
        } else {

            _flashToggole.hidden = true
            _rotate.hidden = true
            seperatorView.hidden = true
            addImageVC?.cropView.hidden = false
        }
    }
    
    override func didMoveToSuperview() {
        
        addImageCameraSetup()
    }
    
    func addImageCameraSetup() {
        
        _flashToggole.hidden = false
        _rotate.hidden = false
        
        if let imageVC = superview {
            
            imageVC.addSubview(seperatorView)
            imageVC.addSubview(captureImage)
            imageVC.addSubview(_flashToggole)
            imageVC.addSubview(_rotate)
            imageVC.addSubview(_description)
            
            addConstrainstsWithFormat("H:|[v0]|", views: _capturedImage)
            addConstrainstsWithFormat("V:|[v0]|", views: _capturedImage)
                        
            //CaptuteButton Constraints
            imageVC.addConstrainstsWithFormat("H:[v0(50)]", views: captureImage)
            imageVC.addConstrainstsWithFormat("V:[v0(50)]", views: captureImage)
            
            //Top
            imageVC.addConstraint(NSLayoutConstraint(item: captureImage, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 30))
            
            //CenterX
            imageVC.addConstraint(NSLayoutConstraint(item: captureImage, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
            
            //Flash/Rotate/Seperator Constraints
            imageVC.addConstrainstsWithFormat("H:|-120-[v0(24)]-20-[v1(2)]-20-[v2(24)]-120-|", views: _flashToggole,seperatorView,_rotate)
            imageVC.addConstrainstsWithFormat("V:[v0(24)]", views: _flashToggole)
            imageVC.addConstrainstsWithFormat("V:[v0(24)]", views: _rotate)
            
            imageVC.addConstrainstsWithFormat("H:[v0]", views: seperatorView)
            imageVC.addConstrainstsWithFormat("V:[v0(30)]", views: seperatorView)
            
            //Flash Bottom
            imageVC.addConstraint(NSLayoutConstraint(item: _flashToggole, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: -20))
            
            //Rotate CenterY
            imageVC.addConstraint(NSLayoutConstraint(item: _rotate, attribute: .CenterY, relatedBy: .Equal, toItem: _flashToggole, attribute: .CenterY, multiplier: 1, constant: 0))
            
            
            //Seperator CenterX
            imageVC.addConstraint(NSLayoutConstraint(item: seperatorView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
            
            //Seperator CenterY
            imageVC.addConstraint(NSLayoutConstraint(item: seperatorView, attribute: .CenterY, relatedBy: .Equal, toItem: _flashToggole, attribute: .CenterY, multiplier: 1, constant: 0))
            
            //Description 
            imageVC.addConstrainstsWithFormat("H:|-5-[v0]-5-|", views: _description)
            imageVC.addConstrainstsWithFormat("V:[v0]", views: _description)
            
            //Top
            imageVC.addConstraint(NSLayoutConstraint(item: _description, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: -16))
            
            //Needs FIX
            previewLayer?.frame = CGRectMake(0, 0, imageVC.frame.width, HEIGHE_IMAGE)
        }
    }
    
    func onImage(sender:UITapGestureRecognizer) {
        
        if _capturedImage.image != nil && _description.hidden == true {
            
            _description.hidden = false
            _description.becomeFirstResponder()
            
        } else if _description.hidden == false && _description.text.isEmpty {
            
            _description.hidden = true
            _description.resignFirstResponder()
        }
    }
    
    override func setupView() {
        super.setupView()
                
        setupSession()
        
        tapGesture(self, actions: "onImage:", object: _capturedImage, numberOfTaps: 1)
        
        addSubview(_capturedImage)
        addSubview(_flashToggole)
        addSubview(_rotate)
    }
}
