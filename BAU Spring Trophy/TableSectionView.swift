//
//  TableSectionView.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class TableSectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var resultsVC: ResultsVC?
    
    lazy var selectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    let seperatorBar: UIImageView = {
        let bar = UIImageView()
        bar.backgroundColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        return bar
    }()
    
    let cellId = "tableSelectionCell"
    let selections = ["GENEL SONUÇLAR", "SINIFLARA GÖRE SONUÇLAR"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(seperatorBar)
        addConstraintsWithVisualFormat(format: "H:[v0(1)]", views: seperatorBar)
        addConstraintsWithVisualFormat(format: "V:|-8-[v0]-8-|", views: seperatorBar)
        addConstraint(NSLayoutConstraint(item: seperatorBar, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        selectionView.register(TableSelectionCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(selectionView)
        addConstraintsWithVisualFormat(format: "H:|-\(frame.width / 5)-[v0]-\(frame.width / 5)-|", views: selectionView)
        addConstraintsWithVisualFormat(format: "V:|-8-[v0]-8-|", views: selectionView)
        
        selectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: false, scrollPosition: [])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        resultsVC?.scrollCollectionView(indexPath: indexPath)
        resultsVC?.contentOffset = CGFloat(indexPath.row)
        ApiService.sharedInstance.selectedCategory = indexPath.row
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TableSelectionCell
        cell.sectionTitle.text = selections[indexPath.row]
        if indexPath.row == 0 {
            cell.sectionTitle.textAlignment = .right
        } else {
            cell.sectionTitle.textAlignment = .left
        }
        if UIScreen.main.bounds.width == 320 {
            cell.sectionTitle.font = UIFont(name: "Futura-Book", size: 8)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: selectionView.frame.width / 2 - 10, height: selectionView.frame.height)
    }
    
}
