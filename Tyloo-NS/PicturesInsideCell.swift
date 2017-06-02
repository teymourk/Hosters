////
////  FeedAllPhotosVC.swift
////  Tyloo-NS
////
////  Created by Kiarash Teymoury on 7/5/16.
////  Copyright © 2016 Kiarash Teymoury. All rights reserved.
////
//
//import UIKit
//import MapKit
//import CoreData
//
//private let CELL_ID = "cellId"
//
//class PicturesInsideCell: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
//    
//    var cellHeight:CGFloat!
//    var timer:Timer?
//    
//
//    
//    //var eventDetailPage:EventDetailsPage?
//    
//    lazy var picturesCollectionView:UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//            layout.minimumLineSpacing = 0
//            layout.minimumInteritemSpacing = 0
//            layout.scrollDirection = .horizontal
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//            cv.layer.masksToBounds = true
//            cv.isScrollEnabled = false
//            cv.delegate = self
//            cv.dataSource = self
//        return cv
//    }()
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return allImages?.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        if let cell = picturesCollectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? EventPhotosCell {
//            
//            if let images = self.allImages?[indexPath.item] {
//                
//                cell.postedImages = images
//                handleImageChanging(cell: cell)
//            }
//            
//            return cell
//        }
//        
//        return UICollectionViewCell()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: frame.width, height: frame.height)
//    }
//    
//    fileprivate func handleImageChanging(cell:EventPhotosCell) {
//        
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
//            
//            var currentIndex = Int()
//            
//            let index = self.picturesCollectionView.indexPathsForVisibleItems
//            
//            for visibleIndex in index {
//                
//                currentIndex = visibleIndex.item
//            }
//            
//            currentIndex = currentIndex + 1
//            
//            guard let imagesCount = self.allImages?.count else {return}
//            
//            if currentIndex == imagesCount {
//                
//                currentIndex = 0
//                let indexPath = IndexPath(item: currentIndex, section: 0)
//                self.picturesCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
//                return
//                
//            } else {
//                
//                let indexPath = IndexPath(item: currentIndex, section: 0)
//                self.picturesCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
//            }
//        })
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
////        if let detailPage = eventDetailPage, let imgs = allImages {
////            
////            detailPage.pushToAllImages(images: imgs)
////        }
//    }
//    
//    override func setupView() {
//        super.setupView()
//        
//        picturesCollectionView.register(EventPhotosCell.self, forCellWithReuseIdentifier: CELL_ID)
//        
//        addSubview(picturesCollectionView)
//        
//        //PicturesCollectionView Constraints
//        addConstrainstsWithFormat("H:|[v0]|", views: picturesCollectionView)
//        addConstrainstsWithFormat("V:|[v0]|", views: picturesCollectionView)
//    }
//}
