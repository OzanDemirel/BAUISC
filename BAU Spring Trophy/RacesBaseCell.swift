//
//  RacesSectionView.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class RacesBaseCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var selectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    var selectionNames = ["YARIŞ 1", "YARIŞ 2", "YARIŞ 3", "OVERALL"]
    let cellId = "racesCell"

    override func setupViews() {

        selectionView.register(RacesCell.self, forCellWithReuseIdentifier: cellId)
        
        let gapCount = 4 - selectionNames.count
        let gapFromASide = frame.width * 0.11 * CGFloat(gapCount)
        let margin = frame.width * 0.06 + gapFromASide
        
        addSubview(selectionView)
        addConstraintsWithVisualFormat(format: "H:|-\(margin)-[v0]-\(margin)-|", views: selectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: selectionView)
        
        selectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: false, scrollPosition: [])
        
        NotificationCenter.default.addObserver(self, selector: #selector(RacesBaseCell.selectFirstItemAtSection), name: NSNotification.Name("aDaySelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RacesBaseCell.selectFirstItemAtSection), name: NSNotification.Name("AnyChildAddedToView"), object: nil)
    }
    
    @objc func selectFirstItemAtSection() {
         selectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ApiService.sharedInstance.selectedRace = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RacesCell
        cell.name.text = selectionNames[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: selectionView.frame.width / CGFloat(selectionNames.count), height: selectionView.frame.height)
    }

}

class RacesBaseCellOne: RacesBaseCell {
    
    override func setupViews() {
        selectionNames = ["YARIŞ 1", "OVERALL"]
        super.setupViews()
    }
    
}

class RacesBaseCellTwo: RacesBaseCell {
    
    override func setupViews() {
        selectionNames = ["YARIŞ 1", "YARIŞ 2", "OVERALL"]
        super.setupViews()
    }
    
}

class RacesBaseCellThree: RacesBaseCell {
    
    override func setupViews() {
        selectionNames = ["YARIŞ 1", "YARIŞ 2", "YARIŞ 3", "OVERALL"]
        super.setupViews()
    }
    
}

class RacesBaseCellOverall: RacesBaseCell {
    
    override func setupViews() {
        selectionNames = ["OVERALL"]
        super.setupViews()
    }
    
}
