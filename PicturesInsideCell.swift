//
//  FeedAllPhotosVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/5/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MapKit

private let CELL_ID = "cellId"

class PicturesInsideCell: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cellHeight:CGFloat!
    
    var allImages:[PostImages]? {
        didSet{
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleReloading), userInfo: nil, repeats: false)
            
            if allImages?.count == nil {
                
                self.setupMap()
                return
                
            } else {
    
                mapView.removeFromSuperview()
            }
            
            picturesCollectionView.reloadData()
        }
    }
    
    var timer:Timer?
    
    func handleReloading() {
        
        self.picturesCollectionView.reloadData()
    }
    
    var feedCell:FeedCell?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        feedCell?.friendsFeedView?.picturesForPosts = self
    }
    
    var mapView:MKMapView = {
        let mp = MKMapView()
            mp.isScrollEnabled = false
            mp.isZoomEnabled = false
        return mp
    }()
    
    func setupMap() {
        
        addSubview(mapView)
        locationNameForView()
        
        addConstrainstsWithFormat("H:|[v0]|", views: mapView)
        addConstrainstsWithFormat("V:|[v0]|", views: mapView)
    }
    
    fileprivate func locationNameForView() {
        
        guard let lat = feedCell?.postsDetails?.latitude, let long = feedCell?.postsDetails?.longtitude, let locationName = feedCell?.postsDetails?.location else {return}
        
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(long))
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(location, span)
        
        let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = locationName
        
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
        
    }
    
    lazy var picturesCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .clear
            cv.isScrollEnabled = false
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allImages?.count ?? 0
    }
    
    var index:IndexPath?
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = picturesCollectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! FeedAllPhotosCell
        
        if let postImages = self.allImages?[(indexPath as NSIndexPath).item] {
        
            cell.postedImages = postImages
            cell.feedAllPhotos = self
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let imagesCount = allImages?.count {
            
            if imagesCount == 1 {
                
                if (indexPath as NSIndexPath).item == 0 {
                
                    return CGSize(width: frame.width, height: frame.height)
                }
                
            } else if imagesCount == 2 {
                
                return CGSize(width: frame.width / 2, height: frame.height)
        
            } else if imagesCount == 4 {
                
                if (indexPath as NSIndexPath).item == 3 {
                    
                    return CGSize(width: frame.width, height: frame.height / 2)
                }
                
            } else if imagesCount == 5 {
                                
                if (indexPath as NSIndexPath).item == 4 {
                    
                    return CGSize(width: frame.width / 1.5 , height: frame.height / 2)
                }
            }
        }
        
        return CGSize(width: frame.width/3, height: frame.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let feeds = feedCell {
            
            if let indexForImages = index {
            
                feeds.friendsFeedView?.didSelectOnPost(indexForImages)
            }
        }
    }
    
    override func setupView() {
        super.setupView()
        
        picturesCollectionView.register(FeedAllPhotosCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        addSubview(picturesCollectionView)
        
        //PicturesCollectionView Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: picturesCollectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: picturesCollectionView)
    }
}
