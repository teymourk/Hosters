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

private let CELL_ID = "cellId"

struct Images {
    
    let img:String
}


class PicturesInsideCell: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    var cellHeight:CGFloat!
    var timer:Timer?
    
    var allImages:[Images]? {
        
        let image1 = Images(img: "https://firebasestorage.googleapis.com/v0/b/tyloo-5bcf5.appspot.com/o/288293611629956%2F6826BA69-91E6-4491-AC77-A96E28D46FEC.png?alt=media&token=ac440d2a-9317-4f68-8bf9-2f0748905696")
        let image2 = Images(img: "https://firebasestorage.googleapis.com/v0/b/tyloo-5bcf5.appspot.com/o/728991830611993%2FA2EDB055-FD13-4E2D-84E1-C078ADEB9157.png?alt=media&token=015da72c-c16a-4a87-b45c-65e3f4a2ffbb")
        let image3 = Images(img: "https://firebasestorage.googleapis.com/v0/b/tyloo-5bcf5.appspot.com/o/728991830611993%2F46AE4340-8B23-4DF0-8780-39C60A9E7C18.png?alt=media&token=2f68f3a5-7a73-4729-bba0-28cea99a988c")
        let image4 = Images(img: "https://i.ytimg.com/vi/ZTWzEShwsJQ/maxresdefault.jpg")
        
        let image5 = Images(img: "http://mikeposnerhits.com/wp-content/uploads/2014/06/OSU-DamJam2014-05312014-2.jpg")
        
        let image6 = Images(img: "https://s.aolcdn.com/dims-shared/dims3/GLOB/crop/2094x1309+0+57/resize/1400x875!/format/jpg/quality/85/http://hss-prod.hss.aol.com/hss/storage/midas/8cf7e00a4df3ebee6ff77100a6ce06c5/203138988/484533465.jpg")
        
        let image7 = Images(img: "http://www.billboard.com/files/media/drake-performance-sept-04-billboard-1548.jpg")
        
        return [image1,image2,image3,image4,image5,image6,image7]
    }
    
    var eventDetailPage:EventDetailsPage?
    
    lazy var picturesCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.layer.masksToBounds = true
            cv.isScrollEnabled = false
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = picturesCollectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? EventPhotosCell {
            
            if let images = self.allImages?[indexPath.item] {
                
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
    
    fileprivate func handleImageChanging(cell:EventPhotosCell) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            
            var currentIndex = Int()
            
            let index = self.picturesCollectionView.indexPathsForVisibleItems
            
            for visibleIndex in index {
                
                currentIndex = visibleIndex.item
            }
            
            currentIndex = currentIndex + 1
            
            guard let imagesCount = self.allImages?.count else {return}
            
            if currentIndex == imagesCount {
                
                currentIndex = 0
                let indexPath = IndexPath(item: currentIndex, section: 0)
                self.picturesCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
                return
                
            } else {
                
                let indexPath = IndexPath(item: currentIndex, section: 0)
                self.picturesCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let detailPage = eventDetailPage, let imgs = allImages {
            
            detailPage.pushToAllImages(images: imgs)
        }
    }
    
    override func setupView() {
        super.setupView()
        
        picturesCollectionView.register(EventPhotosCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        addSubview(picturesCollectionView)
        
        //PicturesCollectionView Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: picturesCollectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: picturesCollectionView)
    }
}
