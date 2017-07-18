//
//  NotificationsVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/13/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class NotificationsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.translucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        return cell
    }
}
