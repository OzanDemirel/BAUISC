//
//  NewsVC.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 10/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class NewsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    var homeVC: HomeVC?
    
    let fakeNews: [[String: String]] = [["News1": "News1Filter"], ["News2": "News2Filter"], ["News3": "News3Filter"]]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        newsCollectionView.backgroundColor = UIColor.clear
        newsCollectionView.bounces = false
        newsCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: "newsCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if ApiService.sharedInstance.news.count > 0 {
            newsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.centeredVertically, animated: false)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(newsChanged), name: NSNotification.Name("newsChanged"), object: nil)
    }
    
    @objc func newsChanged() {
        newsCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ApiService.sharedInstance.news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newsCollectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCell
        cell.news = ApiService.sharedInstance.news[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newsCollectionView.deselectItem(at: indexPath, animated: true)
        
        homeVC?.addNewsContentViewToView(news: ApiService.sharedInstance.news[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2 - 0.5, height: UIScreen.main.bounds.width / 2 - 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

}
