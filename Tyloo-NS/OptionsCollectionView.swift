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
        
        optionCollectionView.register(SearchOptionsCell.self, forCellWithReuseIdentifier: Cell_ID)
        
        backgroundColor = .clear
        
        addSubview(optionCollectionView)
        
        addConstrainstsWithFormat("H:|[v0]|", views: optionCollectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: optionCollectionView)
    }
}

extension OptionsCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return searchOptions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell_ID, for: indexPath) as? SearchOptionsCell {
            
            let searchLabel = searchOptions?[indexPath.item]
            
            cell.searchLabel.text = searchLabel
            
            return cell
        }
        
        return BaseCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 50,
                      height: 50)
    }
}

class SearchOptionsCell: BaseCollectionViewCell {

    var searchLabel:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "Prompt", size: 12)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {

        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.cornerRadius = 25
        backgroundColor = randomColor()
        
        addSubview(searchLabel)
        
        searchLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    fileprivate func randomColor() -> UIColor {
        
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
