//
//  DaysSectionView.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class DaysSectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var resultsVC: ResultsVC?
    
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
    
    let sections = ["GÜN 1", "GÜN 2", "GÜN 3", "GÜN 4", "GÜN 5", "GÜN 6", "TOTAL"]
    
    let cellId = "daysCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(selectionView)
        selectionView.register(DaysCell.self, forCellWithReuseIdentifier: cellId)
        addConstraintsWithVisualFormat(format: "H:|-\((frame.width - CGFloat(sections.count * 30)) / 8)-[v0]-\((frame.width - CGFloat(sections.count * 30)) / 8)-|", views: selectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: selectionView)
        
        selectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        
        NotificationCenter.default.addObserver(self, selector: #selector(DaysSectionView.setSelection), name: NSNotification.Name("AnyChildAddedToView"), object: nil)
        
    }
    
    func setSelection() {
        selectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        resultsVC?.scrollToSectionInRaces(indexPath: indexPath.row)
        ApiService.sharedInstance.selectedDay = indexPath.row
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DaysCell
        cell.name.text = sections[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (frame.width - CGFloat(sections.count * 30)) / 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (selectionView.frame.width - CGFloat(sections.count * 30)) / 6
        
    }
    
}
