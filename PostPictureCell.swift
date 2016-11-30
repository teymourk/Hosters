//
//  PostPictureCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 8/31/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData

private let CELL_ID = "CELL_ID"
private let HEADER_ID = "HEADER_ID"

class PostPictureCell: BaseCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {

    var addOrPostVC:AddOrPost?
    
    lazy var postPicturesForActivitiesCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .white
            cv.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
            cv.scrollIndicatorInsets = UIEdgeInsetsMake(30, 0, 0, 0)
            cv.register(Active_Ended_Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_ID)
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath) as? Active_Ended_Header {
            
            if indexPath.section == 0 {
                header.text.text = "Active"
                
            } else {
                header.text.text = "Offline"
            }
            
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: frame.width, height: 45)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return fetchController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fetchController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? ActivePostsCell {
            
            let activePost = fetchController.object(at: indexPath)
            
            cell.activePosts = activePost
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width, height: FEED_CELL_HEIGHT/4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post = fetchController.object(at: indexPath)
            
        let cameraVC = AddImages()
            cameraVC.activePostsDetails = post
        let navController = UINavigationController(rootViewController: cameraVC)
        addOrPostVC?.present(navController, animated: true, completion: nil)
    }
    
    lazy var fetchController:NSFetchedResultsController<Posts> = {
        let fetch:NSFetchRequest<Posts> = Posts.fetchRequest()
            fetch.sortDescriptors = [NSSortDescriptor(key: "timePosted", ascending: false)]
            fetch.predicate = NSPredicate(format: "poster = %@", FirebaseRef.database.currentUser.key)
        let frc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: "status", cacheName: nil)
            frc.delegate = self
        return frc
    }()
    
    let noPostView:NoPostsView = {
        let NP = NoPostsView()
        return NP
    }()
    
    func setupNoPostView(text:String) {
        
        addSubview(noPostView)
        
        addConstrainstsWithFormat("H:|[v0]|", views: noPostView)
        addConstrainstsWithFormat("V:|[v0]|", views: noPostView)
        
        noPostView.emptyPostLabel.text = text
    }
    
    
    func handleFetchingPosts() {
        
        do {
            try fetchController.performFetch()
            
        } catch let err {
            print(err)
        }
    }
    
    var blockOperation = [BlockOperation]()
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        postPicturesForActivitiesCV.performBatchUpdates({
            
            for operation in self.blockOperation {
                operation.start()
            }
            
        }, completion: nil)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let indexPath = newIndexPath {
            
            switch type {
                
            case .insert:
                
                blockOperation.append(BlockOperation(block: { 
                    
                    self.postPicturesForActivitiesCV.insertItems(at: [indexPath])
                    
                    if self.noPostView.isDescendant(of: self) {
                        self.noPostView.removeFromSuperview()
                    }
                }))
                
                break
            case .delete:
                postPicturesForActivitiesCV.deleteItems(at: [indexPath])
                break

            default: break
            }
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        handleFetchingPosts()
    }
    
    override func setupView() {
        super.setupView()
        
        postPicturesForActivitiesCV.register(ActivePostsCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        addSubview(postPicturesForActivitiesCV)
        
        addConstrainstsWithFormat("H:|[v0]|", views: postPicturesForActivitiesCV)
        addConstrainstsWithFormat("V:|[v0]|", views: postPicturesForActivitiesCV)
    }
}
