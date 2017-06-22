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

class UserProfile: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionView?.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Header_ID)
    }
}


//extension UserProfile {
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//     
//        return 1
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    
//        if indexPath.item == 0 {
//            
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_FEED, for: indexPath) as? HomeCell {
//                
//                cell.categoryLabel.text = "My Events 👀"
//                cell.eventsCV.homePage = self
//                
//                return cell
//            }
//        }
//        
//        return BaseCollectionViewCell()
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        if indexPath.item == 0 {
//            
//            return CGSize(width: view.frame.width,
//                          height: FEED_CELL_HEIGHT)
//        }
//    
//        return CGSize(width: view.frame.width,
//                      height: 40)
//    }
//}
