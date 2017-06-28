//
//  SearchHeader.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/21/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class SearchHeader: BaseCollectionViewCell, UISearchBarDelegate {
    
    var selectedIndex:IndexPath? {
        didSet {
            
            switch selectedIndex?.item {
            case 0?:
                searchBar.placeholder = "Search By #"
                break
            case 1?:
                searchBar.placeholder = "Search By Name"
                break
            case 2?:
                searchBar.placeholder = "Search By Host"
                break
            case 3?:
                searchBar.placeholder = "Search By Event"
                break
            case 4?:
                searchBar.placeholder = "Search By Location"
                break
            default: break
            }
            
        }
    }
    
    lazy var searchBar:UISearchBar = {
        let bar = UISearchBar()
            bar.backgroundColor = .clear
            bar.tintColor = darkGray
            bar.returnKeyType = UIReturnKeyType.done
            bar.delegate = self
            bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    lazy var optionCollectionView:OptionsCollectionView = {
        let collectioView = OptionsCollectionView(options: ["#", "Name", "Host", "Event", "Location"])
            collectioView.translatesAutoresizingMaskIntoConstraints = false
            collectioView.searchHeader = self
        return collectioView
    }()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .clear
        
        setupSearchBarLayout()
    }
    
    fileprivate func setupSearchBarLayout() {
    
        addSubview(searchBar)
        
        searchBar.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true

        addSubview(optionCollectionView)
        
        optionCollectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        optionCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5).isActive = true
        optionCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty, let selectedIndex = selectedIndex?.item else {
            
            return
        }
        
        switch selectedIndex {
        case 0:
            print("Filter By #")
            break
        case 1:
            print("Filter By Name")
            break
        case 2:
            print("Filter By Host")
            break
        case 3:
            print("Filter By Event")
            break
        case 4:
            print("Filter By Location")
            break
        default: break
        }
        
        //Do Soemthing With Text
    }
}
