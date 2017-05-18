//
//  Explore.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/15/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class Explore: HomePage, UISearchResultsUpdating {

    lazy var searchController:UISearchController = {
        let sb = UISearchController(searchResultsController: nil)
            sb.searchResultsUpdater = self
            sb.dimsBackgroundDuringPresentation = false
            sb.definesPresentationContext = true
            sb.hidesNavigationBarDuringPresentation = false
            sb.searchBar.sizeToFit()
       return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.addSubview(searchController.searchBar)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            
            print(searchText)
        }
    }
}
