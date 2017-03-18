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
    @IBOutlet weak var rightArrow: UIButton!
    
    @IBOutlet weak var mainScrollViewContentWidth: NSLayoutConstraint!
    @IBOutlet weak var mainScrollViewContentHeight: NSLayoutConstraint!
    @IBOutlet weak var sideMenuWidth: NSLayoutConstraint!
    @IBOutlet weak var mainMenuWidth: NSLayoutConstraint!
    @IBOutlet weak var homeScrollContentViewHeight: NSLayoutConstraint!
    
    var teamsTapGesture: UITapGestureRecognizer!
    
    var homePageShadowView: UIImageView!
    
    var newsCollectionView: UICollectionView!
    var navigationBarBtn: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var childs: [UIViewController]!
    
    var teamsVC: TeamsVC!
    var teamInfoVC: TeamInfoVC!
    
    var newsVC: NewsVC!
    
    var galeryVC: GaleryVC!
    
    var resultsVC: ResultsVC!
    
    var news: [News]?
    
    var teams: [Team]?
    
    var postNotifUserInfo: [String: Int]!
    
    let sideMenuItems: [Dictionary<String, String>]! = [["Anasayfa / Home": "Home"], ["Takımlar / Teams": "Teams"] , ["Fotoğraflar / Photos": "Photos"], ["Videolar / Videos": "Videos"], ["Haberler / News": "News"], ["Sonuçlar / Results": "Results"], ["Yarışlar / Races": "Races"], ["İletişim / Contact": "Contact"], ["Sponsorlar / Sponsors": "Sponsors"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        fetchNews()
        
        arrangeMainScrollViewPosition(animated: false)
        
        navigationBar.addSubview(navigationBarBtn)
        navigationBar.addConstraintsWithVisualFormat(format: "H:|-80-[v0]-0-|", views: navigationBarBtn)
        navigationBar.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: navigationBarBtn)
        navigationBarBtn.addTarget(self, action: #selector(HomeVC.navigationBarBtnPressed), for: UIControlEvents.touchUpInside)
        
        homeScrollView.isScrollEnabled = news != nil ? ((news?.count)! > 0) : false
        
        arrangeShadowView()
        
        arrangeViews()
        
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
            self.trophyLogoView.startAnimation()
            self.bauiscLogoView.startAnimation()
        })
        
        teamsTapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeVC.teamsTapGestureActive(sender:)))
        teamsTapGesture.cancelsTouchesInView = false
        homeScrollView.addGestureRecognizer(teamsTapGesture)
        
    }
    
    func fetchNews() {
        
        ApiService.sharedInstance.fetchNews { (news: [News]) in
            self.news = news
            self.setTrendNews(news: news)
        }
        
    }

    func setTrendNews(news: [News]) {

        if news.count > 0 {
            newsScrollPages.newsCount = news.count > 4 ? 5 : news.count
        }
        if news.count > 1 {
            leftArrow.isEnabled = true
            rightArrow.isEnabled = true
        }
        newsScrollPages.collectionView.scrollToItem(at: IndexPath(item: 5000, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        newsSelectionView.collectionView.reloadData()
        newsScrollPages.collectionView.reloadData()
        if news.count > 5 {
            configureNewsCollectionView()
        }
        newsCollectionView.reloadData()
        newsSelectionView.trendNewsCount = news.count > 4 ? 5 : news.count % 5
        newsSelectionView.setSelectionViews()
        if newsSelectionView.trendNewsCount > 1 {
            newsSelectionView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
            newsScrollPages.collectionView.isScrollEnabled = true
        }
    }
    
    func teamsTapGestureActive(sender: UITapGestureRecognizer) {
        
        if galeryBtnView.frame.contains(sender.location(in: homeScrollView)) {
            sender.isEnabled = false
            addAChildViewToView(child: galeryVC)
        } else if teamsBtnView.frame.contains(sender.location(in: homeScrollView)) {
            sender.isEnabled = false
            addAChildViewToView(child: teamsVC)
        } else if resultsBtnView.frame.contains(sender.location(in: homeScrollView)) {
            sender.isEnabled = false
            addAChildViewToView(child: resultsVC)
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
            sender.isEnabled = true
        })
        
    }
    
    func arrangeViews() {
        
        teamsVC = TeamsVC(nibName: "TeamsVC", bundle: nil)
        teamInfoVC = TeamInfoVC(nibName: "TeamInfoVC", bundle: nil)
        
        newsVC = NewsVC(nibName: "NewsVC", bundle: nil)
        
        galeryVC = GaleryVC(nibName: "GaleryVC", bundle: nil)
        
        resultsVC = ResultsVC(nibName: "ResultsVC", bundle: nil)
        
        childs = [teamsVC, teamInfoVC, newsVC, galeryVC, resultsVC]
    }
    
    func addTeamsPageToView() {
        
        view.isUserInteractionEnabled = false
        addChildViewController(teamsVC)
        homeView.addSubview(teamsVC.view)
        teamsVC.didMove(toParentViewController: self)
        
        teamsVC.view.frame = homeScrollView.frame
        teamsVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: navigationBar.frame.maxY)
        teamsVC.view.alpha = 0
        teamsVC.homeVC = self
        
        self.teamsVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: self.navigationBar.frame.maxY)
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: teamsVC.view.frame.origin, destinationPoint: homeScrollView.frame.origin), animations: {
            self.teamsVC.view.frame.origin = self.homeScrollView.frame.origin
            self.teamsVC.view.alpha = 1
            self.view.isUserInteractionEnabled = true
            self.homeView.bringSubview(toFront: self.homePageShadowView)
        })
        
    }
    
    func removeTeamsPageFromView() {
        
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: teamsVC.view.frame.origin, destinationPoint: CGPoint(x: UIScreen.main.bounds.maxX, y: navigationBar.frame.maxY)), animations: { 
            
            self.teamsVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: self.navigationBar.frame.maxY)
            self.teamsVC.view.alpha = 0
            
        }) { (completion) in
            self.teamsVC.willMove(toParentViewController: self)
            self.teamsVC.view.removeFromSuperview()
            self.teamsVC.removeFromParentViewController()
            self.view.isUserInteractionEnabled = true
        }
     
    }
    
    func addTeamInfoPageToView(team: Team) {
        
        view.isUserInteractionEnabled = false
        
        addChildViewController(teamInfoVC)
        homeView.addSubview(teamInfoVC.view)
        teamInfoVC.didMove(toParentViewController: self)
        teamInfoVC.homeVC = self
        
        teamInfoVC.view.frame = homeScrollView.frame
        teamInfoVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: navigationBar.frame.maxY)
        teamInfoVC.view.alpha = 0
        
        teamInfoVC.team = team
        
        homeView.bringSubview(toFront: homePageShadowView)
        
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: teamInfoVC.view.frame.origin, destinationPoint: CGPoint(x: 0, y: 0)), animations: {
            self.teamInfoVC.view.frame.origin = self.homeScrollView.frame.origin
            self.teamInfoVC.view.alpha = 1
        }) { (completion) in
            self.teamInfoVC.flameLeftConstraint.constant = -200
            self.teamInfoVC.flamaView.alpha = 1
            self.teamInfoVC.teamNameLbl.alpha = 1
            self.teamInfoVC.view.layoutIfNeeded()
            UIView.animate(withDuration: self.calculateAnimationDuration(startingPoint: self.teamInfoVC.flamaView.frame.origin, destinationPoint: CGPoint(x: 0, y: self.teamInfoVC.flamaView.frame.minY)), animations: {
                self.teamInfoVC.flameLeftConstraint.constant = 0
                self.teamInfoVC.teamsBackground.alpha = 1
                self.teamInfoVC.view.layoutIfNeeded()
            }) { (completion) in
                self.teamInfoVC.view.addGestureRecognizer(self.teamInfoVC.leftEgdeGesture)
                self.teamsVC.view.alpha = 0
                self.view.isUserInteractionEnabled = true
            }
        }
        
    }
    
    func removeTeamInfoPageFromView() {
        
        view.isUserInteractionEnabled = false
        teamsVC.view.alpha = 1
        resultsVC.view.alpha = 0
        
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: teamInfoVC.flamaView.frame.origin, destinationPoint: CGPoint(x: -200, y: homeScrollView.frame.minY)), animations: {
            self.teamInfoVC?.teamsBackground.alpha = 0
            self.teamInfoVC?.flameLeftConstraint.constant = -200
            self.teamInfoVC?.view.layoutIfNeeded()
        }, completion: { (completion) in
            self.teamInfoVC?.flamaView.alpha = 0
            self.teamInfoVC?.teamNameLbl.alpha = 0
            UIView.animate(withDuration: self.calculateAnimationDuration(startingPoint: self.teamInfoVC.view.frame.origin, destinationPoint: CGPoint(x: (self.teamInfoVC.view.frame.maxX), y: (self.navigationBar.frame.maxY))), animations: {
                self.teamInfoVC.view.frame.origin = CGPoint(x: self.teamInfoVC.view.frame.maxX, y: (self.navigationBar.frame.maxY))
            }, completion: { (completion) in
                self.teamInfoVC.willMove(toParentViewController: self)
                self.teamInfoVC.view.removeFromSuperview()
                self.teamInfoVC.removeFromParentViewController()
                self.mainScrollView.isScrollEnabled = true
                self.view.isUserInteractionEnabled = true
            })
        })
    }
    
    func addTeamInfoPageToViewFromResultsPage() {
        mainScrollView.isScrollEnabled = false
        view.isUserInteractionEnabled = false
        
        addChildViewController(teamInfoVC)
        homeView.addSubview(teamInfoVC.view)
        teamInfoVC.didMove(toParentViewController: self)
        teamInfoVC.homeVC = self
        
        teamInfoVC.view.frame = homeScrollView.frame
        teamInfoVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: navigationBar.frame.maxY)
        teamInfoVC.view.alpha = 0
        teamInfoVC.teamsBackground.alpha = 1
        
        homeView.bringSubview(toFront: homePageShadowView)
        
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: teamInfoVC.view.frame.origin, destinationPoint: CGPoint(x: 0, y: 0)), animations: {
            self.teamInfoVC.view.frame.origin = self.homeScrollView.frame.origin
            self.teamInfoVC.view.alpha = 1
        }) { (completion) in
            self.teamInfoVC.flameLeftConstraint.constant = -200
            self.teamInfoVC.view.layoutIfNeeded()
            self.teamInfoVC.flamaView.alpha = 1
            self.teamInfoVC.teamNameLbl.alpha = 1
            UIView.animate(withDuration: self.calculateAnimationDuration(startingPoint: self.teamInfoVC.flamaView.frame.origin, destinationPoint: CGPoint(x: 0, y: self.teamInfoVC.flamaView.frame.minY)), animations: {
                self.teamInfoVC.flameLeftConstraint.constant = 0
                self.teamInfoVC.view.layoutIfNeeded()
            }) { (completion) in
                self.teamInfoVC.view.addGestureRecognizer(self.teamInfoVC.leftEgdeGesture)
                self.resultsVC.view.alpha = 0
                self.view.isUserInteractionEnabled = true
            }
        }
        
    }
    
    func removeTeamInfoPageFromViewFromResultsPage() {
        
        view.isUserInteractionEnabled = false
        resultsVC.view.alpha = 1
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: teamInfoVC.flamaView.frame.origin, destinationPoint: CGPoint(x: -200, y: homeScrollView.frame.minY)), animations: {
            self.teamInfoVC?.flameLeftConstraint.constant = -200
            self.teamInfoVC?.view.layoutIfNeeded()
        }, completion: { (completion) in
            self.teamInfoVC?.flamaView.alpha = 0
            self.teamInfoVC?.teamNameLbl.alpha = 0
            UIView.animate(withDuration: self.calculateAnimationDuration(startingPoint: self.teamInfoVC.view.frame.origin, destinationPoint: CGPoint(x: (self.teamInfoVC.view.frame.maxX), y: (self.navigationBar.frame.maxY))), animations: {
                self.teamInfoVC.view.frame.origin = CGPoint(x: self.teamInfoVC.view.frame.maxX, y: (self.navigationBar.frame.maxY))
            }, completion: { (completion) in
                self.teamInfoVC.teamsBackground.alpha = 0
                self.teamInfoVC.willMove(toParentViewController: self)
                self.teamInfoVC.view.removeFromSuperview()
                self.teamInfoVC.removeFromParentViewController()
                self.mainScrollView.isScrollEnabled = true
                self.view.isUserInteractionEnabled = true
            })
        })
    }
    
    
    func addGaleryPageToView() {
        view.isUserInteractionEnabled = false
        
        addChildViewController(galeryVC)
        homeView.addSubview(galeryVC.view)
        galeryVC.didMove(toParentViewController: self)
        
        galeryVC.view.frame = homeScrollView.frame
        galeryVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: navigationBar.frame.maxY)
        galeryVC.view.alpha = 0
        
        homeView.bringSubview(toFront: homePageShadowView)
        
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: galeryVC.view.frame.origin, destinationPoint: CGPoint(x: 0, y: 0)), animations: {
            self.galeryVC.view.frame.origin = self.homeScrollView.frame.origin
            self.galeryVC.view.alpha = 1
        }) { (completion) in
            self.view.isUserInteractionEnabled = true
            self.homeView.bringSubview(toFront: self.homePageShadowView)
        }
        
    }
    
    func removeGaleryPageFromView() {
        
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: galeryVC.view.frame.origin, destinationPoint: CGPoint(x: UIScreen.main.bounds.maxX, y: navigationBar.frame.maxY)), animations: {
            
            self.galeryVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: self.navigationBar.frame.maxY)
            self.galeryVC.view.alpha = 0
            
        }) { (completion) in
            self.galeryVC.willMove(toParentViewController: self)
            self.galeryVC.view.removeFromSuperview()
            self.galeryVC.removeFromParentViewController()
            self.view.isUserInteractionEnabled = true
        }
        
    }
    
    func addResultsPageToView() {
        
        view.isUserInteractionEnabled = false
        
        addChildViewController(resultsVC)
        homeView.addSubview(resultsVC.view)
        resultsVC.didMove(toParentViewController: self)
        
        resultsVC.view.frame = homeScrollView.frame
        resultsVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: navigationBar.frame.maxY)
        resultsVC.view.alpha = 0
        
        self.resultsVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: self.navigationBar.frame.maxY)
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: resultsVC.view.frame.origin, destinationPoint: homeScrollView.frame.origin), animations: {
            self.resultsVC.view.frame.origin = self.homeScrollView.frame.origin
            self.resultsVC.view.alpha = 1
            self.view.isUserInteractionEnabled = true
            self.homeView.bringSubview(toFront: self.homePageShadowView)
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.teamSelectedNotificationReceived(_:)), name: NSNotification.Name("teamSelected"), object: nil)
        
    }
    
    func removeResultsPageFromView() {
        
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: resultsVC.view.frame.origin, destinationPoint: CGPoint(x: UIScreen.main.bounds.maxX, y: navigationBar.frame.maxY)), animations: {
            
            self.resultsVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: self.navigationBar.frame.maxY)
            self.resultsVC.view.alpha = 0
            
        }) { (completion) in
            self.resultsVC.willMove(toParentViewController: self)
            self.resultsVC.view.removeFromSuperview()
            self.resultsVC.removeFromParentViewController()
            self.view.isUserInteractionEnabled = true
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("teamSelected"), object: nil)
        
    }
    
    func addAChildViewToView(child: UIViewController) {
        
        view.isUserInteractionEnabled = false
        
        addChildViewController(child)
        homeView.addSubview(child.view)
        child.didMove(toParentViewController: self)
        
        child.view.frame = homeScrollView.frame
        child.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: navigationBar.frame.maxY)
        child.view.alpha = 0
        if child == teamsVC {
            teamsVC.homeVC = self
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("AnyChildAddedToView"), object: nil)
        
        homeView.bringSubview(toFront: homePageShadowView)
        
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: child.view.frame.origin, destinationPoint: CGPoint(x: 0, y: 0)), animations: {
            child.view.frame.origin = self.homeScrollView.frame.origin
            child.view.alpha = 1
        }) { (completion) in
            self.view.isUserInteractionEnabled = true
            self.homeView.bringSubview(toFront: self.homePageShadowView)
            self.homeScrollContentView.alpha = 0
        }
    
        if child == resultsVC {
            NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.teamSelectedNotificationReceived(_:)), name: NSNotification.Name("teamSelected"), object: nil)
        }
     
    }
    
    func removeAChildViewFromView(child: UIViewController, childToAdd: UIViewController?) {
        view.isUserInteractionEnabled = false
        self.homeScrollContentView.alpha = 1
        
        if child == resultsVC {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("teamSelected"), object: nil)
        }
        
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: child.view.frame.origin, destinationPoint: CGPoint(x: UIScreen.main.bounds.maxX, y: navigationBar.frame.maxY)), animations: {
            child.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: self.navigationBar.frame.maxY)
            child.view.alpha = 0
        }) { (completion) in
            if child == self.teamInfoVC {
                self.teamInfoVC.flamaView.alpha = 0
                self.teamInfoVC.teamNameLbl.alpha = 0
                self.teamInfoVC.teamsBackground.alpha = 0
            }
            self.mainScrollView.isScrollEnabled = true
            child.willMove(toParentViewController: self)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
            if childToAdd != nil {
                self.addAChildViewToView(child: childToAdd!)
            } else {
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func teamSelectedNotificationReceived(_ notification: NSNotification) {
        addTeamInfoPageToViewFromResultsPage()
    }
    
    func disableMainScrollView() {
        mainScrollView.isScrollEnabled = false
    }
    
    func selectItemInNewsSelection(itemIndex: Int) {
        newsSelectionView.collectionView.selectItem(at: IndexPath(item: itemIndex, section: 0), animated: false, scrollPosition: [])
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
        for child in childs {
            if child.view.frame == homeScrollView.frame {
                removeAChildViewFromView(child: child, childToAdd: nil)
            }
        }
    }

    func configureNewsCollectionView() {
        
        homeScrollContentViewHeight.constant = galeryBtnView.frame.maxY
        newsCollectionView = UICollectionView(frame: CGRect(x: 0, y: homeScrollContentViewHeight.constant, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 3 * CGFloat(ceil((Double((news?.count)! - 5)) / 2))), collectionViewLayout: UICollectionViewFlowLayout())
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        newsCollectionView.isScrollEnabled = false
        newsCollectionView.backgroundColor = UIColor.clear
        newsCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: "newsCell")
        homeScrollContentView.addSubview(newsCollectionView)
        homeScrollContentView.sendSubview(toBack: newsCollectionView)
        homeScrollContentViewHeight.constant += newsCollectionView.frame.height
        homeScrollView.isScrollEnabled = news != nil ? ((news?.count)! > 0) : false
        
    }
    
    func arrangeMainScrollViewPosition(animated: Bool) {
        mainScrollView.scrollRectToVisible(CGRect(x: UIScreen.main.bounds.width / 3 * 2, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), animated: animated)
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
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sideMenuTableView.deselectRow(at: indexPath, animated: true)
        tableView.isUserInteractionEnabled = false
        
        arrangeMainScrollViewPosition(animated: true)
        
        var removeCalled = false
        
        switch indexPath.row {
        case 0:
            for child in childs {
                if child.view.frame == homeScrollView.frame {
                    _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (timer) in
                        self.removeAChildViewFromView(child: child, childToAdd: nil)
                    })
                }
            }
            break;
        case 1:
            for child in childs {
                if teamsVC.view.frame == homeScrollView.frame {
                    removeCalled = true
                } else if child.view.frame == homeScrollView.frame && child != teamsVC {
                    _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (timer) in
                        self.removeAChildViewFromView(child: child, childToAdd: self.teamsVC)
                    })
                    removeCalled = true
                }
            }
            if !removeCalled {
                addAChildViewToView(child: teamsVC)
            }
            break;
        case 2:
            postNotifUserInfo = ["indexPath": (indexPath.row - 2)]
            NotificationCenter.default.post(name: NSNotification.Name("AnyChildAddedToView"), object: nil, userInfo: postNotifUserInfo)
            for child in childs {
                if galeryVC.view.frame == homeScrollView.frame {
                    removeCalled = true
                } else if child.view.frame == homeScrollView.frame && child != galeryVC {
                    _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (timer) in
                        self.removeAChildViewFromView(child: child, childToAdd: self.galeryVC)
                    })
                    removeCalled = true
                }
            }
            if !removeCalled {
                addAChildViewToView(child: galeryVC)
            }
            break;
        case 3:
            postNotifUserInfo = ["indexPath": (indexPath.row - 2)]
            NotificationCenter.default.post(name: NSNotification.Name("AnyChildAddedToView"), object: nil, userInfo: postNotifUserInfo)
            for child in childs {
                if galeryVC.view.frame == homeScrollView.frame {
                    removeCalled = true
                } else if child.view.frame == homeScrollView.frame && child != galeryVC {
                    _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (timer) in
                        self.removeAChildViewFromView(child: child, childToAdd: self.galeryVC)
                    })
                    removeCalled = true
                }
            }
            if !removeCalled {
                addAChildViewToView(child: galeryVC)
            }
            break;
        case 4:
            for child in childs {
                if newsVC.view.frame == homeScrollView.frame {
                    removeCalled = true
                } else if child.view.frame == homeScrollView.frame && child != newsVC {
                    _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (timer) in
                        self.removeAChildViewFromView(child: child, childToAdd: self.newsVC)
                    })
                    removeCalled = true
                }
            }
            if !removeCalled {
                addAChildViewToView(child: newsVC)
            }
            break;
        case 5:
            for child in childs {
                if resultsVC.view.frame == homeScrollView.frame {
                    removeCalled = true
                } else if child.view.frame == homeScrollView.frame && child != resultsVC {
                    _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (timer) in
                        self.removeAChildViewFromView(child: child, childToAdd: self.resultsVC)
                    })
                    removeCalled = true
                }
            }
            if !removeCalled {
                addAChildViewToView(child: resultsVC)
            }
            break;
        default:
            for child in childs {
                if child.view.frame == homeScrollView.frame {
                    _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (timer) in
                        self.removeAChildViewFromView(child: child, childToAdd: nil)
                    })
                }
            }
            break;
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            tableView.isUserInteractionEnabled = true
        })
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
        if news != nil {
            return ((((news?.count)! - 5 > 10) ? 10 : ((news?.count)! < 5 ? 0 : ((news?.count)! - 5))) % 2 == 0) ? ((((news?.count)! - 5 > 10) ? 10 : ((news?.count)! < 5 ? 0 : ((news?.count)! - 5)))) : ((((news?.count)! - 5 > 10) ? 10 : ((news?.count)! < 5 ? 0 : ((news?.count)! - 5))) + 1)
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newsCollectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCell
        if indexPath.row < ((news?.count)! - 5) {
            cell.news = news?[5 + indexPath.row]
        }
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2 - 0.5, height: UIScreen.main.bounds.width / 3 - 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newsCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    @IBAction func sideMenuBtnPressed(_ sender: UIButton) {
        if mainScrollView.contentOffset.x == 0 {
            arrangeMainScrollViewPosition(animated: true)
        } else if mainScrollView.contentOffset.x == UIScreen.main.bounds.width / 3 * 2 {
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

