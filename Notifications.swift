//
//  MessagesVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/18/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CellID"

class Notifications: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        
        // Register cell classes
        self.collectionView!.register(MessagesCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.collectionView?.backgroundColor = .white
        self.collectionView?.alwaysBounceVertical = true
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 50)
    }
}

class MessagesCell: BaseCell {
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = orange
    }
}

