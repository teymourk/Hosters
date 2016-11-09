//
//  TagFriends.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 8/18/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "cell"

class TagFriends: SearchUsers {
    
    var taggedUsers = [String:Bool]()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let user = allUsers?[(indexPath as NSIndexPath).item], let userKey = user.userKey {
         
            if cell?.accessoryType == .checkmark {
                cell?.accessoryType = .none
                taggedUsers.removeValue(forKey: userKey)
                
            } else {
                
                cell?.accessoryType = .checkmark
                taggedUsers[userKey] = true
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! UsersCells
        cell._follow_following.removeFromSuperview()
        
        if let user = allUsers?[(indexPath as NSIndexPath).item] {
            
            cell.users = user
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tag Friends"
        
        setupNavBar()
        tableView.register(UsersCells.self, forCellReuseIdentifier: CELL_ID)
    }
    
    var createPost:CreatePostCell?
    
    func setupNavBar() {
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onCancel(_ :)))
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onDone(_ :)))
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = done
    }
    
    override func getAllUsers() {
    
        let userKey = FirebaseRef.database.currentUser.key
            
        Users.getFriendsFromFB(userKey, friends: "Tracking") { (users) in
                
            self.allUsers = users
        }
    }
    
    func onCancel(_ sneder:UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func onDone(_ sender:UIButton) {
        
        self.dismiss(animated: true) {
            
            self.createPost?.taggedFriends = self.taggedUsers
            self.createPost?.handleGettingTaggedUsersFromFirebase()
            self.createPost?.setupPeopleTaggedView()
            self.createPost?.handleChangingTagFriendsBtn()
        }
    }
}
