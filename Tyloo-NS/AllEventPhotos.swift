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
private let HEADER_ID = "HEADER_ID"

class AllEventPhotos: UICollectionViewController {
    
    var _eventDetails:Events?
    
    var postedImages:[Images]?
    
    var grid:Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pictures"
        self.navigationController?.navigationBar.isTranslucent = false
        self.collectionView?.register(AllEventPhotosCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.collectionView?.register(GridCell.self, forCellWithReuseIdentifier: GRID_ID)
        collectionView?.register(EventDetailsHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_ID)
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
}
