//
//  HomeAuditCell.swift
//  Tyloo
//
//  Created by Kiarash Teymoury on 7/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class HomeAuditCell:BaseCollectionViewCell {
    
    var detail: Page? {
        
        didSet {
            
            guard let page = detail else {return}
            
            let imgURL = page.imageName
            instructionImage.getImagesBack(url: imgURL, placeHolder: "emptyImage")
            
            makeTextAttribute(page: page)
        }
    }
    
    var instructionImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var instructionText:UITextView = {
        let text = UITextView()
            text.textColor = .black
            text.isEditable = false
            text.isSelectable = false
            text.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
            text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    fileprivate func makeTextAttribute(page:Page) {
        
        let color = UIColor(white: 0.2, alpha: 1)
        
        let attributeText = NSMutableAttributedString(string: page.title, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium), NSForegroundColorAttributeName: color])
        
        let detailAttribute = NSAttributedString(string: "\n\n\(page.details)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: color])
        
        attributeText.append(detailAttribute)
        
        let textlength = attributeText.string.characters.count
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let range = NSRange(location: 0, length: textlength)
        
        attributeText.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: range)
        
        instructionText.attributedText = attributeText
    }
    
    override func setupView() {
        
        addSubview(instructionImage)
        addSubview(instructionText)
        addSubview(seperator)
        
        let imageHeight = self.frame.height / 1.35
        
        //ImageConstraints
        instructionImage.topAnchor.constraint(equalTo: self.topAnchor, constant:-40).isActive = true
        instructionImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        instructionImage.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        
        //TextConstraints
        instructionText.topAnchor.constraint(equalTo: instructionImage.bottomAnchor).isActive = true
        instructionText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        instructionText.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        instructionText.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        //SeperatorConstraints
        seperator.bottomAnchor.constraint(equalTo: instructionImage.bottomAnchor).isActive = true
        seperator.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        seperator.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
}
