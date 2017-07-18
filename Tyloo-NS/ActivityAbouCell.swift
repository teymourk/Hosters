//
//  ActivityAbouCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/17/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class ActivityAboutCell: BaseCell {
    
    var postDetais: Posts? {
        didSet {
            if let postBackGround = postDetais?.backGround {
                coverPhoto.getImagesBack(postBackGround, placeHolder: "emptyImage", loader: UIActivityIndicatorView())
            }
            
            if let tagged = postDetais?.tagged  {
                
                Posts.getTaggedUsers(tagged, completion: { (users) in
                    
                    self.peopleTagged.taggedUsersArray = users
                })
                
            } else {

                print("empty")
            }
            if let postKey = postDetais?.postKey {
                allPostedImages.postKey = postKey
            }
            
            guard let postStatus = postDetais?.statusLight else {return}
                
            date.text = postStatus == true ? "Active" : "AUGUST 30, 2015, 1:00 PM"
        }
    }
    
    var coverPhoto:UIImageView = {
        let photo = UIImageView()
        return photo
    }()
    
    lazy var viewAllPhotos:UIButton = {
        let button = UIButton()
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
            button.setTitle("View All Photos", forState: .Normal)
            button.setTitleColor(goldColor, forState: .Normal)
            button.addTarget(self, action: #selector(onViewAllPhotos(_ :)), forControlEvents: .TouchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var allPhotsPeopleWithSeperator:UIView = {
        let view = UIView()
            view.backgroundColor = .lightGrayColor()
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var peopleTagged:peopleWith = {
        let pw = peopleWith()
        return pw
    }()
    
    lazy var allPostedImages:AllPicturesVC = {
        let allpictures = AllPicturesVC()
        return allpictures
    }()
    
    lazy var camera:UIButton = {
        let button = UIButton()
            button.titleLabel?.font = UIFont.systemFontOfSize(16)
            button.titleLabel?.textAlignment = .Center
            button.setTitleColor(.lightGrayColor(), forState: .Normal)
            button.setImage(UIImage(named: "camera"), forState: .Normal)
            button.addTarget(self, action: #selector(onAddPhoto(_ :)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var checkIn:UIButton = {
        let button = UIButton()
            button.titleLabel?.font = UIFont.systemFontOfSize(16)
            button.titleLabel?.textAlignment = .Center
            button.setTitleColor(.lightGrayColor(), forState: .Normal)
            button.setImage(UIImage(named: "marker"), forState: .Normal)
            button.addTarget(self, action: #selector(onCheckIn(_ :)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    let topDataSeperato:UIView = {
        let view = UIView()
            view.backgroundColor = .grayColor()
        return view
    }()
    
    let date:UILabel = {
        let label = UILabel()
            label.font = UIFont.boldSystemFontOfSize(16)
            label.textColor = .blackColor()
        
        return label
    }()
    
    let bottomDataSeperato:UIView = {
        let view = UIView()
        view.backgroundColor = .grayColor()
        return view
    }()
    
    let mapView:MKMapView = {
        let mp = MKMapView()
        return mp
    }()
    
    func onViewAllPhotos(sender:UIButton) {
        
        print("Show All Photots")
    }
    
    var activityAboutVC:ActivityAboutVC?
    
    func onAddPhoto(sender:UIButton) {
        
        let addImageVC = AddImageCameraVC()
        addImageVC.activePostsDetails = postDetais
        activityAboutVC?.presentViewController(addImageVC, animated: true, completion: nil)
    }
    
    func onCheckIn(sender:UIButton) {
        
        print("Check-In")
    }

    func getIndexPathForCells(indexPath:Int) {
        
        switch indexPath {
        case 0:
            ActivityAboutSetup()
            break
        case 1:
            pictureSetup()
            break
        default: break
        }
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .whiteColor()
    }

    //Mark: - SetupConstraint for Activity
    func ActivityAboutSetup() {
        
        addSubview(coverPhoto)
        addSubview(viewAllPhotos)
        addSubview(allPhotsPeopleWithSeperator)
        addSubview(peopleTagged)
        addSubview(camera)
        addSubview(checkIn)
        addSubview(topDataSeperato)
        addSubview(date)
        addSubview(bottomDataSeperato)
        //addSubview(mapView)
        
        //Cover Photo Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: coverPhoto)
        addConstrainstsWithFormat("V:|[v0]", views: coverPhoto)
        
        //Height
        addConstraint(NSLayoutConstraint(item: coverPhoto, attribute: .Height, relatedBy: .Equal, toItem: coverPhoto, attribute: .Height, multiplier: 0, constant: FEED_CELL_HEIGHT))
        
        //View All Photos Constraints
        addConstrainstsWithFormat("V:[v0(20)]", views: viewAllPhotos)
        
        //Top
        addConstraint(NSLayoutConstraint(item: viewAllPhotos, attribute: .Top, relatedBy: .Equal, toItem: coverPhoto, attribute: .Bottom, multiplier: 1, constant: 7))
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: viewAllPhotos, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //Allphotos and People With Seperator Constraints
        addConstrainstsWithFormat("H:|-160-[v0]-160-|", views: allPhotsPeopleWithSeperator)
        addConstrainstsWithFormat("V:[v0(3)]", views: allPhotsPeopleWithSeperator)
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: allPhotsPeopleWithSeperator, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: allPhotsPeopleWithSeperator, attribute: .Top, relatedBy: .Equal, toItem: viewAllPhotos, attribute: .Bottom, multiplier: 1, constant: 14))
        
        //PeopleWith Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: peopleTagged)
        addConstrainstsWithFormat("V:[v0(85)]", views: peopleTagged)
        
        //Top
        addConstraint(NSLayoutConstraint(item: peopleTagged, attribute: .Top, relatedBy: .Equal, toItem: allPhotsPeopleWithSeperator, attribute: .Bottom, multiplier: 1, constant: 14))
        
        //Camera constraints
        addConstrainstsWithFormat("H:|-70-[v0(30)]", views: camera)
        addConstrainstsWithFormat("V:[v0(30)]", views: camera)
        
        addConstrainstsWithFormat("H:[v0(30)]-70-|", views: checkIn)
        addConstrainstsWithFormat("V:[v0(30)]", views: checkIn)
        
        
        //Camera Top
        addConstraint(NSLayoutConstraint(item: camera, attribute: .Top, relatedBy: .Equal, toItem: peopleTagged, attribute: .Bottom, multiplier: 1, constant: 25))
        
        //CheckIn CenterY
        addConstraint(NSLayoutConstraint(item: checkIn, attribute: .CenterY, relatedBy: .Equal, toItem: camera, attribute: .CenterY, multiplier: 1, constant: 0))
        
        //Top Seperator
        addConstrainstsWithFormat("H:|-15-[v0]-15-|", views: topDataSeperato)
        addConstrainstsWithFormat("V:[v0(0.5)]", views: topDataSeperato)
        
        //Top
        addConstraint(NSLayoutConstraint(item: topDataSeperato, attribute: .Top, relatedBy: .Equal, toItem: camera, attribute: .Bottom, multiplier: 1, constant: 6))
        
        //Date
        addConstrainstsWithFormat("H:[v0]", views: date)
        addConstrainstsWithFormat("V:[v0(20)]", views: date)
        
        //Top
        addConstraint(NSLayoutConstraint(item: date, attribute: .Top, relatedBy: .Equal, toItem: topDataSeperato, attribute: .Bottom, multiplier: 1, constant: 12))
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: date, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //Bottom Seperator
        addConstrainstsWithFormat("H:|-15-[v0]-15-|", views: bottomDataSeperato)
        addConstrainstsWithFormat("V:[v0(0.5)]", views: bottomDataSeperato)
        
        //Top
        addConstraint(NSLayoutConstraint(item: bottomDataSeperato, attribute: .Top, relatedBy: .Equal, toItem: date, attribute: .Bottom, multiplier: 1, constant: 12))
        
//        //Map Constraints
//        addConstrainstsWithFormat("H:|[v0]|", views: mapView)
//        addConstrainstsWithFormat("V:[v0]|", views: mapView)
//        
//        //Top
//        addConstraint(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: date, attribute: .Bottom, multiplier: 1, constant: 10))
        
    }
    
    let backgoroundImage:UIImageView = {
        let image = UIImageView()
            image.image = UIImage(named: "p5")
        return image
    }()
    
    let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .Dark)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    func pictureSetup() {
        
        addSubview(backgoroundImage)
        addSubview(blurView)
        addSubview(allPostedImages)
    
        //BackgorundImage Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: backgoroundImage)
        addConstrainstsWithFormat("V:|[v0]|", views: backgoroundImage)
        
        //BlurView Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: blurView)
        addConstrainstsWithFormat("V:|[v0]|", views: blurView)
        
        //PostedImagesCollectionCiew Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: allPostedImages)
        addConstrainstsWithFormat("V:|[v0]|", views: allPostedImages)
        
    }
}