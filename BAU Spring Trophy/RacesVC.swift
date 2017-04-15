//
//  RacesVC.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 07/04/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class RacesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectionView: RacesSelectionView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let routeCardsCellId = "routeCardsContainer"
    let raceAnnouncementCellId = "raceAnnouncementContainer"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = false
        collectionView.register(RouteCardsContainer.self, forCellWithReuseIdentifier: routeCardsCellId)
        collectionView.register(RaceAnnouncementContainer.self, forCellWithReuseIdentifier: raceAnnouncementCellId)
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.centeredVertically, animated: false)
//        tableSectionView.selectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
//        
//        daysSectionView.resultsVC = self
//        tableSectionView.resultsVC = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        resultsTableContainer.reloadData()
        
    }
    
//    func scrollToSectionInRaces(indexPath: Int) {
//        racesSectionView.selectionView.scrollToItem(at: IndexPath(item: 0, section: indexPath), at: [], animated: true)
//        NotificationCenter.default.post(name: NSNotification.Name("aDaySelected"), object: nil)
//    }
    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        tableSectionView.selectionView.selectItem(at: IndexPath(item: Int(scrollView.contentOffset.x / scrollView.frame.width), section: 0), animated: false, scrollPosition: [])
//        
//    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        tableSectionView.selectionView.selectItem(at: IndexPath(item: Int(round(scrollView.contentOffset.x / scrollView.frame.width)), section: 0), animated: false, scrollPosition: [])
//    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        tableSectionView.selectionView.selectItem(at: IndexPath(item: Int(scrollView.contentOffset.x / scrollView.frame.width), section: 0), animated: false, scrollPosition: [])
//    }
    
//    func scrollCollectionView(indexPath: IndexPath) {
//        resultsTableContainer.scrollRectToVisible(CGRect(x: resultsTableContainer.frame.maxX * CGFloat(indexPath.row), y: resultsTableContainer.frame.minY, width: resultsTableContainer.frame.width, height: resultsTableContainer.frame.height), animated: true)
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: routeCardsCellId, for: indexPath) as! RouteCardsContainer
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: raceAnnouncementCellId, for: indexPath) as! RaceAnnouncementContainer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

}
