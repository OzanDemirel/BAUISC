//
//  RacesSectionView.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class RacesSectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var selectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    let selectionNames = ["YARIŞ 1", "YARIŞ 2", "YARIŞ 3", "OVERALL"]
    var selectionCount = 1
    let cellId = "racesCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        selectionView.register(RacesCell.self, forCellWithReuseIdentifier: cellId)
        
        let gapCount = selectionNames.count - selectionCount
        let gapFromASide = frame.width * 0.11 * CGFloat(gapCount)
        let margin = frame.width * 0.06 + gapFromASide
        
        addSubview(selectionView)
        addConstraintsWithVisualFormat(format: "H:|-\(margin)-[v0]-\(margin)-|", views: selectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: selectionView)
        
        selectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: false, scrollPosition: [])
        
    }
    
    func setupViews() {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionCount
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
        return CGSize(width: selectionView.frame.width / CGFloat(selectionCount), height: selectionView.frame.height)
    }

}
