//
//  SearchUsersView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/12/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit


import UIKit

private let CELL_ID = "CELL_ID"

class SearchUsers: UITableViewController, UISearchResultsUpdating {
    
    var searchedUsers:[Users]? {
        didSet {
            setupTimer()
        }
    }
    
    var allUsers:[Users]? {
        didSet{
            setupTimer()
        }
    }
    
    func setupTimer() {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleReloading), userInfo: nil, repeats: false)
    }
    
    var timer:Timer?
    
    func handleReloading() {
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        tableView.register(UsersCells.self, forCellReuseIdentifier: CELL_ID)
        tableView.tableHeaderView = searchBar.searchBar
        tableView.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0)
        tableView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        tableView.rowHeight = 70
        tableView.clearFooter()
        
        getAllUsers()
    }
    
    lazy var emptyText:UILabel = {
        let label = UILabel()
            label.textColor = darkGray
            label.font = UIFont(name: "Prompt", size: 17)
            label.text = "No Friends ☹️"
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var searchBar:UISearchController = {
        let sb = UISearchController(searchResultsController: nil)
            sb.searchResultsUpdater = self
            sb.dimsBackgroundDuringPresentation = false
            sb.definesPresentationContext = true
            sb.hidesNavigationBarDuringPresentation = false
            sb.searchBar.sizeToFit()
        return sb
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBar.isActive {
            return searchedUsers?.count ?? 0
            
        } else {
            return allUsers?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! UsersCells
        
        if let users = allUsers?[(indexPath as NSIndexPath).item] {
            
            if let userKey = users.userKey {
                
                if searchBar.isActive {
                    cell.users = searchedUsers![(indexPath as NSIndexPath).row]
                    cell.searchUsersVC = self
                    cell._follow_following.tag = (indexPath as NSIndexPath).item
                    cell._follow_following.handleFinidinTrackersForUser(userKey)
                    
                } else {
                    
                    cell.users = allUsers![(indexPath as NSIndexPath).row]
                    cell.searchUsersVC = self
                    cell._follow_following.tag = (indexPath as NSIndexPath).item
                    cell._follow_following.handleFinidinTrackersForUser(userKey)
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let usersProfileVc = UsersProfile(collectionViewLayout: UICollectionViewFlowLayout())
        
        if searchBar.isActive {
            
            let user = searchedUsers![(indexPath as NSIndexPath).item]
            usersProfileVc.profileDetails = user
            
        } else {
            
            let user = allUsers![(indexPath as NSIndexPath).item]
            usersProfileVc.profileDetails = user
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(usersProfileVc, animated: true)
    }
    
    //Mark: - SearchBarDelegate
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBarTxt = searchController.searchBar.text?.lowercased()
        
        if !searchBarTxt!.isEmpty {
            self.searchedUsers = allUsers?.filter({($0.username?.lowercased().contains(searchBarTxt!))!})
        } else {
            self.searchedUsers = allUsers
        }
    }
    
    
    func handleErrorWhenNoUsers() {
        
        view.addSubview(emptyText)
        
        emptyText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func getAllUsers() {
        
        FirebaseRef.database.REF_USERS.observeSingleEvent(of: .value, with: {
            snapshot in
        
            if let snapData = snapshot.value {
             
                Users.getUsersDataFromFB(snapData as AnyObject, completion: { (users) in
                    
                    self.allUsers = users
                })
            }
        })
    }
}
