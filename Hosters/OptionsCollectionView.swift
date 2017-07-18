//
//  OptionsCollectionView.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/22/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class OptionsCollectionView: BaseView {
    
    let Cell_ID = "Cell_ID"
    
    var searchOptions:[String]? {
        didSet {
            optionCollectionView.reloadData()
        }
    }
    
    weak var searchHeader:SearchHeader?
    
    init(options:[String]) {
        super.init(frame: .zero)
        
        self.searchOptions = options
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var optionCollectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
    
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .clear
            cv.contentInset.left = 10
            cv.scrollIndicatorInsets.left = 10
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()

    override func setupView() {
        
        backgroundColor = .clear
        
        optionCollectionView.register(SearchOptionsCell.self, forCellWithReuseIdentifier: Cell_ID)
        
        addSubview(optionCollectionView)
        
        addConstrainstsWithFormat("H:|[v0]|", views: optionCollectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: optionCollectionView)
    }
}
