//
//  SearchHeader.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/21/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class SearchHeader: BaseCollectionViewCell, UISearchBarDelegate {
    
    lazy var searBar:UISearchBar = {
        let bar = UISearchBar()
            bar.backgroundColor = .white
            bar.tintColor = .white
            bar.scopeButtonTitles = ["#", "Name", "Host"]
            bar.selectedScopeButtonIndex = 0
            bar.showsScopeBar = true
            bar.returnKeyType = UIReturnKeyType.done
            bar.delegate = self
        return bar
    }()

    override func setupView() {
        super.setupView()
        
        setupSearchBarLayout()
    }
    
    fileprivate func setupSearchBarLayout() {
    
        addSubview(searBar)
        
        addConstrainstsWithFormat("H:|[v0]|", views: searBar)
        addConstrainstsWithFormat("V:|[v0]|", views: searBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            
            return
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        switch selectedScope {
        case 0:
            searchBar.placeholder = "Search by Event #"
            searchBar.text = "#"
            break
        case 1:
            searchBar.placeholder = "Searh by Event Name"
            searchBar.text = ""
            break
        case 2:
            searchBar.placeholder = "Search by Host"
            searchBar.text = ""
            break
        default: break
            
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        resignFirstResponder()
        return true
    }
    
    
}
