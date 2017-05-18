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
private let CELL_OPTIONS = "CELL_OPTIONS"
private let CELL_STATUS = "CELL_STATUS"
private let CELL_HOST = "CELL_HOST"
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
        collectionView?.register(ImagesCell.self, forCellWithReuseIdentifier: CELL_IMAGES)
        collectionView?.register(OptionsCell.self, forCellWithReuseIdentifier: CELL_OPTIONS)
        collectionView?.register(StatusCell.self, forCellWithReuseIdentifier: CELL_STATUS)
        collectionView?.register(HostCell.self, forCellWithReuseIdentifier: CELL_HOST)
    }
}

extension EventDetailsPage:  UICollectionViewDelegateFlowLayout {
    
    //Mark: CollectionView Delegate/DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let eventDetails = _eventDetails {
            
            if indexPath.item == 0 {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGES, for: indexPath) as? ImagesCell {
                    
                    cell.eventDetails = eventDetails
                    
                    return cell
                }
                
            } else if indexPath.item == 1 {
        
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_FEED, for: indexPath) as? EventDetailsCell {
                    
                    cell.eventDetails = eventDetails
                    
                    return cell
                }
                
            } else if indexPath.item == 2 {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_OPTIONS, for: indexPath) as? OptionsCell {
                    
                    //cell.eventDetails = eventDetails
                    
                    return cell
                }
                
            } else if indexPath.item == 3 {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_STATUS, for: indexPath) as? StatusCell {
                    
                    cell.eventDetails = eventDetails
                    
                    return cell
                }
                
            } else if indexPath.item == 4 {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_HOST, for: indexPath) as? HostCell {
                    
                    cell.eventDetails = eventDetails
                    
                    return cell
                }
            }
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_DETAILS, for: indexPath) as? DetailsCell {
                
                cell.eventDetails = eventDetails
                
                return cell
            }
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        if indexPath.item == 0 {
            
            return CGSize(width: view.frame.width,
                          height: FEED_CELL_HEIGHT / 1.7)
            
        } else if indexPath.item == 1  {
            
            return CGSize(width: view.frame.width,
                          height: FEED_CELL_HEIGHT / 6)

        }else if indexPath.item == 2 {
            
            return CGSize(width: view.frame.width,
                          height: FEED_CELL_HEIGHT / 4)
            
        } else if indexPath.item == 3 || indexPath.item == 4 {
            
            return CGSize(width: view.frame.width,
                          height: FEED_CELL_HEIGHT / 8)
            
        } else {
            
            if let eventDescription = _eventDetails?.descriptions {
                
                let size = CGSize(width: view.frame.width, height: 1000)
                
                let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
                
                let estimatedFrame = NSString(string: eventDescription).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                
                return CGSize(width: view.frame.width,
                              height: estimatedFrame.height + 20)
                
            } else {
                
                return CGSize(width: view.frame.width,
                              height: 25)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
}
