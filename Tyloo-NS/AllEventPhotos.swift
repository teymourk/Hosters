//
//  AllEventPhotos.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 5/30/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

private let CELL_ID = "CellID"
private let GRID_ID = "GRID_ID"
private let HEADER_ID = "HEADER_ID"
private let SEGMENT_CELL = "SEGMENT_CELL"

class AllEventPhotos: UICollectionViewController {
    
    var empty:Bool = false
    
    var _eventDetails:Events? {
        didSet {
            
            guard let eventDetails = _eventDetails else {return}
            
            setupNavBarView(details: eventDetails)
            
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
    
    let navBarSeperator:UIView = {
        let view = UIView()
            view.backgroundColor = orange
        return view
    }()
    
    let uploadProgressView:UploadProgressView = {
        let up = UploadProgressView()
        return up
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Event"
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.collectionView?.register(EventDetailsHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_ID)
        self.collectionView?.register(EventDetailsCell.self, forCellWithReuseIdentifier: CELL_ID)
        self.collectionView?.backgroundColor = .white
        self.collectionView?.backgroundColor = UIColor.rgb(231, green: 236, blue: 240)
        
        view.addSubview(navBarSeperator)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: navBarSeperator)
        view.addConstrainstsWithFormat("V:|[v0(2)]", views: navBarSeperator)
    }
    
    let countDown:UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "Prompt", size: 12)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupNavBarView(details:Events?) {
        
        let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
            view.backgroundColor = .clear
        
        view.addSubview(countDown)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: countDown)
        view.addConstrainstsWithFormat("V:[v0]-2-|", views: countDown)
        
        startCountDown()
        
        self.navigationItem.titleView = view
    }
    
    func startCountDown() {
        
        if let event = _eventDetails, let isLive = event.isLive, let eventTime = event.start_time, let endTime = event.end_time {
            
            switch isLive {
            case 1:
                countDown.text = "Starting: \(eventTime.countDown())"
                countDown.textColor = .rgb(24, green: 201, blue: 86)
                break
            case 2:
                countDown.text = "Event Ended"
                countDown.textColor = .rgb(181, green: 24, blue: 34)
                break
            case 3:
                countDown.text = "Ending: \(endTime.countDown())"
                countDown.textColor = .rgb(181, green: 24, blue: 34)
                break
                
            default: break
                
            }
        }
    }
}

