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
                
                fetchFilteredUsers(userKey: userKey)
                setupNavBar(userKey: userKey)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = false
        collectionView?.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        tabBarController?.tabBar.isHidden = false
    
        fetchPostsFromData()
    }
    
    fileprivate func fetchFilteredUsers(userKey: String) {
        
        let keyPredicate = NSPredicate(format: "poster = %@", userKey)
        fetchController.fetchRequest.predicate = keyPredicate
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
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 20,
                            left: 0, bottom: 0, right: 0)
    }
    
    func setupNavBar(userKey:String) {
        
        var rightButton:UIBarButtonItem?
        
        if userKey != FirebaseRef.database.currentUser.key {
         
            rightButton = UIBarButtonItem(title: "...",
                                          style: .plain,
                                          target: self,
                                          action: #selector(onSettings(_ :)))
            
        } else {
            
            let image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
            
            rightButton = UIBarButtonItem(image: image,
                                          style: .plain,
                                          target: self,
                                          action: #selector(onSettings(_ :)))
        }
        
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    
    func onSettings(_ sender:UIBarButtonItem) {
        
        if sender.title == "..." {
            return
        }
        
        let settingsVC = Settings()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func onTrackers(_ sender: UIButton) {
        
        guard let userKey = profileDetails?.followers else {return}
        
        if let followers = userKey.allObjects as? [Followers] {
            
            for follower in followers {
                
                let trackers = Trackers()
                    trackers.key = follower.userKey
                    trackers.title = "Followers"
                
                navigationController?.pushViewController(trackers, animated: true)
            }
        }
    }
    
    func onTracking(_ sender: UIButton) {
        
        guard let userKey = profileDetails?.following else {return}
        
        if let followings = userKey.allObjects as? [Following] {
        
            for following in followings {
                
                let tracking = Tracking()
                tracking.title = "Follwoing"
                tracking.key = following.userKey
            
                navigationController?.pushViewController(tracking, animated: true)
            }
        }
    }
    
    func onEditProfile(_ sender: UIButton) {
        
        if sender.title(for: UIControlState()) == "Edit Profile" {
            
            let editProfileVC = EditUserProfile()
                editProfileVC.currentUserProfile = profileDetails
            let navController = UINavigationController(rootViewController: editProfileVC)
            navigationController?.present(navController, animated: true, completion: nil)
            
        } else {
            
            if sender.title(for: UIControlState()) == "Following" {
                
                sender.setTitle("Follow", for: UIControlState())
                sender.backgroundColor = .gray
                
            } else {
                
                sender.setTitle("Following", for: UIControlState())
                sender.backgroundColor = orange
            }
        }
    }
}
