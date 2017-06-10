//
//  EventDetailsHeader.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/9/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

struct Images {
    
    let img:String
}

class EventDetailsHeader: BaseCell {
    
    lazy var collectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .white
            cv.register(EventDetailsCell.self, forCellWithReuseIdentifier: "i")
            cv.delegate = self
            cv.dataSource = self
        return cv
    }()
    
    var postedImages:[Images]? {
        
        let image1 = Images(img: "https://firebasestorage.googleapis.com/v0/b/tyloo-5bcf5.appspot.com/o/288293611629956%2F6826BA69-91E6-4491-AC77-A96E28D46FEC.png?alt=media&token=ac440d2a-9317-4f68-8bf9-2f0748905696")
        let image2 = Images(img: "https://firebasestorage.googleapis.com/v0/b/tyloo-5bcf5.appspot.com/o/728991830611993%2FA2EDB055-FD13-4E2D-84E1-C078ADEB9157.png?alt=media&token=015da72c-c16a-4a87-b45c-65e3f4a2ffbb")
        let image3 = Images(img: "https://firebasestorage.googleapis.com/v0/b/tyloo-5bcf5.appspot.com/o/728991830611993%2F46AE4340-8B23-4DF0-8780-39C60A9E7C18.png?alt=media&token=2f68f3a5-7a73-4729-bba0-28cea99a988c")
        let image4 = Images(img: "https://i.ytimg.com/vi/ZTWzEShwsJQ/maxresdefault.jpg")
        
        let image5 = Images(img: "http://mikeposnerhits.com/wp-content/uploads/2014/06/OSU-DamJam2014-05312014-2.jpg")
        
        let image6 = Images(img: "https://s.aolcdn.com/dims-shared/dims3/GLOB/crop/2094x1309+0+57/resize/1400x875!/format/jpg/quality/85/http://hss-prod.hss.aol.com/hss/storage/midas/8cf7e00a4df3ebee6ff77100a6ce06c5/203138988/484533465.jpg")
        
        let image7 = Images(img: "http://www.billboard.com/files/media/drake-performance-sept-04-billboard-1548.jpg")
        
        let image8 = Images(img: "https://firebasestorage.googleapis.com/v0/b/tyloo-5bcf5.appspot.com/o/161954997675468%2F87A9707E-39DB-45A3-A627-6BD0AB9A4A89.png?alt=media&token=065c5160-92ae-4b1f-acdb-62d22f195a38")
        
        return [image1,image2,image3,image4,image5,image6,image7,image8]
    }
    
    let optionsView:UIView = {
        let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let optionsBtn:UIButton = {
        let btn = UIButton()
            btn.setImage(UIImage(named: "c"), for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func setupView() {
        
        addSubview(optionsView)
        
        optionsView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        optionsView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        optionsView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        optionsView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        optionsView.addSubview(optionsBtn)
        
        optionsView.addConstrainstsWithFormat("H:|[v0]|", views: optionsBtn)
        optionsView.addConstrainstsWithFormat("V:|[v0]|", views: optionsBtn)
        
        addSubview(collectionView)
        
        addConstrainstsWithFormat("H:|[v0]-80-|", views: collectionView)
        addConstrainstsWithFormat("V:|[v0]|", views: collectionView)
    }
}

extension EventDetailsHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return postedImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "i", for: indexPath) as? EventDetailsCell {
            
            let image = postedImages?[indexPath.item]
            
            cell.coverImage.getImagesBack(url: (image?.img)!, placeHolder: "emptyImage")
            
            return cell
        }
        
        return BaseCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 80)
    }

}
