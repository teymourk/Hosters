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

class HomeAudit: UICollectionViewController, UICollectionViewDelegateFlowLayout, FacebookRegisterCellDelegate {
    
    let pages:[Page] = {
        
        let firstPage = Page(imageName: "https://s-media-cache-ak0.pinimg.com/736x/2a/6f/d9/2a6fd9fb64f50158734de034e0d21462.jpg", title: "Participate in an Event", details: "You can checkin to near locations and let your friends know where you are!")
        let secondPage = Page(imageName: "http://www.foodandwine.com/fwx/sites/default/files/partner-TL-phone-photography-tips-fwx.jpg", title: "Share your moments", details: "Upload Images before and after the event to share your moments with friends")
        let thirdPage = Page(imageName: "https://lvs.luxury/wp-content/uploads/2015/05/IMG_1266Porche-event.jpg", title: "SALAMA CHETORYE", details: "Enjoy these moments")

        return [firstPage,secondPage,thirdPage]
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
        self.collectionView?.register(HomeAuditCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.collectionView?.register(FacebookRegisterCell.self, forCellWithReuseIdentifier: REGISTER_CELL)
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.alwaysBounceVertical = false
        self.collectionView?.alwaysBounceHorizontal = false
    
        setupPageController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let userID = FBSDKAccessToken.current() {
        
            if userID != nil {
                
                let tabarController = CostumeTabBar()
                self.navigationController?.pushViewController(tabarController, animated: true)
                self.navigationController?.navigationBar.isHidden = true
            }
            
        } else {
            return
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pages.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 3 {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REGISTER_CELL, for: indexPath) as? FacebookRegisterCell {
                
                cell.delegate = self
                
                return cell
            }
            
        } else {
         
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? HomeAuditCell {
            
                let pageDetails = pages[indexPath.item]
                
                cell.detail = pageDetails
                
                return cell
            }
        }

        return BaseCollectionViewCell()
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
