//
//  EventDetailsHeader.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/9/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EventDetailsHeader: BaseCell {
    
    lazy var collectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .white
            cv.register(EventDetailsCell.self, forCellWithReuseIdentifier: "i")
            cv.layer.borderWidth = 0.5
            cv.layer.borderColor = darkGray.cgColor
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    var postedImages:[PostImages]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let optionsView:UIView = {
        let view = UIView()
            view.backgroundColor = .white
            view.layer.borderWidth = 0.5
            view.layer.borderColor = darkGray.cgColor
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let optionsBtn:UIButton = {
        let btn = UIButton()
            btn.setImage(UIImage(named: "c"), for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func setupView() {
        
        addSubview(optionsView)
        
        optionsView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        optionsView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        optionsView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        optionsView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        optionsView.addSubview(optionsBtn)
        
        optionsView.addConstrainstsWithFormat("H:|[v0]|", views: optionsBtn)
        optionsView.addConstrainstsWithFormat("V:|[v0]|", views: optionsBtn)
        
        addSubview(collectionView)
        
        addConstrainstsWithFormat("H:|[v0]-80-|", views: collectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: collectionView)
    }
}

extension EventDetailsHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return postedImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "i", for: indexPath) as? EventDetailsCell {
            
            if let image = postedImages?[indexPath.item] {
                
                cell.coverImage.getImagesBack(url: image.imageURL!, placeHolder: "emptyImage")
                cell.setupJustImageLayer()
            }
            
            return cell
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 80)
    }

}
