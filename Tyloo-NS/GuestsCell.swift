//
//  GuestsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/26/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CELL_ID"

class GuestsAttending: BaseCell {
    
    var event_id:String? {
        didSet {
            
            if let id = event_id {
                
                fetchGuestUsers(eventId: id, type: "attending")
            }
        }
    }
    
    var users:[Users]? {
        didSet {
            
            eventCollectionView.reloadData()
        }
    }
    
    lazy var eventCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .white
            cv.register(GuestsCell.self, forCellWithReuseIdentifier: CELL_ID)
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    var homePage:HomePage?
    
    override func setupView() {
        
        addSubview(eventCollectionView)
        
        addConstrainstsWithFormat("H:|[v0]|", views: eventCollectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: eventCollectionView)
    }
    
    internal func fetchGuestUsers(eventId:String, type:String) {
        
        Events.fetchGuestlist(eventId: eventId, type: type) { (users) in
            
            if !users.isEmpty {
            
                self.users = users
            }
        }
    }
}

extension GuestsAttending: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Mark: CollectionView Delegate/DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return users?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? GuestsCell {
            
            if let usersObj = users?[indexPath.item] {
                
                cell.users = usersObj
            }
            
            return cell
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width,
                      height: 50)
    }
}


class GuestsDeclined: GuestsAttending {
    
}

class GuestsMaybe: GuestsAttending {
    

}


class GuestsCell: BaseCell {

    var users:Users? {
        
        didSet {
            
            guard let userInfo = users else {return}
            
            if let profileURL = userInfo.profile_pricture {
                
                profile_image.getImagesBack(url: profileURL, placeHolder: "Profile")
            }
            
            if let profileName = userInfo.profile_name {
                
                profile_name.text = profileName
            }
        }
    }
    
    var profile_image:UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 20
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var profile_name:UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var emojiLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "✅"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var seperator:UIView = {
        let seperator = UIView()
        seperator.backgroundColor = .lightGray
        seperator.translatesAutoresizingMaskIntoConstraints = false
        return seperator
    }()
    
    override func setupView() {
        
        addSubview(profile_image)
        
        addConstrainstsWithFormat("H:|-10-[v0(40)]", views: profile_image)
        addConstrainstsWithFormat("V:[v0(40)]", views: profile_image)
        
        profile_image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(profile_name)
        
        profile_name.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        profile_name.leftAnchor.constraint(equalTo: profile_image.rightAnchor, constant: 10).isActive = true
        profile_name.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(emojiLabel)
        
        emojiLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(seperator)
        
        seperator.leftAnchor.constraint(equalTo: profile_name.leftAnchor).isActive = true
        seperator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
