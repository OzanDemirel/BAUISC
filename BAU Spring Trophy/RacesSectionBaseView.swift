//
//  RacesSectionBaseView.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class RacesSectionBaseView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var selectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.isPagingEnabled = true
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    let cellId = ["racesBaseCellOne", "racesBaseCellTwo", "racesBaseCellThree", "racesBaseCellOverall"]
    
    let selectionNames = [["YARIŞ 1", "YARIŞ 2", "YARIŞ 3", "OVERALL"], ["YARIŞ 1", "OVERALL"], ["YARIŞ 1", "YARIŞ 2", "YARIŞ 3", "OVERALL"], ["YARIŞ 1", "YARIŞ 2", "YARIŞ 3", "OVERALL"], ["YARIŞ 1", "OVERALL"], ["YARIŞ 1", "YARIŞ 2", "YARIŞ 3", "OVERALL"], ["OVERALL"]]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionView.register(RacesBaseCellOne.self, forCellWithReuseIdentifier: cellId[0])
        selectionView.register(RacesBaseCellTwo.self, forCellWithReuseIdentifier: cellId[1])
        selectionView.register(RacesBaseCellThree.self, forCellWithReuseIdentifier: cellId[2])
        selectionView.register(RacesBaseCellOverall.self, forCellWithReuseIdentifier: cellId[3])
        
        addSubview(selectionView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: selectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: selectionView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RacesSectionBaseView.setSelection), name: NSNotification.Name("AnyChildAddedToView"), object: nil)
        
    }
    
    func setSelection() {
        selectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.centeredVertically, animated: false)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if selectionNames[indexPath.section].count == 2 {
            cell = selectionView.dequeueReusableCell(withReuseIdentifier: cellId[0], for: indexPath) as! RacesBaseCellOne
        } else if selectionNames[indexPath.section].count == 3 {
            cell = selectionView.dequeueReusableCell(withReuseIdentifier: cellId[1], for: indexPath) as! RacesBaseCellTwo
        } else if selectionNames[indexPath.section].count == 4 {
            cell = selectionView.dequeueReusableCell(withReuseIdentifier: cellId[2], for: indexPath) as! RacesBaseCellThree
        } else if selectionNames[indexPath.section].count == 1 {
            cell = selectionView.dequeueReusableCell(withReuseIdentifier: cellId[3], for: indexPath) as! RacesBaseCellOverall
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }

    
}
