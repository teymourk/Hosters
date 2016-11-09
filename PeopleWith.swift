//
//  peopleWith.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/18/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "Cell"

class peopleWith: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var taggedUsersArray:[Users]? {
        didSet{
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleReloading), userInfo: nil, repeats: false)
        }
    }
    
    var timer:Timer?
    
    func handleReloading() {
        
        peopleWith.reloadData()
    }

    lazy var peopleWith:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsetsMake(14, -14, 0, 0)
            layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .clear
            cv.alwaysBounceVertical = false
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return taggedUsersArray?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! PeopleWithCell
        
        cell.taggedUsers = taggedUsersArray![(indexPath as NSIndexPath).item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -30
    }
    
    override func setupView() {
        super.setupView()
        
    
        addSubview(peopleWith)
    
        //peopleWithConstraints
        addConstrainstsWithFormat("H:|[v0]|", views: peopleWith)
        addConstrainstsWithFormat("V:|[v0]|", views: peopleWith)
        
        self.peopleWith.register(PeopleWithCell.self, forCellWithReuseIdentifier: CELL_ID)
    }
}
