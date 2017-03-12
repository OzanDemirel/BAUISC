//
//  NewsScrollPages.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 12/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class NewsScrollPages: UIScrollView, UIScrollViewDelegate {
    
    var newsImages: [UIImage]!
    var newsScrollPages: [UIImageView]!
    
    var homeVC: HomeVC?
    
    override func awakeFromNib() {
        delegate = self
        downloadNews()
        arrangeNewsScrollPages(newsCount: newsImages.count)
        scrollRectToVisible(CGRect(x: frame.width, y: frame.minY, width: frame.width, height: frame.height), animated: false)
        
    }
    
    func downloadNews() {
        
        newsImages = [UIImage]()
        
        //        for _ in 0 ... 4 {
        //
        //            newsImages.append(UIImage(named: "haber")!)
        //
        //        }
        
        newsImages.append(UIImage(named: "ScrollViewNewsFilter")!)
        newsImages.append(UIImage(named: "ScrollViewNewsFilter")!)
        newsImages.append(UIImage(named: "ScrollViewNewsFilter")!)
        newsImages.append(UIImage(named: "ScrollViewNewsFilter")!)
        newsImages.append(UIImage(named: "ScrollViewNewsFilter")!)
        newsImages.append(UIImage(named: "ScrollViewNewsFilter")!)
        newsImages.append(UIImage(named: "ScrollViewNewsFilter")!)
        
    }
    
    func arrangeNewsScrollPages(newsCount: Int) {
        
        newsScrollPages = [UIImageView]()
        
        contentSize = CGSize(width: frame.width * CGFloat(newsCount), height: frame.height)
        
        for i in 0 ..< newsCount {
            
            let news = UIImageView(frame: CGRect(x: frame.width * CGFloat(i), y: frame.minY, width: frame.width, height: frame.height))
            news.contentMode = UIViewContentMode.scaleAspectFill
            news.clipsToBounds = true
            addSubview(news)
            newsScrollPages.append(news)
            
        }
        
        applyNewsToView()
        
        
        
    }
    
    func applyNewsToView() {
        
        for i in 0 ..< newsScrollPages.count {
            
            newsScrollPages[i].image = newsImages[i]
            newsScrollPages[i].highlightedImage = UIImage(named: "ScrollViewNews")
            
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        isScrollEnabled = false
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if contentOffset.x <= 0 {
            
            scrollRectToVisible(CGRect(x: frame.width * CGFloat(newsScrollPages.count - 2), y: frame.minY, width: frame.width, height: frame.height), animated: false)
            homeVC?.selectItemInNewsSelection(itemIndex: newsImages.count - 3)
            
        } else if contentOffset.x >= frame.width * CGFloat(newsScrollPages.count - 1) {
            
            scrollRectToVisible(CGRect(x: frame.width, y: frame.minY, width: frame.width, height: frame.height), animated: false)
            homeVC?.selectItemInNewsSelection(itemIndex: 0)
            
        } else {
            
            let index = contentOffset.x / frame.width
            homeVC?.selectItemInNewsSelection(itemIndex: Int(index) - 1)
            
        }
        
        isScrollEnabled = true
        
    }
    
}
