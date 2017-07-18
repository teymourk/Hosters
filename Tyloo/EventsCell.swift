//
//  EventsCell.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 4/25/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

protocol EventCellDelegate: class {
    
    func handleOnGuest(sender: UIButton)
}

class EventsCell: BaseCollectionViewCell {
    
    weak var _eventDetails:Events? {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    let headerView:HeaderView = {
        let hd = HeaderView()
            hd.translatesAutoresizingMaskIntoConstraints = false
        return hd
    }()
    
    let coverImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.masksToBounds = true
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let title:UILabel = {
        let label = UILabel()
            label.textColor = .black
            label.font = UIFont(name: "NotoSans-Bold", size: 11)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let location:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "NotoSans", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var guestCountsButton:UIButton = {
        let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont(name: "NotoSans", size: 12)
            button.addTarget(self, action: #selector(handleOnGuests(sender:)), for: .touchUpInside)
            button.setTitleColor(buttonColor, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var delegate:EventCellDelegate?
    
    internal func updateUI() {
        
        guard let eventDetails = _eventDetails else { return }
        
        let event = eventDetails.getEventDetailsFrom(eventDetails)
         
        coverImage.getImagesBack(url: event.coverURL, placeHolder: "emptyCover")
        title.text = event.title
        location.text = event.location
        
        let color = event.guestListEnabled == true ? buttonColor : darkGray

        guestCountsButton.setTitleColor(color, for: .normal)
        guestCountsButton.setTitle(event.guestList, for: .normal)
    }

    override func setupView() {
        
        backgroundColor = .white
        
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.cornerRadius = 1
        layer.borderColor = UIColor.lightGray.cgColor
        handleCellAnimation()
        setShadow()
        setupViewHeader()
        handleLayout()
    }
        
    internal func handleOnGuests(sender: UIButton) {
        
        if delegate != nil {
            delegate?.handleOnGuest(sender: sender)
        }
    }
}
