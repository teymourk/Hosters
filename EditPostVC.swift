//
//  UpdatePostVC.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 7/25/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit

class EditPost: NSObject, UITextFieldDelegate {
    
    let dimedBackGround = UIView()
    
    let updateView:UIView = {
        let view = UIView()
            view.backgroundColor = .white
            view.layer.masksToBounds = true
            view.layer.borderWidth = 1
            view.layer.borderColor = darkGray.cgColor
        return view
    }()
    
    lazy var _postTitle:UITextField = {
        let textField = UITextField()
            textField.textAlignment = .center
            textField.font = UIFont(name: "Prompt", size: 12)
            textField.becomeFirstResponder()
            textField.delegate = self
        return textField
    }()
    
    var _seperator:UIView = {
        let view = UIView()
            view.backgroundColor = orange
        return view
    }()
    
    lazy var _done:UIButton = {
        let button = UIButton()
        button.setTitle("Update", for: UIControlState())
        button.setBackgroundImage(UIImage(named: "create-button"), for: UIControlState())
        button.setTitleColor(.white, for: UIControlState())
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.addTarget(self, action: #selector(onDone(_ :)), for: .touchUpInside)
        return button
    }()
    
    let _characterCount:UILabel = {
        let label = UILabel()
        label.text = "\(40)"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = darkGray
        return label
    }()
    
    lazy var _cancel:UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: UIControlState())
        button.setBackgroundImage(UIImage(named: "create-button"), for: UIControlState())
        button.setTitleColor(.white, for: UIControlState())
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.addTarget(self, action: #selector(handleDissMiss(_ :)), for: .touchUpInside)
        return button
    }()
    
    func showMenu(_ postTitle:String, privacy: String) {
        
        if let window = UIApplication.shared.keyWindow {
            
            dimedBackGround.backgroundColor = UIColor(white: 0, alpha: 0.5)
            dimedBackGround.frame = window.frame
            dimedBackGround.alpha = 0
            tapGesture(self, actions: "handleDissMiss:", object: dimedBackGround, numberOfTaps: 1)

            window.addSubview(dimedBackGround)
            window.addSubview(updateView)
            
            updateView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 0)
            updateView.addSubview(_postTitle)
            updateView.addSubview(_seperator)
            updateView.addSubview(_done)
            updateView.addSubview(_characterCount)
            updateView.addSubview(_cancel)
            
            updateView.addConstrainstsWithFormat("H:|-5-[v0]-5-|", views: _postTitle)
            updateView.addConstrainstsWithFormat("V:|-10-[v0]", views: _postTitle)
            
            updateView.addConstrainstsWithFormat("H:|-15-[v0]-15-|", views: _seperator)
            updateView.addConstrainstsWithFormat("V:[v0(1.5)]", views: _seperator)
            
            //Top 
            updateView.addConstraint(NSLayoutConstraint(item: _seperator, attribute: .top, relatedBy: .equal, toItem: _postTitle, attribute: .bottom, multiplier: 1, constant: 15))
        
            updateView.addConstrainstsWithFormat("H:[v0]-15-|", views: _done)
            updateView.addConstrainstsWithFormat("V:[v0]-15-|", views: _done)
            
            //CharacterCount
            
            updateView.addConstrainstsWithFormat("H:[v0]", views: _characterCount)
            updateView.addConstrainstsWithFormat("V:[v0]", views: _characterCount)
            
            //Right
            updateView.addConstraint(NSLayoutConstraint(item: _characterCount, attribute: .right, relatedBy: .equal, toItem: _done, attribute: .left, multiplier: 1, constant: -5))
            
            //CenterY
            updateView.addConstraint(NSLayoutConstraint(item: _characterCount, attribute: .centerY, relatedBy: .equal, toItem: _done, attribute: .centerY, multiplier: 1, constant: 0))
            
            updateView.addConstrainstsWithFormat("H:|-15-[v0]", views: _cancel)
            updateView.addConstrainstsWithFormat("V:[v0]-15-|", views: _cancel)
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.dimedBackGround.alpha = 1
                self.updateView.frame = CGRect(x: 0, y: 20, width: window.frame.width, height: 170)
                self._postTitle.text = postTitle
            })
        }
    }
    
    var pageNotification:PageNotifications = {
        let pn = PageNotifications()
        return pn
    }()
    
    var postKey:String? = String()
    var friendsFeed:HomePage?
    
    func onDone(_ sender:UIButton) {
        
        guard let key = postKey else {return}
        
        let postRef = FirebaseRef.database.REF_POSTS.child(key)
        
        guard let updatedTitle = _postTitle.text , updatedTitle != "" else {
            
            //Show Error
            print("Title Cant Be Empty")
            return
        }
        
        postRef.updateChildValues(["Description":updatedTitle])
        pageNotification.showNotification("Post Was Successfully Update 👀")
        handleDissMiss(sender)
        friendsFeed?.collectionView?.reloadData()
    }
    
    func handleDissMiss(_ sender: AnyObject) {
        
        if let window = UIApplication.shared.keyWindow {
            
            UIView.animate(withDuration: 0.5, animations: {
            
                self.dimedBackGround.alpha = 0
                self.updateView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 0)
                self._postTitle.removeFromSuperview()
            })
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength: Int = _postTitle.text == "" ? (_postTitle.text! as NSString).length + 1 - range.length : (_postTitle.text! as NSString).length - range.length
        
        let remainChar:Int = 40 - newLength
        
        _characterCount.text = "\(remainChar)"
        _postTitle.text = textField.text
        
        return (newLength >= 40) ? false : true
        
    }
    
    override init() {
        super.init()
    }
}
