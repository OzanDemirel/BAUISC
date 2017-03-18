//
//  NewsScrollPages.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 12/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class NewsScrollPages: DesignableView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.isPagingEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "TrendCellBackground")
        image.contentMode = UIViewContentMode.scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor(red: 251/255, green: 173/255, blue: 24/255, alpha: 1)
        return indicator
    }()
    
    var homeVC: HomeVC?
    
    var newsCount = 0
    
    override func awakeFromNib() {
        
        addSubview(backgroundImage)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: backgroundImage)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: backgroundImage)
        
        addSubview(activityIndicator)
        addConstraintsWithVisualFormat(format: "H:[v0(30)]", views: activityIndicator)
        addConstraintsWithVisualFormat(format: "V:[v0(30)]", views: activityIndicator)
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        activityIndicator.startAnimating()
        
        collectionView.register(NewsHorizontalCell.self, forCellWithReuseIdentifier: "newsHorizontalCell")
        addSubview(collectionView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.isScrollEnabled = true
        collectionView.scrollToItem(at: IndexPath(item: 5000, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        isScrollEnabled = false
//        
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        
//        if contentOffset.x <= 0 {
//            
//            scrollRectToVisible(CGRect(x: frame.width * CGFloat(newsScrollPages.count - 2), y: frame.minY, width: frame.width, height: frame.height), animated: false)
//            homeVC?.selectItemInNewsSelection(itemIndex: newsImages.count - 3)
//            
//        } else if contentOffset.x >= frame.width * CGFloat(newsScrollPages.count - 1) {
//            
//            scrollRectToVisible(CGRect(x: frame.width, y: frame.minY, width: frame.width, height: frame.height), animated: false)
//            homeVC?.selectItemInNewsSelection(itemIndex: 0)
//            
//        } else {
//            
//            let index = contentOffset.x / frame.width
//            homeVC?.selectItemInNewsSelection(itemIndex: Int(index) - 1)
//            
//        }
//        
//        isScrollEnabled = true
//        
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkForIndex()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkForIndex()
    }

    func checkForIndex() {
        
        let index = Int(round(Double(collectionView.contentOffset.x / frame.width).truncatingRemainder(dividingBy: Double(newsCount)))) < newsCount ? Int(round(Double(collectionView.contentOffset.x / frame.width).truncatingRemainder(dividingBy: Double(newsCount)))) : 0

        homeVC?.newsSelectionView.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: [])
        
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9999
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsHorizontalCell", for: indexPath) as! NewsHorizontalCell
        cell.news = homeVC?.news?[indexPath.row % (newsCount > 4 ? 5 : newsCount)]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }

}
