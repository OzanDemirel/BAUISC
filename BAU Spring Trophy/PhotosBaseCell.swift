//
//  PhotosCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 11/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class PhotosBaseCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = UIColor.clear
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(PhotosCell.self, forCellWithReuseIdentifier: "photosCell")
        return cv
    }()
    
    let fakeNews: [[String: String]] = [["News1": "News1Filter"], ["News2": "News2Filter"], ["News3": "News3Filter"]]
    
    override func setupViews() {
        addSubview(collectionView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: collectionView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotosBaseCell.arrangeCellPositions), name: NSNotification.Name("AnyChildAddedToView"), object: nil)

    }
    
    func arrangeCellPositions() {
        //collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.centeredVertically, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let image = UIImage(named: fakeNews[indexPath.row].keys.first!) {
         
             NotificationCenter.default.post(name: NSNotification.Name("didSelectAnImage"), object: nil, userInfo: ["image": image])
            
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath) as! PhotosCell
        cell.customizeNewsImages(news: fakeNews[indexPath.row % 3])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2 - 0.5, height: frame.width / 3 - 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
