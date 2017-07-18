//
//  PicturesVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/15/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "Cell"

class PicturesVC: UIViewController {
    
    var photosVC:PhotosVCAllPictures?

    var allCoverPhotos:CoverPicturesVC = {
        let cp = CoverPicturesVC()
        return cp
    }()
    
    lazy var allImages:PhotosVCAllPictures = {
        let cp = PhotosVCAllPictures()
            cp.photosVC = self
        return cp
    }()
    
    var labelView:UIView = {
        let view = UIView()
            view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return view
    }()
    
    var allImagesLabel:UILabel = {
        let label = UILabel()
            label.text = "Friends Photos"
            label.textColor = .blackColor()
            label.backgroundColor = UIColor(white: 0.95, alpha: 1)
            label.font = UIFont.boldSystemFontOfSize(16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        view.backgroundColor = darkGray
        
       setupView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupView() {
        
        view.addSubview(allCoverPhotos)
        view.addSubview(allImages)
        view.addSubview(allImagesLabel)
        view.addSubview(labelView)
        labelView.addSubview(allImagesLabel)
        
        //CoverPhotos Constrains
        view.addConstrainstsWithFormat("H:|[v0]|", views: allCoverPhotos)
        view.addConstrainstsWithFormat("V:|[v0]", views: allCoverPhotos)
        
        //Height
        view.addConstraint(NSLayoutConstraint(item: allCoverPhotos, attribute: .Height, relatedBy: .Equal, toItem: allCoverPhotos, attribute: .Height, multiplier: 0, constant: FEED_CELL_HEIGHT))
        
        //AllImages Label Constrains
        view.addConstrainstsWithFormat("H:|[v0]|", views: labelView)
        view.addConstrainstsWithFormat("V:[v0(30)]", views: labelView)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: labelView, attribute: .Top, relatedBy: .Equal, toItem: allCoverPhotos, attribute: .Bottom, multiplier: 1, constant: 0))
        
        
        //Label Constraints
        labelView.addConstrainstsWithFormat("H:[v0]", views: allImagesLabel)
        labelView.addConstrainstsWithFormat("V:|[v0]|", views: allImagesLabel)
        
        //CneterX
        labelView.addConstraint(NSLayoutConstraint(item: allImagesLabel, attribute: .CenterX, relatedBy: .Equal, toItem: labelView, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //AllImages Constrains
        view.addConstrainstsWithFormat("H:|[v0]|", views: allImages)
        view.addConstrainstsWithFormat("V:[v0]|", views: allImages)
        
        //Top
        view.addConstraint(NSLayoutConstraint(item: allImages, attribute: .Top, relatedBy: .Equal, toItem: labelView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
}
