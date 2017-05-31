//
//  AllEventPhotos.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/30/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CellID"
private let GRID_ID = "Grid_ID"

class AllEventPhotos: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var postedImages:[Images]?
    
    var grid:Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pictures"
        self.navigationController?.navigationBar.isTranslucent = false
        self.collectionView?.register(AllEventPhotosCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.collectionView?.register(GridCell.self, forCellWithReuseIdentifier: GRID_ID)
        self.collectionView?.backgroundColor = .white
        self.collectionView?.backgroundColor = UIColor.rgb(231, green: 236, blue: 240)
        
        let gridListBtn = UIBarButtonItem(title: "Grid", style: .plain, target: self, action: #selector(gridList(sender :)))
        navigationItem.rightBarButtonItem = gridListBtn
    }
    
    internal func gridList(sender: UIBarButtonItem) {
        
        if let senderTitle = sender.title {
            
            if sender.title == "Grid" {
                sender.title = "List"
            } else {
                sender.title = "Grid"
            }
            
            grid = senderTitle == "Grid" ? true : false
        }
        
        collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return postedImages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if grid == false {
        
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? AllEventPhotosCell {
                
                cell.postImages = postedImages?[indexPath.item]
                return cell
            }
            
        } else {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GRID_ID, for: indexPath) as? GridCell {
                
                cell.postImages = postedImages?[indexPath.item]
                return cell
            }
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width:CGFloat = grid == true ? view.frame.width / 3 : view.frame.width
        let height:CGFloat = grid == true ? HEIGHE_IMAGE / 3 : HEIGHE_IMAGE + 20
    
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return grid == true ? 0 : 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
