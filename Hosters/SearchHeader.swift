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
            bar.backgroundColor = darkGray
            bar.tintColor = darkGray
            bar.returnKeyType = UIReturnKeyType.done
            bar.placeholder = "Search By"
            bar.delegate = self
            bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    lazy var optionCollectionView:OptionsCollectionView = {
        let collectioView = OptionsCollectionView(options: ["hashtag", "Hoster", "LC"])
            collectioView.searchHeader = self
            collectioView.translatesAutoresizingMaskIntoConstraints = false
        return collectioView
    }()
    
    weak var homePage:HomePage?
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .clear
        
        setupSearchBarLayout()
    }
    
    fileprivate func setupSearchBarLayout() {
        
        addSubview(searBar)
        
        searBar.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        searBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        searBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(optionCollectionView)
        
        optionCollectionView.topAnchor.constraint(equalTo: searBar.bottomAnchor).isActive = true
        optionCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        optionCollectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else { return }
        
        print(searchText)
    }
}

class searchResultController: UITableViewController {

    let Cell_ID = "Cell_ID"
    
    var selectedIndex:IndexPath?
    
    lazy var searchBar:UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundColor = .clear
        bar.tintColor = darkGray
        bar.returnKeyType = UIReturnKeyType.done
        bar.delegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Cell_ID)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell_ID, for: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
}

extension searchResultController: UISearchBarDelegate {
    
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
