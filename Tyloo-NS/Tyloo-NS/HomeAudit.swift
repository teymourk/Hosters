//
//  Home.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 11/6/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "Cell"
private let signUpLogInCell = "signUp-LogInCell"

struct Page {
    
    let imageName:String
    let title:String
    let details:String
}

class HomeAudit: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let pages:[Page] = {
        
        let firstPage = Page(imageName: "http://www.opulentgroups.com/Event-management.png", title: "Check In With Friends", details: "You can checkin to near locations and let your friends know where you are!")
        let secondPage = Page(imageName: "https://www.thembegroup.com/wp-content/uploads/2016/06/Corporate-Events.jpg", title: "Share your moments", details: "Upload Images before and after the event to share your moments with friends")
        let thirdPage = Page(imageName: "https://lvs.luxury/wp-content/uploads/2015/05/IMG_1266Porche-event.jpg", title: "SALAMA CHETORYE", details: "man khoobam")
        let fourthPage = Page(imageName: "http://www.creativeapplications.net/wp-content/uploads/2010/10/Festival_Ferry-Corsten_FlashBack-Paradiso-credits-tillate.com00.jpg", title: "NEMIDOOONAM", details: "SALAM CHETORY PESAR")
        
        return [firstPage,secondPage,thirdPage,fourthPage]
    }()
    
    lazy var pageController:UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = orange
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 5
        return pageControl
    }()
    
    override func didMoveToSuperview() {
        
        self.backgroundColor = .white
        self.register(picturesCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
        self.alwaysBounceVertical = false
        self.alwaysBounceHorizontal = false
        self.delegate = self
        self.dataSource = self
        
        setupPageController()
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! picturesCell
        
        let pageDetails = pages[indexPath.item]
        
        cell.detail = pageDetails
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.frame.size
    }
    
    func setupPageController() {
        
        addSubview(pageController)
        
        //PageController Constraint
        pageController.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pageController.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pageController.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
}

class picturesCell:BaseCell {
    
    var detail: Page? {
        
        didSet {
            
            guard let page = detail else {return}
            
            let imgURL = page.imageName
            instructionImage.getImagesBack(url: imgURL, placeHolder: "emptyImage")
            
            makeTextAttribute(page: page)
            
        }
    }
    
    let seperator:UIView = {
        let view = UIView()
        view.backgroundColor = orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var instructionImage:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .green
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
        super.setupView()
        
        addSubview(instructionImage)
        addSubview(instructionText)
        addSubview(seperator)
        
        let imageHeight = self.frame.height / 1.35
        
        //ImageConstraints
        instructionImage.topAnchor.constraint(equalTo: self.topAnchor, constant: -22).isActive = true
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
