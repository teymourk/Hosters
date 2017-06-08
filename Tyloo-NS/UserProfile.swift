//
//  UserProfile.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/26/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import FBSDKLoginKit

private let CELL_FEED = "Cell_FEED"
private let Header_ID = "Header_ID"

class UserProfile: HomePage {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Header_ID)
    }
    
    override func setupLive() {}
    override func setupCollectionViewLayout() {}
    
    internal func fetchUserEvents(cell:HomeCell) {
        
        var myEventArray:[Events] = [Events]()
        
        if let eventDic = self.eventsDictionary, let userID = FBSDKAccessToken.current().userID {
            
            for(_, value) in eventDic {
                
                for i in value {
                    
                    if i.owner_id == userID {
                        
                        DispatchQueue.main.async {
                            
                            myEventArray.append(i)
                            myEventArray.sort(by: { (event1, event2) -> Bool in
                                
                                if let event1Time = event1.start_time, let event2Time = event2.start_time {
                                    
                                    return event1Time > event2Time
                                }
                                
                                return Bool()
                            })
                            
                            cell.eventsCV.events = myEventArray
                        }
                    }
                }
            }
        }
    }
}


extension UserProfile {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if indexPath.item == 0 {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_FEED, for: indexPath) as? HomeCell {
                
                cell.categoryLabel.text = "My Events 👀"
                cell.eventsCV.userProfile = self
                
                fetchUserEvents(cell: cell)
                
                return cell
            }
        }
        
        return BaseCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
            
            return CGSize(width: view.frame.width,
                          height: FEED_CELL_HEIGHT)
        }
    
        return CGSize(width: view.frame.width,
                      height: 40)
    }
    
    //Mark: - HeaderDelegate
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        if let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header_ID, for: indexPath) as? ProfileHeader {
            
            return profileHeader
        }
        
        return BaseCell()
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width,
                      height: FEED_CELL_HEIGHT * 0.45)
    }
}
