//
//  DetailsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/29/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit


class DetailsCell: BaseCollectionViewCell {
    
    var detailsTextView:UITextView = {
        let textView = UITextView()
            textView.font = UIFont(name: "NotoSans", size: 12)
            textView.isEditable = false
            textView.isSelectable = false
            textView.isScrollEnabled = false
        return textView
    }()
    
    override func setupView() {
        
        addSubview(detailsTextView)
        
        addConstrainstsWithFormat("H:|-15-[v0]|", views: detailsTextView)
        addConstrainstsWithFormat("V:|[v0]|", views: detailsTextView)
    }
}
