//
//  FollowersVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/15/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class FollowersVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Followers"
        navigationController?.navigationBar.translucent = false

    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        
        return cell
    }
}
