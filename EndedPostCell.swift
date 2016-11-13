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
    
    //Duplicated. Will Fix later
    override func handleFetchingActivePosts() {
        
        do {
            let request:NSFetchRequest<Posts> = Posts.fetchRequest()
                request.predicate = NSPredicate(format: "status = %@", NSNumber(booleanLiteral: false))
            
            try self.activePosts = context.fetch(request)
            
        } catch let err {
            print(err)

        }
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
