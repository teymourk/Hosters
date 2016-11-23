//
//  EndedPostCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 8/31/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData

class EndedPostCell: PostPictureCell {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let posterPredicate = NSPredicate(format: "poster = %@", FirebaseRef.database.currentUser.key)
        let statusPredicate = NSPredicate(format: "status = %@", NSNumber(booleanLiteral: false))
        
        fetchController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [posterPredicate,statusPredicate])
        
        handleFetchingPosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let post = activePosts?[(indexPath as NSIndexPath).item] {
            
            let photoLibraryVC = PhotoLibrary()
                photoLibraryVC.postKey = post.postKey
            let navController = UINavigationController(rootViewController: photoLibraryVC)
            addOrPostVC?.present(navController, animated: true, completion: nil)
        }
    }
}
