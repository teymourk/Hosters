//
//  EventPage.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/26/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_FEED = "Cell_FEED"
private let CELL_DETAILS = "Cell_Details"
private let CELL_IMAGES = "CELL_IMAGES"
private let HEADER_ID = "HEADER_ID"

class EventDetailsPage: UICollectionViewController {
    
    var _eventDetails:Events? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Event Page"

        navigationController?.navigationBar.isTranslucent = false
        collectionView?.backgroundColor = .white
        collectionView?.register(EventDetailsCell.self, forCellWithReuseIdentifier: CELL_FEED)
        collectionView?.register(DetailsCell.self, forCellWithReuseIdentifier: CELL_DETAILS)
        collectionView?.register(DetailedPageImagesCell.self, forCellWithReuseIdentifier: CELL_IMAGES)
    }
}

extension EventDetailsPage:  UICollectionViewDelegateFlowLayout {
    
    //Mark: CollectionView Delegate/DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.item == 0 {

            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_FEED, for: indexPath) as? EventDetailsCell {
            
                if let eventDetails = _eventDetails {
                    
                    cell._eventDetails = eventDetails
                }
                
                return cell
            }
        } else if indexPath.item == 1 {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_DETAILS, for: indexPath) as? DetailsCell {
    
                return cell
            }
            
        } else if indexPath.item == 2 {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_DETAILS, for: indexPath) as? DetailedPageImagesCell {
                
                return cell
            }
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 1 {
            
            return CGSize(width: view.frame.height,
                          height: 40)
        
        } else if indexPath.item == 2 {
            
            return CGSize(width: view.frame.height,
                          height: 100)
        }
        
        return CGSize(width: view.frame.width,
                      height: FEED_CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
}

