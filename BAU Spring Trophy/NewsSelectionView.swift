//
//  NewsSelectionView.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 12/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class NewsSelectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var flashNewsCount = 5

    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isUserInteractionEnabled = false
        addSubview(collectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: collectionView)
        addConstraintsWithVisualFormat(format: "H:[v0(\((flashNewsCount * 10) + (2 * flashNewsCount - 1)))]", views: collectionView)
        addConstraint(NSLayoutConstraint(item: collectionView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        collectionView.register(NewsSelectionCell.self, forCellWithReuseIdentifier: "newsSelectionCell")
        collectionView.selectItem(at: IndexPath(item: 0, section: 0) as IndexPath, animated: false, scrollPosition: [])
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flashNewsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsSelectionCell", for: indexPath) as! NewsSelectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
