//
//  FeedAllPhotosVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/5/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import MapKit
import CoreData

protocol PicturesInsideCellDelegate: class {
    
    func onImages(images:[PostImages])
}

private let CELL_ID = "cellId"

class PicturesInsideCell: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    var delegate:PicturesInsideCellDelegate?
    
    var cellHeight:CGFloat!
    var timer:Timer?
    
    var postKey:String? {
        didSet {
            if let key = postKey {
                
                filterArray(key: key)
            }
        }
    }

    var allImages:[PostImages]?
    
    var filteredImages:[PostImages]? {
        didSet {
            
            if let postImage = filteredImages {
                
                if postImage.isEmpty {
                    
                    setupMap()
                    return
                }
                
                mapView.removeFromSuperview()
            }
            
            picturesCollectionView.reloadData()
        }
    }
    
    var feedCell:FeedCell?
    
    func filterArray(key:String) {
        
        if let images = self.allImages {
            
            let filteredImage = images.filter({$0.postKey == key})
            
            self.filteredImages = filteredImage
        }
    }
    
    override func didMoveToSuperview() {
        
        feedCell?.friendsFeedView?.picturesForPosts = self
        
        do {
            try fetchController.performFetch()
            
            if let images = fetchController.fetchedObjects {
                
                self.allImages = images
            }
            
        } catch let err {
            print(err)
        }
    }
    
    var mapView:MKMapView = {
        let mp = MKMapView()
            mp.isScrollEnabled = false
            mp.isZoomEnabled = false
        return mp
    }()
    
    var coverImage:UIImageView = {
        let img = UIImageView()
            img.contentMode = .scaleAspectFill
            img.layer.masksToBounds = true
        return img
    }()
    
    lazy var fetchController:NSFetchedResultsController<PostImages> = {
        let fetch: NSFetchRequest<PostImages> = PostImages.fetchRequest()
            fetch.sortDescriptors = [NSSortDescriptor(key: "timePosted", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            frc.delegate = self
        return frc
    }()
    
    func setupMap() {
        
        addSubview(mapView)
        locationNameForView()
        
        addConstrainstsWithFormat("H:|[v0]|", views: mapView)
        addConstrainstsWithFormat("V:|[v0]|", views: mapView)
    }
    
    func setupCoverImage() {
    
        addSubview(coverImage)
        
        addConstrainstsWithFormat("H:|[v0]|", views: coverImage)
        addConstrainstsWithFormat("V:|[v0]|", views: coverImage)
    }
    
    fileprivate func locationNameForView() {
        
        guard let lat = feedCell?.postsDetails?.latitude,
            let long = feedCell?.postsDetails?.longtitude else {return}
       
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(long))
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(location, span)
        
        let annotation = MKPointAnnotation()
            annotation.coordinate = location
        
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
        
    }
    
    lazy var picturesCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .horizontal
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
        
        return self.filteredImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = picturesCollectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? FeedAllPhotosCell {
            
            if let images = self.filteredImages?[indexPath.item] {
                
                cell.postedImages = images
                handleImageChanging(cell: cell)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width, height: frame.height)
    }
    
    fileprivate func handleImageChanging(cell:FeedAllPhotosCell) {

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            
            var currentIndex:Int?
            
            let index = self.picturesCollectionView.indexPathsForVisibleItems
                
            for visibleIndex in index {
                
                currentIndex = visibleIndex.item
            }
            
            currentIndex = currentIndex! + 1
            
            guard let imagesCount = self.filteredImages?.count else {return}
            
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
        
        if let images = filteredImages {
    
            if delegate != nil {
                delegate?.onImages(images: images)
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
