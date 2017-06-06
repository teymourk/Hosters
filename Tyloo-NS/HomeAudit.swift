//
//  Home.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 11/6/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import FBSDKLoginKit

private let CELL_ID = "Cell"
private let REGISTER_CELL = "REGISTER_CELL"

struct Page {
    
    let imageName:String
    let title:String
    let details:String
}

class HomeAudit: UICollectionViewController, UICollectionViewDelegateFlowLayout, RegisterCellDelegate {
    
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
            pageControl.numberOfPages = self.pages.count + 1
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = .white
        self.collectionView?.register(picturesCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.collectionView?.register(RegisterCell.self, forCellWithReuseIdentifier: REGISTER_CELL)
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.alwaysBounceVertical = false
        self.collectionView?.alwaysBounceHorizontal = false
    
        setupPageController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            
            let tabarController = CostumeTabBar()
            self.navigationController?.pushViewController(tabarController, animated: true)
            self.navigationController?.navigationBar.isHidden = true
            
        } else {
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pages.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 4 {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REGISTER_CELL, for: indexPath) as? RegisterCell {
                
                cell.delegate = self
                
                return cell
            }
            
        } else {
         
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? picturesCell {
            
                let pageDetails = pages[indexPath.item]
                
                cell.detail = pageDetails
                
                return cell
            }
        }

        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return view.frame.size
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageController.currentPage = Int(pageNumber)
    }
    
    func setupPageController() {
        
        view.addSubview(pageController)
        
        //PageController Constraint
        pageController.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        pageController.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pageController.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func onFacebookLogin(sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()

        facebookLogin.logIn(withReadPermissions: ["email", "user_events"], from: self) { (result, error) in

            if error != nil {

                return

            } else if result?.isCancelled == true {
                print("Process FOR FACEBOOK was cancelled")

            } else {
                print("LOGGED IN TO FACEBOOK SUCCESSFULLY")
                let completeFacebookRegister = CompleteFacebookRegister()
                let navController = UINavigationController(rootViewController: completeFacebookRegister)
                self.navigationController?.present(navController, animated: true, completion: nil)
                
            }
        }
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
