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
    var timer:Timer?

    var allImages:[PostImages]? {
        didSet{

            if allImages?.count == nil {
                
                self.setupMap()
                return
                
            } else {
    
                mapView.removeFromSuperview()
            }
            
            picturesCollectionView.reloadData()
        }
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
            mp.layer.masksToBounds = true
            mp.layer.cornerRadius = 6
        return mp
    }()
    
    func setupMap() {
        
        addSubview(mapView)
        locationNameForView()
        
        addConstrainstsWithFormat("H:|[v0]|", views: mapView)
        addConstrainstsWithFormat("V:|[v0]|", views: mapView)
    }
    
    fileprivate func locationNameForView() {
        
        guard let lat = feedCell?.postsDetails?.latitude,
            let long = feedCell?.postsDetails?.longtitude,
            let locationName = feedCell?.postsDetails?.location else {return}
        
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
            cv.layer.masksToBounds = true
            cv.layer.cornerRadius = 6
            cv.isScrollEnabled = false
            cv.backgroundColor = .clear
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
        
        if let images = allImages?[indexPath.item] {
            
            cell.postedImages = images
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 6
        }
        
        handleImageChanging(cell: cell)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width, height: frame.height)
    }
    
    fileprivate func handleImageChanging(cell:FeedAllPhotosCell) {

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true, block: { (timer) in
            
            var currentIndex:Int?
            
            let index = self.picturesCollectionView.indexPathsForVisibleItems
                
            for visibleIndex in index {
                
                currentIndex = visibleIndex.item
            }
            
            currentIndex = currentIndex! + 1
            
            guard let imagesCount = self.allImages?.count else {return}
            
            if currentIndex == imagesCount {
                
                currentIndex = 0
                let indexPath = IndexPath(item: currentIndex!, section: 0)
                self.picturesCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
                return
                
            } else {
             
                let indexPath = IndexPath(item: currentIndex!, section: 0)
                self.picturesCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
            }
        })
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
