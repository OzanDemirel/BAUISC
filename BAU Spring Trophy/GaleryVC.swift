//
//  GaleryVC.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 11/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class GaleryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    @IBOutlet weak var baseCollectionView: UICollectionView!
    @IBOutlet weak var selectionBarView: GaleryPageSelectionBarView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseCollectionView.delegate = self
        baseCollectionView.dataSource = self
        baseCollectionView.bounces = false
        baseCollectionView.register(PhotosBaseCell.self, forCellWithReuseIdentifier: "photosBaseCell")
        baseCollectionView.register(VideosBaseCell.self, forCellWithReuseIdentifier: "videosBaseCell")
        selectionBarView.galeryVC = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        selectionBarView.selectionView.selectItem(at: IndexPath(item: Int(round(scrollView.contentOffset.x / scrollView.frame.width)), section: 0), animated: false, scrollPosition: [])
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        selectionBarView.selectionView.selectItem(at: IndexPath(item: Int(scrollView.contentOffset.x / scrollView.frame.width), section: 0), animated: false, scrollPosition: [])
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectionBarView.selectionView.selectItem(at: IndexPath(item: Int(scrollView.contentOffset.x / scrollView.frame.width), section: 0), animated: false, scrollPosition: [])
    }
    
    func scrollCollectionView(indexPath: Int) {
        baseCollectionView.scrollToItem(at: IndexPath(item: 0, section: indexPath), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return baseCollectionView.dequeueReusableCell(withReuseIdentifier: "photosBaseCell", for: indexPath) as! PhotosBaseCell
        }
        return baseCollectionView.dequeueReusableCell(withReuseIdentifier: "videosBaseCell", for: indexPath) as! VideosBaseCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}

