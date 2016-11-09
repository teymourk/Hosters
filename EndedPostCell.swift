//
//  EndedPostCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 8/31/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EndedPostCell: PostPictureCell {
    
    //Duplicated. Will Fix later
    override func handleFetchingActivePosts() {
        
        Posts.getFeedPosts(UIRefreshControl()) { (posts, nil) in
            
            let currentUserUID = FirebaseRef.database.currentUser.key
            
            let currentUserPostsFilter = posts.filter({$0.poster == currentUserUID})
            
            //Get Active Posts
            let activePostFilter = currentUserPostsFilter.filter({$0.statusLight == false})
            
            if activePostFilter.count != 0 {
                self.activePosts = activePostFilter
                self.emptyText.removeFromSuperview()
                
            } else{
                self.handleSettingEmptyTextWhenNoPosts()
            }
            
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
