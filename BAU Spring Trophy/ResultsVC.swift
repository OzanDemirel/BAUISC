//
//  ResultsVC.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class ResultsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var daysSectionView: DaysSectionView!
    @IBOutlet weak var racesSectionView: RacesSectionBaseView!
    @IBOutlet weak var tableSectionView: TableSectionView!
    @IBOutlet weak var resultsTableContainer: UICollectionView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let classCellId = "classResultsContainer"
    let generalCellId = "generalResultsContainer"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
        resultsTableContainer.delegate = self
        resultsTableContainer.dataSource = self
        resultsTableContainer.register(GeneralResultsContainer.self, forCellWithReuseIdentifier: generalCellId)
        resultsTableContainer.register(ClassResultsContainer.self, forCellWithReuseIdentifier: classCellId)
        
        daysSectionView.resultsVC = self
        tableSectionView.resultsVC = self
    }
    
    func scrollToSectionInRaces(indexPath: Int) {
        racesSectionView.selectionView.scrollToItem(at: IndexPath(item: 0, section: indexPath), at: [], animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("aDaySelected"), object: nil)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        tableSectionView.selectionView.selectItem(at: IndexPath(item: Int(scrollView.contentOffset.x / scrollView.frame.width), section: 0), animated: false, scrollPosition: [])
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tableSectionView.selectionView.selectItem(at: IndexPath(item: Int(scrollView.contentOffset.x / scrollView.frame.width), section: 0), animated: false, scrollPosition: [])
    }
    
    func scrollCollectionView(indexPath: IndexPath) {
        resultsTableContainer.scrollRectToVisible(CGRect(x: resultsTableContainer.frame.maxX * CGFloat(indexPath.row), y: resultsTableContainer.frame.minY, width: resultsTableContainer.frame.width, height: resultsTableContainer.frame.height), animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return resultsTableContainer.dequeueReusableCell(withReuseIdentifier: generalCellId, for: indexPath) as! GeneralResultsContainer
        }
        return resultsTableContainer.dequeueReusableCell(withReuseIdentifier: classCellId, for: indexPath) as! ClassResultsContainer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

}
