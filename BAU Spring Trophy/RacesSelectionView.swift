//
//  RacesSelectionView.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 07/04/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class RacesSelectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var selectionView: UICollectionView = {
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
        
        addSubview(selectionView)
        selectionView.register(RacesSelectionCell.self, forCellWithReuseIdentifier: cellId)
        
        addConstraintsWithVisualFormat(format: "H:|-\((frame.width - CGFloat(selections.count * 50)) / 4)-[v0]-\((frame.width - CGFloat(selections.count * 50)) / 4)-|", views: selectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: selectionView)
        selectionView.layoutIfNeeded()
        
        addConstraintsWithVisualFormat(format: "H:[v0(1)]", views: seperatorBar)
        addConstraintsWithVisualFormat(format: "V:|-8-[v0]-8-|", views: seperatorBar)
        addConstraint(NSLayoutConstraint(item: seperatorBar, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -25 - (selectionView.frame.width - CGFloat(selections.count * 50)) / CGFloat(selections.count - 1) / 2))
        
        addConstraintsWithVisualFormat(format: "H:[v0(1)]", views: seperatorBar2)
        addConstraintsWithVisualFormat(format: "V:|-8-[v0]-8-|", views: seperatorBar2)
        addConstraint(NSLayoutConstraint(item: seperatorBar2, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 25 + (selectionView.frame.width - CGFloat(selections.count * 50)) / CGFloat(selections.count - 1) / 2))
        
        selectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: false, scrollPosition: [])
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RacesSelectionCell
        cell.name.text = selections[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: frame.height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return (frame.width - CGFloat(selections.count * 50)) / CGFloat(selections.count + 1)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (selectionView.frame.width - CGFloat(selections.count * 50)) / CGFloat(selections.count - 1)
        
    }
    
}
