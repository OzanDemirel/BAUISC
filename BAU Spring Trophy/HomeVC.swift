//
//  ViewController.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 08/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var newsScrollPages: NewsScrollPages!
    @IBOutlet weak var homeScrollView: UIScrollView!
    @IBOutlet weak var homeScrollContentView: UIView!
    @IBOutlet weak var teamsBtnView: UIImageView!
    @IBOutlet weak var resultsBtnView: UIImageView!
    @IBOutlet weak var galeryBtnView: UIImageView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var bauiscLogoView: AnimatedLogoView!
    @IBOutlet weak var trophyLogoView: AnimatedLogoView!
    @IBOutlet weak var newsSelectionView: NewsSelectionView!
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet weak var rightArrow :UIButton!
    
    var newsCollectionView: UICollectionView!
    var navigationBarBtn: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var homePageShadowView: UIImageView!
    
    var newsVC: GaleryVC!
    
    @IBOutlet weak var mainScrollViewContentWidth: NSLayoutConstraint!
    @IBOutlet weak var mainScrollViewContentHeight: NSLayoutConstraint!
    @IBOutlet weak var sideMenuWidth: NSLayoutConstraint!
    @IBOutlet weak var mainMenuWidth: NSLayoutConstraint!
    @IBOutlet weak var homeScrollContentViewHeight: NSLayoutConstraint!
    
    let sideMenuItems: [Dictionary<String, String>]! = [["Anasayfa / Home": "Home"], ["Takımlar / Teams": "Teams"] , ["Fotoğraflar / Photos": "Photos"], ["Videolar / Videos": "Videos"], ["Haberler / News": "News"], ["Sonuçlar / Results": "Results"], ["Yarışlar / Races": "Races"], ["İletişim / Contact": "Contact"], ["Sponsorlar / Sponsors": "Sponsors"]]
    
    let fakeNews: [[String: String]] = [["News1": "News1Filter"], ["News2": "News2Filter"], ["News3": "News3Filter"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        mainScrollView.delegate = self
        
        mainScrollViewContentWidth.constant = UIScreen.main.bounds.width / 3 * 5
        mainScrollViewContentHeight.constant = UIScreen.main.bounds.height
        sideMenuWidth.constant = UIScreen.main.bounds.width / 3 * 2
        mainMenuWidth.constant = UIScreen.main.bounds.width
        
        homeScrollView.layer.shouldRasterize = true
        homeScrollView.layer.rasterizationScale = UIScreen.main.scale
        mainScrollView.layer.shouldRasterize = true
        mainScrollView.layer.rasterizationScale = UIScreen.main.scale
        
        homePageShadowView = UIImageView()
        
        newsScrollPages.homeVC = self
        
    }
    
    func selectItemInNewsSelection(itemIndex: Int) {
        newsSelectionView.collectionView.selectItem(at: IndexPath(item: itemIndex, section: 0), animated: false, scrollPosition: [])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        arrangeMainScrollViewPosition(animated: false)
        configureNewsCollectionView()
        
        navigationBar.addSubview(navigationBarBtn)
        navigationBar.addConstraintsWithVisualFormat(format: "H:|-80-[v0]-0-|", views: navigationBarBtn)
        navigationBar.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: navigationBarBtn)
        navigationBarBtn.addTarget(self, action: #selector(HomeVC.navigationBarBtnPressed), for: UIControlEvents.touchUpInside)
        
        homeScrollView.isScrollEnabled = fakeNews.count > 0 ? true : false
//
        arrangeShadowView()
        
        newsVC = GaleryVC(nibName: "GaleryVC", bundle: nil)
        addChildViewController(newsVC)
        homeView.addSubview(newsVC.view)
        newsVC.didMove(toParentViewController: self)
        
        
        newsVC.view.frame = homeScrollView.frame
        newsVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: navigationBar.frame.maxY)
        newsVC.view.alpha = 0
        
        homeView.bringSubview(toFront: homePageShadowView)
 //
        trophyLogoView.startAnimation()
        bauiscLogoView.startAnimation()
        
        newsScrollPages.collectionView.scrollRectToVisible(CGRect(x: newsScrollPages.frame.width * 250, y: 0, width: newsScrollPages.frame.width, height: newsScrollPages.frame.height), animated: false)
        
    }
    
    func arrangeShadowView() {
        
        homePageShadowView.frame = CGRect(x: 0, y: navigationBar.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - navigationBar.frame.height)
        homePageShadowView.backgroundColor = UIColor.black
        homePageShadowView.alpha = 0
        homePageShadowView.isUserInteractionEnabled = false
        homeView.addSubview(homePageShadowView)
        
    }
    
    func navigationBarBtnPressed() {
        homeScrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: homeScrollView.frame.width, height: homeScrollView.frame.height), animated: true)
        
        if newsVC.view.frame.origin.x >= UIScreen.main.bounds.maxX {
            UIView.animate(withDuration: calculateAnimationDuration(startingPoint: newsVC.view.frame.origin, destinationPoint: homeScrollView.frame.origin), animations: {
                self.newsVC.view.frame.origin = self.homeScrollView.frame.origin
                self.newsVC.view.alpha = 1
            })
        } else {
            UIView.animate(withDuration: calculateAnimationDuration(startingPoint: newsVC.view.frame.origin, destinationPoint: CGPoint(x: UIScreen.main.bounds.maxX, y: self.navigationBar.frame.maxY)), animations: {
                self.newsVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: self.navigationBar.frame.maxY)
                self.newsVC.view.alpha = 0
            }, completion: { (true) in
                self.newsVC.willMove(toParentViewController: self)
                self.newsVC.view.removeFromSuperview()
                self.newsVC.removeFromParentViewController()
            })
        }
    }
    
    func calculateAnimationDuration(startingPoint: CGPoint, destinationPoint: CGPoint) -> TimeInterval {

        if abs(startingPoint.x - destinationPoint.x) >= abs(startingPoint.y - destinationPoint.y) {
            return abs(TimeInterval(startingPoint.x - destinationPoint.x)) / abs(TimeInterval((startingPoint.x - destinationPoint.x) * 1.5))
        } else {
            return abs(TimeInterval(startingPoint.y - destinationPoint.y)) / abs(TimeInterval((startingPoint.y - destinationPoint.y) * 1.5))
        }
        
    }
    
    func configureNewsCollectionView() {
        
        homeScrollContentViewHeight.constant = galeryBtnView.frame.maxY
        newsCollectionView = UICollectionView(frame: CGRect(x: 0, y: homeScrollContentViewHeight.constant, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 8 * 3 * 5), collectionViewLayout: UICollectionViewFlowLayout())
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        newsCollectionView.isScrollEnabled = false
        newsCollectionView.backgroundColor = UIColor.clear
        newsCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: "newsCell")
        newsCollectionView.allowsMultipleSelection = false
        homeScrollContentView.addSubview(newsCollectionView)
        homeScrollContentView.sendSubview(toBack: newsCollectionView)
        homeScrollContentViewHeight.constant += newsCollectionView.frame.height
        
    }
    
    func arrangeMainScrollViewPosition(animated: Bool) {
        mainScrollView.scrollRectToVisible(CGRect(x: UIScreen.main.bounds.width / 3 * 2, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), animated: animated)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        mainScrollView.isScrollEnabled = false
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        homePageShadowView.alpha = ((UIScreen.main.bounds.width / 3 * 2) - (mainScrollView.contentOffset.x)) / (UIScreen.main.bounds.width / 3 * 4)
        if homePageShadowView.alpha == 0.5 {
            homePageShadowView.isUserInteractionEnabled = true
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    
        homePageShadowView.alpha = ((UIScreen.main.bounds.width / 3 * 2) - (mainScrollView.contentOffset.x)) / (UIScreen.main.bounds.width / 3 * 4)
        if homePageShadowView.alpha == 0.5 {
            homePageShadowView.isUserInteractionEnabled = true
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        homePageShadowView.alpha = ((UIScreen.main.bounds.width / 3 * 2) - (mainScrollView.contentOffset.x)) / (UIScreen.main.bounds.width / 3 * 4)
        
        if homePageShadowView.alpha == 0.5 {
            homePageShadowView.isUserInteractionEnabled = true
        }
        
        mainScrollView.isScrollEnabled = true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = sideMenuTableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as? SideMenuCell {
            cell.setupCell(menuItem: sideMenuItems[indexPath.row])
            return cell
        }
        return SideMenuCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 9
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newsCollectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCell
        cell.customizeNewsImages(news: fakeNews[indexPath.row % 3])
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 8 * 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newsCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    @IBAction func sideMenuBtnPressed(_ sender: UIButton) {
        
        if mainScrollView.contentOffset.x <= 0 {
            arrangeMainScrollViewPosition(animated: true)
        } else {
            mainScrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), animated: true)
        }
    }
    
    @IBAction func arrowsPressed(_ sender: UIButton) {

        if sender.tag == 1 && newsScrollPages.collectionView.contentOffset.x.truncatingRemainder(dividingBy: newsScrollPages.collectionView.frame.width) == 0 {
            newsScrollPages.collectionView.scrollRectToVisible(CGRect(x: newsScrollPages.collectionView.contentOffset.x - newsScrollPages.collectionView.frame.width, y: 0, width: newsScrollPages.collectionView.frame.width, height: newsScrollPages.collectionView.frame.height), animated: true)
        } else if sender.tag == 2 && newsScrollPages.collectionView.contentOffset.x.truncatingRemainder(dividingBy: newsScrollPages.collectionView.frame.width) == 0 {
            newsScrollPages.collectionView.scrollRectToVisible(CGRect(x: newsScrollPages.collectionView.contentOffset.x + newsScrollPages.collectionView.frame.width, y: 0, width: newsScrollPages.collectionView.frame.width, height: newsScrollPages.collectionView.frame.height), animated: true)
        }
    }
    
}

