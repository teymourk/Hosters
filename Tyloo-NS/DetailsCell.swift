//
//  DetailsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/29/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class DetailsCell: BaseCell {

    var details:String? {
        didSet {
            
            detailsTextView.text = details
        }
    }
    
    var detailsTextView:UITextView = {
        let textView = UITextView()
            textView.font = UIFont.systemFont(ofSize: 12)
            textView.isEditable = false
            textView.isSelectable = false
        return textView
    }()
    
    override func setupView() {
        
        addSubview(detailsTextView)
        
        addConstrainstsWithFormat("H:|[v0]|", views: detailsTextView)
        addConstrainstsWithFormat("V:|[v0]|", views: detailsTextView)
    }
}
