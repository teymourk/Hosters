//
//  Explore.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/15/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class Explore: HomePage {
    
    let Cell_ID = "Cell_ID"
    
    var nearEvents:[Events]? {
        didSet {
            collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        
        navigationController?.navigationBar.isTranslucent = false
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        setupCollectionView()
        setupNavSeperator()
        giveMeLocations()
        
        fetchNearEvents()
    }
    
    func giveMeLocations() {
        
        Facebook_NearEvents.facebookNearPlaces.findNearPalces { (locations) in
            
            for i in locations {
                
                guard let placeID = i.placeID else { return }
                
                Facebook_MyEvents.facebookFetch.loadDataFromFacebook(nearOrmeFor: "\(placeID)")
            }
        }
        
        
    }
    
    func fetchNearEvents() {
        
        let hasntHappenedPred = NSPredicate(format: "isLive = %d", 2)
        
        nearEvents = Events.FetchData(predicate: hasntHappenedPred, entity: "NearEvents")
    }
}

extension Explore {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return nearEvents?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .cyan
        
        return cell
    }
}
