//
//  NoPostsView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 11/18/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class NoPostsView: UIView {
    
    lazy var emptyPostLabel:UILabel = {
        let label = UILabel()
            label.textColor = darkGray
            label.font = UIFont(name: "Prompt", size: 17)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var inviteContact:UIButton = {
        let button = UIButton()
            button.setTitle("Invite Your Contact", for: UIControlState())
            button.titleLabel?.font = UIFont(name: "NotoSans", size: 20)
            button.setTitleColor(.white, for: UIControlState())
            button.setBackgroundImage(UIImage(named: "signin"), for: UIControlState())
            button.addTarget(self, action: #selector(self.onInviteContact(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let pageNotification:PageNotifications = {
        let pn = PageNotifications()
        return pn
    }()
    
    func onInviteContact(_ sender:UIButton) {
        
        pageNotification.showNotification("WORKING ON THE FEATURE")
    }

    override func didMoveToSuperview() {
        
        addSubview(emptyPostLabel)
        //addSubview(inviteContact)
        
        emptyPostLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emptyPostLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
//        inviteContact.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        inviteContact.topAnchor.constraint(equalTo: emptyPostLabel.bottomAnchor, constant: 10).isActive = true
    }
}
