//
//  UsersProfile.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 8/16/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase
import CoreData

private let headerId = "headerId"

class UsersProfile: HomePage, UserProfileHeaderDelegate {
    
    var profileDetails:Users? {
        didSet {
            
            guard let username = profileDetails?.username else {return}
            
            self.title = username
            
            if let userKey = profileDetails?.userKey {
                
                if userKey != FirebaseRef.database.currentUser.key {
                    
                    inviteContact.isHidden = true
                    emptyPostLabel.text = "\(username) hase no posts 🙄"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = false
        collectionView?.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        setupNavBar()
        refreshController.removeFromSuperview()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? UserProfileHeaderCell {
            
            header.profileDetails = profileDetails
            header.delegate = self
            
            return header
        }
        
        return UICollectionReusableView()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 20,
                            left: 0,
                            bottom: 0,
                            right: 0)
    }
    
    func setupNavBar() {
        
        let settings = UIBarButtonItem(image: UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal),
                                       style: .plain,
                                       target: self,
                                       action: #selector(onSettings(_ :)))
        
        navigationItem.rightBarButtonItem = settings
    }
    
    func onSettings() {
        
        let settingsVC = Settings()
        let navController = UINavigationController(rootViewController: settingsVC)
        navigationController?.present(navController, animated: true, completion: nil)
    }
        
    override func fetchPostsFromData() {
        
        guard let userKey = profileDetails?.userKey else {return}
        
        do {
            
            let fetchRequest: NSFetchRequest<Posts> = Posts.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timePosted", ascending: false)]
                fetchRequest.predicate = NSPredicate(format: "users.userKey = %@", userKey)
            
            let imageRequest: NSFetchRequest<PostImages> = PostImages.fetchRequest()
            
            try self.userPosts = context.fetch(fetchRequest)
            let imagesArray = try(context.fetch(imageRequest))
            
            if let posts = userPosts {
                
                for post in posts {
                    
                    guard let postKey = post.postKey else {return}
                    
                    imageRequest.predicate = NSPredicate(format: "postKey = %@", postKey)
                    imageRequest.sortDescriptors = [NSSortDescriptor(key: "timePosted", ascending: false)]
                    
                    self.handleSettingExistinPostImages(posts, allImages: imagesArray)
                
                }
            }
            
        } catch let err{
            print(err)
        }
    }
    
    func onSettings(_ sender:UIBarButtonItem) {
        
        let settingsVC = Settings()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func onTrackers(_ sender: UIButton) {
        
        guard let userKey = profileDetails?.userKey else {return}
        
        let trackers = Trackers()
        trackers.title = "Trackers"
        trackers.key = userKey
        navigationController?.pushViewController(trackers, animated: true)
    }
    
    func onTracking(_ sender: UIButton) {
        
        guard let userKey = profileDetails?.userKey else {return}
        
        let tracking = Tracking()
            tracking.title = "Tracking"
            tracking.key = userKey
        navigationController?.pushViewController(tracking, animated: true)
    }
    
    func onEditProfile(_ sender: UIButton) {
        
        if sender.title(for: UIControlState()) == "Edit Profile" {
            
            let editProfileVC = EditUserProfile()
                editProfileVC.currentUserProfile = profileDetails
            let navController = UINavigationController(rootViewController: editProfileVC)
            navigationController?.present(navController, animated: true, completion: nil)
            
        } else {
            
            if sender.title(for: UIControlState()) == "Tracking" {
                
                sender.setTitle("Track", for: UIControlState())
                sender.backgroundColor = .gray
                
            } else {
                
                sender.setTitle("Tracking", for: UIControlState())
                sender.backgroundColor = orange
            }
        }
    }
}
