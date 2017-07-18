//
//  SearchUsersView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/12/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CELL"

class SearchUsersVC: UITableViewController, UISearchResultsUpdating {
    
    var searchedUsers:[Users]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var allUsers:[Users]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    lazy var searchBar:UISearchController = {
        let search = UISearchController(searchResultsController: nil)
            search.searchResultsUpdater = self
            search.searchBar.placeholder = "Search For Users"
            search.hidesNavigationBarDuringPresentation = false
            search.dimsBackgroundDuringPresentation = false
            search.searchBar.sizeToFit()
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.85, alpha: 1)
        view.backgroundColor = .whiteColor()
        navigationController?.navigationBar.translucent = false
        
        tableView.registerClass(UsersCells.self, forCellReuseIdentifier: CELL_ID)
        tableView.tableHeaderView = searchBar.searchBar
        tableView.separatorColor = darkGray
        tableView.clearFooter()
        
        getAllUsers()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBar.active {
             return searchedUsers?.count ?? 0
            
        } else {
            return allUsers?.count ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID, forIndexPath: indexPath) as! UsersCells
        
        if searchBar.active {
            cell.users = searchedUsers![indexPath.row]
            
        } else {
            cell.users = allUsers![indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    //Mark: - SearchBarDelegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    
        let searchBarTxt = searchController.searchBar.text?.lowercaseString
    
        if !searchBarTxt!.isEmpty {
            self.searchedUsers = allUsers?.filter({($0.username?.containsString(searchBarTxt!))!})
        } else {
            self.searchedUsers = allUsers
        }
    }
    
    func getAllUsers() {
        
        FirebaseRef.Fb.REF_USERS.observeEventType(.Value, withBlock: {
            snapshot in
            
            Users.getUsersDataFromFB(snapshot.value, completion: { (users) in
                
                self.allUsers = users
       
            })
        })
    }
}