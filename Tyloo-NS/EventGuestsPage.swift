//
//  EventGuestsCollection.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/30/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "GUEST_CELL"

class EventGuestsPage: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var event_id:String? = String()
    var users:[Users]? = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.register(GuestsCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.collectionView?.backgroundColor = .white
        
        fetchGuestUsers()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return users?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? GuestsCell {
            
            if let users = users?[indexPath.item] {
                
                cell.users = users
            }
    
            return cell
        }
    
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width,
                      height: 60)
    }
    
    internal func fetchGuestUsers() {
        
        guard let eventId = event_id else {return}
        
        Events.fetchGuestlist(eventId: eventId, type: "attending") { (userDic) in
            
            let userObj = Users(dictionary: userDic)
            
            DispatchQueue.main.async {
                self.users?.append(userObj)
                self.collectionView?.reloadData()
            }
        }
    }
}
