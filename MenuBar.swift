//
//  MenuBar.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/12/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "Cell"

class MenuBar: BaseView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var menuItems:[String]? {
        didSet{
            menuCollectionView.reloadData()
        }
    }

    var addOrPostVC:AddOrPost?
    
    lazy var menuCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = darkGray
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return menuItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? MenuBarCell {
            
            if let imagesName = menuItems?[indexPath.item] {
                
                cell.image.image = UIImage(named: imagesName)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    var horizontalBarLeftAncherContraint: NSLayoutConstraint?
    
    func setupHorizontalBarView() {
        
        let horizontalBarView = UIView()
            horizontalBarView.backgroundColor = orange
            horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAncherContraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAncherContraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let x = CGFloat((indexPath as NSIndexPath).item) * frame.width / 3
        horizontalBarLeftAncherContraint?.constant = x
    
        addOrPostVC?.scrollToMenuIndex((indexPath as NSIndexPath).item)
    }
    
    override func setupView() {
        super.setupView()
        
        self.clipsToBounds = true
        let selectedIndex = IndexPath(item: 0, section: 0)
        menuCollectionView.selectItem(at: selectedIndex, animated: false, scrollPosition: UICollectionViewScrollPosition())
                
        menuCollectionView.register(MenuBarCell.self, forCellWithReuseIdentifier: CELL_ID)
        addSubview(menuCollectionView)
        
        setupHorizontalBarView()

        //CollectionView Constraints
        addConstrainstsWithFormat("H:|[v0]|", views: menuCollectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: menuCollectionView)
        
    }
}

class MenuBarCell: BaseCell {

//    var menuLabel:UILabel = {
//        let label = UILabel()
//            label.textAlignment = .center
//            label.textColor = .white
//            label.font = UIFont(name: "NotoSans", size: 14)
//        return label
//    }()
    
    let image:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
       return image
    }()
    
    override var isHighlighted: Bool {
        didSet {
            //image.backgroundColor = isHighlighted ? orange : .white
        }
    }
    
    override var isSelected: Bool {
        didSet {
            //image.backgroundColor = isSelected ? orange : .white
        }
    }
    
    override func setupView() {
        super.setupView()
        
        addSubview(image)
        backgroundColor = darkGray
        
        //Icons Constraints
        addConstrainstsWithFormat("H:[v0(20)]", views: image)
        addConstrainstsWithFormat("V:[v0(20)]", views: image)
        
        //CenterX
        addConstraint(NSLayoutConstraint(item: image, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        //CenterY
        addConstraint(NSLayoutConstraint(item: image, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

