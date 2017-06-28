//
//  EventImagesCollectionView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/24/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EventImagesCollectionView: UICollectionViewController {

    let CELL_ID = "Cell_ID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(imagesCell.self, forCellWithReuseIdentifier: CELL_ID)
        collectionView?.alwaysBounceVertical = false
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = .white
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeDown))
            swipeRecognizer.direction = .down
        
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    var postedImages:[PostImages]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    @objc
    private func onSwipeDown(swipe: UIPanGestureRecognizer) {
        
        print("Swipe Down")
    }
}

extension EventImagesCollectionView: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return postedImages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? imagesCell {
            
            if let imagesObj = postedImages?[indexPath.item].imageURL {
 
                cell.image.getImagesBack(url: imagesObj, placeHolder: "emptyImage")
            }
            return cell
        }
        
        return BaseCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width,
                      height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == (postedImages?.count)! - 1 {
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            let nextIndex = indexPath.item + 1
            let nextIndexPath = IndexPath(item: nextIndex, section: 0)
            
            self.collectionView?.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
}


class imagesCell:BaseCollectionViewCell {
    
    let image:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func setupView() {
        
        addSubview(image)
        
        addConstrainstsWithFormat("H:|[v0]|", views: image)
        addConstrainstsWithFormat("V:|[v0]|", views: image)
    }
}
