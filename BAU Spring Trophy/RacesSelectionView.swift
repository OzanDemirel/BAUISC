//
//  RacesSelectionView.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 07/04/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class RacesSelectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var racesVC: RacesVC?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    let seperatorBar: UIImageView = {
        let bar = UIImageView()
        bar.backgroundColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        return bar
    }()
    
    let seperatorBar2: UIImageView = {
        let bar = UIImageView()
        bar.backgroundColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        return bar
    }()
    
    let cellId = "racesSelectionCell"
    let selections = ["YARIŞ PROGRAMI", "ROTA KARTLARI", "YARIŞ İLANI"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(seperatorBar)
        addSubview(seperatorBar2)
        
        addSubview(collectionView)
        collectionView.register(RacesSelectionCell.self, forCellWithReuseIdentifier: cellId)
        
        addConstraint(NSLayoutConstraint(item: collectionView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithVisualFormat(format: "H:[v0(\(selections.count * 50 + (selections.count - 1) * 30))]", views: collectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.layoutIfNeeded()
        
        addConstraintsWithVisualFormat(format: "H:[v0(1)]", views: seperatorBar)
        addConstraintsWithVisualFormat(format: "V:|-12-[v0]-12-|", views: seperatorBar)
        addConstraint(NSLayoutConstraint(item: seperatorBar, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -35))
        
        addConstraintsWithVisualFormat(format: "H:[v0(1)]", views: seperatorBar2)
        addConstraintsWithVisualFormat(format: "V:|-12-[v0]-12-|", views: seperatorBar2)
        addConstraint(NSLayoutConstraint(item: seperatorBar2, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 35))
        
        collectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: false, scrollPosition: [])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        racesVC?.scrollCollectionView(indexPath: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RacesSelectionCell
        cell.name.text = selections[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
        
    }
    
}
