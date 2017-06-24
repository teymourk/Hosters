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
            bar.backgroundColor = .clear
            bar.tintColor = darkGray
            bar.returnKeyType = UIReturnKeyType.done
            bar.delegate = self
            bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    var optionCollectionView:OptionsCollectionView = {
        let collectioView = OptionsCollectionView(options: ["#", "Name", "Host", "Event"])
            collectioView.translatesAutoresizingMaskIntoConstraints = false
        return collectioView
    }()
    
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
        
        optionCollectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        optionCollectionView.topAnchor.constraint(equalTo: searBar.bottomAnchor, constant: 5).isActive = true
        optionCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            
            return
        }
        
        //Do Soemthing With Text
    }
}
