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

class AllEventPhotos: UICollectionViewController, OptionsViewDelegate {
    
    lazy var empty:Bool = false
    weak var timer:Timer?
    
    lazy var cellImages:[UIImage] = {
        
        let location = UIImage(named:"location")
        let date = UIImage(named:"calendar")
        let host = UIImage(named:"host")
        let details = UIImage(named:"attension")
        
        return [location!, date!, host!, details!]
    }()
    
    lazy var evenDetails:[String] = {
       
        guard let eventDetails = self._eventDetails else { return [] }
        
        let event = eventDetails.getEventDetailsFrom(eventDetails)
        
        return [event.location, "DATE", event.hosts, event.details]
    }()
    
    var _eventDetails:Events? {
        didSet {
            
            guard let eventDetails = _eventDetails else {return}
            
            setupNavBarView(details: eventDetails)
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
            timer?.fire()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer?.invalidate()
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
        
        let titileLabel = UILabel()
            titileLabel.font = UIFont(name: "Prompt", size: 15)
            titileLabel.textColor = .white
            titileLabel.textAlignment = .center
            titileLabel.text = "Event"
        
        view.addSubview(countDown)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: countDown)
        view.addConstrainstsWithFormat("V:[v0]-2-|", views: countDown)

        view.addSubview(titileLabel)
        
        view.addConstrainstsWithFormat("H:|[v0]|", views: titileLabel)
        view.addConstrainstsWithFormat("V:|-2-[v0]", views: titileLabel)
        
        startCountDown()

        self.navigationItem.titleView = view
    }
    
    
    internal func loadImages() -> [PostImages] {
        
        if let event = _eventDetails {
            return PostImages.fetchEventImages(event: event)
        }
        
        return []
    }
    
    @objc
    fileprivate func startCountDown() {
        
        if let event = _eventDetails,let startTime = event.start_time as Date?, let endTime = event.end_time as Date? {
            
            if Date() < startTime {
                
                countDown.text = "Starting: \(startTime.countDown())"
                countDown.textColor = .rgb(24, green: 201, blue: 86)
                
            } else if Date() > endTime {
                
                countDown.text = "Event Ended"
                countDown.textColor = .rgb(181, green: 24, blue: 34)
                
            } else if Date() > startTime && Date() < endTime {
                
                countDown.text = "Ending: \(endTime.countDown())"
                countDown.textColor = .rgb(181, green: 24, blue: 34)
            }
        }
    }
    
    func onOptions(_ sender: UIButton) {
        
        guard let eventDetails = _eventDetails else {return}
        
        let cameraViewController = CameraViewController()
            cameraViewController.liveEventDetails = eventDetails
        navigationController?.present(cameraViewController, animated: true, completion: nil)
    }
    
    internal func pushToAllImages(eventImages:[PostImages], selectedIndex:IndexPath) {
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        
        let controller = EventImagesCollectionView(collectionViewLayout: layout)
            controller.postedImages = eventImages
        self.present(controller, animated: false) { 
        
            controller.collectionView?.selectItem(at: selectedIndex, animated: false, scrollPosition: .centeredHorizontally)
        }
    }
}



