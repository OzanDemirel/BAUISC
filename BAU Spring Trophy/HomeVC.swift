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
    @IBOutlet weak var launchScreenView: UIView!
    @IBOutlet weak var adBanner: AdsBanner!
    @IBOutlet weak var adBannerButton: UIButton!
    @IBOutlet weak var adLabel: UILabel!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var sideMenuLogo: UIImageView!
    @IBOutlet weak var sideMenuShadow: UIImageView!
    
    @IBOutlet weak var mainScrollViewContentWidth: NSLayoutConstraint!
    @IBOutlet weak var mainScrollViewContentHeight: NSLayoutConstraint!
    @IBOutlet weak var sideMenuWidth: NSLayoutConstraint!
    @IBOutlet weak var mainMenuWidth: NSLayoutConstraint!
    @IBOutlet weak var homeScrollContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var launchScreenIconHeight: NSLayoutConstraint!
    
    var buttonsTapGesture: UITapGestureRecognizer!
    
    var homePageShadowView: UIImageView!
    
    lazy var newsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(NewsCell.self, forCellWithReuseIdentifier: "newsCell")
        cv.delegate = self
        cv.dataSource = self
        cv.isScrollEnabled = false
        cv.backgroundColor = UIColor.clear
        cv.alpha = 0
        return cv
    }()
    
    var navigationBarBtn: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var shadowViewButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var bottomNewsCount = 0
    
    var teamsVC: TeamsVC!
    var teamInfoVC: TeamInfoVC!
    
    var newsVC: NewsVC!
    var newsContentVC: NewsContentVC!
    
    var galeryVC: GaleryVC!
    
    var imagePreviewBackgroundView = UIView()
    var imagePreviewScrollView = UIScrollView()
    var imagePreview = UIImageView()
    var imagePreviewTapGesture: UITapGestureRecognizer!
    var imagePreviewTapGestureForScroll: UITapGestureRecognizer!
    var imagePreviewNavigationBar = UIImageView()
    var imagePreviewDoneButton = UIButton()
    var imagePreviewSaveButton = UIButton()
    var imagePreviewLogo = UIImageView()
    
    var resultsVC: ResultsVC!
    
    var news: [News]?
    
    var teams: [Team]?
    
    var postNotifUserInfo: [String: Int]!
    
    let sideMenuItems: [Dictionary<String, String>]! = [["Anasayfa / Home": "Home"], ["Takımlar / Teams": "Teams"] , ["Fotoğraflar / Photos": "Photos"], ["Videolar / Videos": "Videos"], ["Haberler / News": "News"], ["Sonuçlar / Results": "Results"], ["Yarışlar / Races": "Races"], ["İletişim / Contact": "Contact"], ["Sponsorlar / Sponsors": "Sponsors"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNews()
        fetchAds()
        
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
        
        checkForInternet()
    
        arrangeMainScrollViewPosition(animated: false)
        
        navigationBar.addSubview(navigationBarBtn)
        navigationBar.addConstraintsWithVisualFormat(format: "H:|-80-[v0]-0-|", views: navigationBarBtn)
        navigationBar.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: navigationBarBtn)
        navigationBarBtn.addTarget(self, action: #selector(HomeVC.navigationBarBtnPressed), for: UIControlEvents.touchUpInside)
        
        homeScrollView.isScrollEnabled = news != nil ? ((news?.count)! > 0) : false
        
        arrangeShadowView()
        
        
        arrangeViews()
        
        if #available(iOS 10.0, *) {
            _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                self.animateLogo()
            })
        } else {
            animateLogo()
        }
        
        buttonsTapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeVC.buttonsTapGestureActive(sender:)))
        buttonsTapGesture.cancelsTouchesInView = false
        homeScrollView.addGestureRecognizer(buttonsTapGesture)
        
        homeScrollContentView.addSubview(newsCollectionView)
        homeScrollContentView.sendSubview(toBack: newsCollectionView)
        
        galeryBtnView.image = addFilterToImage(blendMode: .multiply, alpha: 1)
        resultsBtnView.image = addFilterToImage(blendMode: .multiply, alpha: 1)
        teamsBtnView.image = addFilterToImage(blendMode: .multiply, alpha: 1)
        sideMenuShadow.image = setSideMenuShadow(blendMode: .multiply, alpha: 1)
        
        setImagePreviewView()
        
    }
    
    func setSideMenuShadow(blendMode: CGBlendMode, alpha: CGFloat) -> UIImage? {
        
        if let img = UIImage(named: "Shadow"), let img2 = UIImage(named: "SideMenuShadowBackground") {
            let rect = CGRect(x: 0, y: 0, width: sideMenuShadow.frame.width, height: sideMenuShadow.frame.height)
            if #available(iOS 10.0, *) {
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: sideMenuShadow.frame.width, height: sideMenuShadow.frame.height))
                
                let result = renderer.image { ctx in
                    // fill the background with white so that translucent colors get lighter
                    UIColor.white.set()
                    ctx.fill(rect)
                    
                    img2.draw(in: rect, blendMode: .normal, alpha: 1)
                    img.draw(in: CGRect(x: 0, y: 0, width: sideMenuShadow.frame.width, height: sideMenuShadow.frame.height), blendMode: blendMode, alpha: alpha)
                }
                
                return result
                
            } else {
                
                UIGraphicsBeginImageContextWithOptions(sideMenuShadow.frame.size, true, 0)
                let context = UIGraphicsGetCurrentContext()
                
                // fill the background with white so that translucent colors get lighter
                context!.setFillColor(UIColor.white.cgColor)
                context!.fill(rect)
                
                img.draw(in: CGRect(x: 0, y: 0, width: sideMenuShadow.frame.width, height: sideMenuShadow.frame.height), blendMode: blendMode, alpha: alpha)
                img2.draw(in: rect, blendMode: .normal, alpha: 1)
                
                // grab the finished image and return it
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return result
                
            }
        }
        return nil
    }
    
        
    
    func checkForInternet() {
        
        if currentReachabilityStatus == .notReachable  {
            internetConnectionAlert()
        }
        
    }
    
    func internetConnectionAlert() {
        
        let alert = UIAlertController(title: "Bağlantı Hatası", message: "Bu uygulama internet bağlantısı gerektirmektedir.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.cancel, handler: { (action) in
            self.checkForInternet()
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    func animateLogo() {
        trophyLogoView.startAnimation()
        bauiscLogoView.startAnimation()
    }
    
    func fetchAds() {
        
        ApiService.sharedInstance.fetchAds { (ads) in
            self.adBanner.ads = ads
            self.adLabel.isHidden = true
            self.startLaunchScreenAnimation()
        }
        
    }
    
    func fetchNews() {
        
        ApiService.sharedInstance.fetchNews { (news: [News]) in
            self.news = news
            self.setTrendNews(news: news)
        }
        
    }
    
    func startLaunchScreenAnimation() {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.launchScreenView.alpha = 0
        }) { (true) in
            self.view.isUserInteractionEnabled = true
            self.launchScreenView.removeFromSuperview()
        }
        
    }

    func setTrendNews(news: [News]) {

        newsScrollPages.newsCount = news.count > 4 ? 5 : news.count
        if news.count > 1 {
            leftArrow.isEnabled = true
            rightArrow.isEnabled = true
        } else {
            leftArrow.isEnabled = false
            rightArrow.isEnabled = false
        }
        if news.count > 5 {
            bottomNewsCount = news.count - 5
        } else {
            bottomNewsCount = 0
        }
        newsSelectionView.trendNewsCount = news.count > 4 ? 5 : news.count % 5
//        newsSelectionView.setSelectionViews()
//        newsSelectionView.collectionView.reloadData()
//        newsScrollPages.collectionView.reloadData()
//        if news.count > 1 {
//            newsScrollPages.collectionView.scrollToItem(at: IndexPath(item: 5000, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
//        }
        setNewsCollectionView()
    }
    
    func setImagePreviewView() {
        
        imagePreviewBackgroundView.frame = UIScreen.main.bounds
        imagePreviewBackgroundView.backgroundColor = UIColor.white
        
        imagePreviewScrollView.delegate = self
        imagePreviewScrollView.frame = UIScreen.main.bounds
        imagePreviewScrollView.showsVerticalScrollIndicator = false
        imagePreviewScrollView.showsHorizontalScrollIndicator = false
        imagePreviewScrollView.backgroundColor = UIColor.white
        imagePreview.frame = imagePreviewScrollView.frame
        imagePreview.isUserInteractionEnabled = true
        imagePreview.contentMode = .scaleAspectFit
        imagePreviewScrollView.addSubview(imagePreview)
        
        imagePreviewNavigationBar.contentMode = .scaleAspectFill
        imagePreviewNavigationBar.image = UIImage(named: "NavigationBarBackground")
        imagePreviewNavigationBar.clipsToBounds = true
        imagePreviewNavigationBar.isUserInteractionEnabled = true
        imagePreviewNavigationBar.frame = CGRect(x: 0, y: -100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 23 * 5)
        
        imagePreviewLogo.contentMode = .scaleAspectFit
        imagePreviewLogo.image = UIImage(named: "TrophyHorizontalLogo")
        imagePreviewNavigationBar.addSubview(imagePreviewLogo)
        imagePreviewNavigationBar.addConstraintsWithVisualFormat(format: "V:|-20-[v0]-10-|", views: imagePreviewLogo)
        imagePreviewNavigationBar.addConstraintsWithVisualFormat(format: "H:[v0(100)]", views: imagePreviewLogo)
        imagePreviewNavigationBar.addConstraint(NSLayoutConstraint(item: imagePreviewLogo, attribute: .centerX, relatedBy: .equal, toItem: imagePreviewNavigationBar, attribute: .centerX, multiplier: 1, constant: 0))
        
        imagePreviewDoneButton.setImage(UIImage(named: "LeftArrow"), for: UIControlState.normal)
        imagePreviewDoneButton.contentMode = UIViewContentMode.scaleAspectFit
        imagePreviewDoneButton.addTarget(self, action: #selector(HomeVC.imagePreviewDoneButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        imagePreviewNavigationBar.addSubview(imagePreviewDoneButton)
        imagePreviewNavigationBar.addConstraintsWithVisualFormat(format: "H:|-20-[v0(30)]", views: imagePreviewDoneButton)
        imagePreviewNavigationBar.addConstraintsWithVisualFormat(format: "V:[v0(30)]", views: imagePreviewDoneButton)
        imagePreviewNavigationBar.addConstraint(NSLayoutConstraint(item: imagePreviewDoneButton, attribute: .centerY, relatedBy: .equal, toItem: imagePreviewNavigationBar, attribute: .centerY, multiplier: 1, constant: 10))
        
        imagePreviewNavigationBar.addSubview(imagePreviewSaveButton)
        imagePreviewSaveButton.setTitle("Kaydet", for: UIControlState.normal)
        imagePreviewSaveButton.titleLabel?.textAlignment = .right
        imagePreviewSaveButton.addTarget(self, action: #selector(HomeVC.imagePreviewSaveButtonPressed(_:)), for: .touchUpInside)
        imagePreviewSaveButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 14)
        imagePreviewSaveButton.setTitleColor(UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 1), for: .normal)
        imagePreviewNavigationBar.addConstraintsWithVisualFormat(format: "H:[v0]-20-|", views: imagePreviewSaveButton)
        imagePreviewNavigationBar.addConstraintsWithVisualFormat(format: "V:[v0(50)]", views: imagePreviewSaveButton)
        imagePreviewNavigationBar.addConstraint(NSLayoutConstraint(item: imagePreviewSaveButton, attribute: .centerY, relatedBy: .equal, toItem: imagePreviewNavigationBar, attribute: .centerY, multiplier: 1, constant: 10))
        
        imagePreviewTapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeVC.imagePreviewTapGestureActive(_:)))
        imagePreviewTapGesture.cancelsTouchesInView = false
        imagePreviewBackgroundView.addGestureRecognizer(imagePreviewTapGesture)
        
        imagePreviewTapGestureForScroll = UITapGestureRecognizer(target: self, action: #selector(HomeVC.imagePreviewTapGestureActive(_:)))
        imagePreviewTapGestureForScroll.cancelsTouchesInView = false
        imagePreviewScrollView.addGestureRecognizer(imagePreviewTapGestureForScroll)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.didSelectAnImage(_:)), name: NSNotification.Name("didSelectAnImage"), object: nil)
        
    }
    
    func imagePreviewDoneButtonPressed(_ button: UIButton) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imagePreviewNavigationBar.frame.origin = CGPoint(x: 0, y: -self.imagePreviewNavigationBar.frame.height)
        }) { (true) in
            self.imagePreviewNavigationBar.removeFromSuperview()
            self.mainScrollView.isScrollEnabled = true
            self.homeScrollView.isScrollEnabled = true
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imagePreviewBackgroundView.alpha = 0
            self.imagePreviewScrollView.alpha = 0
        }) { (true) in
            self.imagePreviewBackgroundView.removeFromSuperview()
            self.imagePreviewScrollView.removeFromSuperview()
        }
    }
    
    func imagePreviewSaveButtonPressed(_ button: UIButton) {
        
        if let image = imagePreview.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            let alert = UIAlertController(title: "Görsel Kaydedildi", message: "Görsel başarıyla fotoğraf galerisine kaydedildi.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: { 
                alert.dismiss(animated: true, completion: nil)
            })
        }
        
    }
    
    func imagePreviewTapGestureActive(_ gesture: UIGestureRecognizer) {
        gesture.isEnabled = false
        if imagePreviewNavigationBar.frame.minY != 0 {
            presentImagePreviewNavigationBar(gesture)
        } else {
            dismissImagePreviewNavigationBar(gesture)
        }
    }
    
    
    func dismissImagePreviewNavigationBar(_ gesture: UIGestureRecognizer?) {
        if imagePreviewNavigationBar.frame.minY == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.imagePreviewNavigationBar.frame.origin = CGPoint(x: 0, y: -self.imagePreviewNavigationBar.frame.height)
            }) { (true) in
                if gesture != nil {
                    gesture!.isEnabled = true
                }
            }
        }
    }
    
    func presentImagePreviewNavigationBar(_ gesture: UIGestureRecognizer?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.imagePreviewNavigationBar.frame.origin = CGPoint(x: 0, y: 0)
        }) { (true) in
            if gesture != nil {
                gesture!.isEnabled = true
            }
        }
    }
    
    func didSelectAnImage(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo as? [String: Any] {
            
            if let image = userInfo["image"] as? UIImage {
                view.isUserInteractionEnabled = false
                imagePreview.image = image
                imagePreview.frame.size = image.size
                
                if UIScreen.main.bounds.width / image.size.width <= UIScreen.main.bounds.height / image.size.height {
                    imagePreview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: image.size.height * (UIScreen.main.bounds.width / image.size.width))
                    
                } else {
                    imagePreview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * (UIScreen.main.bounds.height / image.size.height), height: image.size.height)
                }
                imagePreviewScrollView.frame = CGRect(x: (UIScreen.main.bounds.width - imagePreview.frame.width) / 2, y: (UIScreen.main.bounds.height - imagePreview.frame.height) / 2, width: imagePreview.frame.width, height: imagePreview.frame.height)
                imagePreviewScrollView.contentSize = image.size
                
                imagePreviewScrollView.contentSize = imagePreview.frame.size
                imagePreviewScrollView.minimumZoomScale = 1
                imagePreviewScrollView.maximumZoomScale = 4
                
                mainScrollView.isScrollEnabled = false
                homeScrollView.isScrollEnabled = false
                imagePreviewScrollView.alpha = 0
                imagePreviewBackgroundView.alpha = 0
                homeView.addSubview(imagePreviewBackgroundView)
                homeView.addSubview(imagePreviewScrollView)
                homeView.addSubview(imagePreviewNavigationBar)
                self.presentImagePreviewNavigationBar(nil)
                UIView.animate(withDuration: 0.5, animations: {
                    self.imagePreviewScrollView.alpha = 1
                    self.imagePreviewBackgroundView.alpha = 1
                }, completion: { (true) in
                    self.view.isUserInteractionEnabled = true
                })
                
            }
            
        }
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
        dismissImagePreviewNavigationBar(nil)
    }
    
    func centerScrollViewContents() {
        let contentsFrame = imagePreview.frame
 
        if contentsFrame.width <= UIScreen.main.bounds.width && contentsFrame.height <= UIScreen.main.bounds.height {
            imagePreviewScrollView.frame = contentsFrame
        } else if contentsFrame.width <= UIScreen.main.bounds.width && contentsFrame.height > UIScreen.main.bounds.height {
            imagePreviewScrollView.frame.size = CGSize(width: contentsFrame.size.width, height: UIScreen.main.bounds.height)
        } else if contentsFrame.width > UIScreen.main.bounds.width && contentsFrame.height <= UIScreen.main.bounds.height {
            imagePreviewScrollView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: contentsFrame.height)
        } else if contentsFrame.width > UIScreen.main.bounds.width && contentsFrame.height > UIScreen.main.bounds.height {
            imagePreviewScrollView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
        imagePreviewScrollView.contentSize = imagePreview.frame.size
        imagePreviewScrollView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagePreview
    }
    
    func buttonsTapGestureActive(sender: UITapGestureRecognizer) {
        
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
        
        if #available(iOS 10.0, *) {
            _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                sender.isEnabled = true
            })
        } else {
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(HomeVC.tapGestureReactive(_:)) , userInfo: sender, repeats: false)
        }
        
    }
    
    func tapGestureReactive(_ timer: Timer) {
        
        if let gesture = timer.userInfo as? UITapGestureRecognizer {
            gesture.isEnabled = true
        }
    }
    
    
    
    func arrangeViews() {
        
        teamsVC = TeamsVC(nibName: "TeamsVC", bundle: nil)
        teamInfoVC = TeamInfoVC(nibName: "TeamInfoVC", bundle: nil)
        
        newsVC = NewsVC(nibName: "NewsVC", bundle: nil)
        newsContentVC = NewsContentVC(nibName: "NewsContentVC", bundle: nil)
        
        galeryVC = GaleryVC(nibName: "GaleryVC", bundle: nil)
        
        resultsVC = ResultsVC(nibName: "ResultsVC", bundle: nil)
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
    
    func addTeamInfoPageToViewFromResultsPage(team: Team) {
        mainScrollView.isScrollEnabled = false
        view.isUserInteractionEnabled = false
        
        addChildViewController(teamInfoVC)
        homeView.addSubview(teamInfoVC.view)
        teamInfoVC.didMove(toParentViewController: self)
        teamInfoVC.homeVC = self
        
        teamInfoVC.team = team
        
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
        } else if child == newsVC {
            newsVC.homeVC = self
            newsVC.newsCollectionView.layer.shouldRasterize = true
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
            if child == self.newsVC {
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.newsVC.newsCollectionView.alpha = 1
//                })
                self.newsVC.newsCollectionView.layer.shouldRasterize = false
            }
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
        if child == newsVC {
            newsVC.newsCollectionView.layer.shouldRasterize = true
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
    
    func addNewsContentViewToView(news: News) {
        
        view.isUserInteractionEnabled = false
        mainScrollView.isScrollEnabled = false
        
        addChildViewController(newsContentVC)
        homeView.addSubview(newsContentVC.view)
        newsContentVC.didMove(toParentViewController: self)
        newsContentVC.homeVC = self
        
        newsContentVC.view.frame = homeScrollView.frame
        newsContentVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.maxX, y: navigationBar.frame.maxY)
        newsContentVC.view.alpha = 0
        
        self.newsContentVC.newsTitle.text = ""
        self.newsContentVC.newsText.text = ""
        self.newsContentVC.newsImage.image = UIImage(named: "TrendCellBackground")
        
        self.newsContentVC.news = news
        
        homeView.bringSubview(toFront: homePageShadowView)
        
        UIView.animate(withDuration: calculateAnimationDuration(startingPoint: newsContentVC.view.frame.origin, destinationPoint: CGPoint(x: 0, y: 0)), animations: {
            self.newsContentVC.view.frame.origin = self.homeScrollView.frame.origin
            self.newsContentVC.view.alpha = 1
        }) { (completion) in
            self.view.isUserInteractionEnabled = true
            self.homeScrollContentView.alpha = 0
            self.newsVC.view.alpha = 0
        }
        
    }
    
    func removeNewsContentViewFromView() {
        
        view.isUserInteractionEnabled = false
        newsVC.view.alpha = 1
        if newsVC.view.frame != homeScrollView.frame {
            homeScrollContentView.alpha = 1
        }
        
        UIView.animate(withDuration: self.calculateAnimationDuration(startingPoint: self.newsContentVC.view.frame.origin, destinationPoint: CGPoint(x: (self.newsContentVC.view.frame.maxX), y: (self.navigationBar.frame.maxY))), animations: {
            self.newsContentVC.view.frame.origin = CGPoint(x: self.newsContentVC.view.frame.maxX, y: (self.navigationBar.frame.maxY))
            self.newsContentVC.view.alpha = 0
        }, completion: { (completion) in
            self.newsContentVC.willMove(toParentViewController: self)
            self.newsContentVC.view.removeFromSuperview()
            self.newsContentVC.removeFromParentViewController()
            self.mainScrollView.isScrollEnabled = true
            self.view.isUserInteractionEnabled = true
        })
        
    }
    
    func teamSelectedNotificationReceived(_ notification: NSNotification) {
        
        if let notification = notification.userInfo as? [String: Any] {

            if let team = notification["team"] as? Team {

                addTeamInfoPageToViewFromResultsPage(team: team)
                
            }
            
        }
        
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
        
        homePageShadowView.addSubview(shadowViewButton)
        homePageShadowView.addConstraintsWithVisualFormat(format: "H:|[v0]|", views: shadowViewButton)
        homePageShadowView.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: shadowViewButton)
        shadowViewButton.addTarget(self, action: #selector(HomeVC.closeSideMenu), for: UIControlEvents.touchUpInside)
        
    }
    
    func navigationBarBtnPressed() {
        homeScrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: homeScrollView.frame.width, height: homeScrollView.frame.height), animated: true)
        for child in childViewControllers {
            removeAChildViewFromView(child: child, childToAdd: nil)
            
        }
    }

    func setNewsCollectionView() {
        
        homeScrollContentViewHeight.constant = galeryBtnView.frame.maxY
        newsCollectionView.frame = CGRect(x: 0, y: homeScrollContentViewHeight.constant, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width / 2) * CGFloat(ceil(Double(bottomNewsCount) / 2)) - 0.5)
        homeScrollContentViewHeight.constant += newsCollectionView.frame.height
        if newsCollectionView.alpha == 0 {
            UIView.animate(withDuration: 1, animations: { 
                self.newsCollectionView.alpha = 1
            })
        }
        homeScrollView.isScrollEnabled = news != nil ? ((news?.count)! > 0) : false
        newsCollectionView.reloadData()
        
    }
    
    func closeSideMenu() {
        mainScrollView.scrollRectToVisible(CGRect(x: UIScreen.main.bounds.width / 3 * 2, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), animated: true)
    }
    
    func arrangeMainScrollViewPosition(animated: Bool) {
        mainScrollView.scrollRectToVisible(CGRect(x: UIScreen.main.bounds.width / 3 * 2, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), animated: animated)
        sideMenuView.isHidden = false
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
        mainScrollView.isUserInteractionEnabled = false
        
        if indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 {
            let alert = UIAlertController(title: "Sayfa Yapım Aşamasındadır.", message: "Bu sayfa güncellemeyle birlikte aktif hale gelecektir.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: { 
                self.sideMenuTableView.isUserInteractionEnabled = true
                self.mainScrollView.isUserInteractionEnabled = true
            })
            return
        }
        
        arrangeMainScrollViewPosition(animated: true)
        
        var removeCalled = false
        
        switch indexPath.row {
        case 0:
            for child in childViewControllers {
                executeChildRemovingAndAdding(child: child, childToAdd: nil)
            }
            break;
        case 1:
            for child in childViewControllers {
                if teamsVC.view.frame == homeScrollView.frame {
                    removeCalled = true
                } else if child.view.frame == homeScrollView.frame && child != teamsVC {
                    executeChildRemovingAndAdding(child: child, childToAdd: self.teamsVC)
                    removeCalled = true
                }
            }
            if !removeCalled {
                addAChildViewToView(child: teamsVC)
            }
            break;
        case 2:
            for child in childViewControllers {
                if galeryVC.view.frame == homeScrollView.frame {
                    removeCalled = true
                } else if child.view.frame == homeScrollView.frame && child != galeryVC {
                    executeChildRemovingAndAdding(child: child, childToAdd: self.galeryVC)
                    removeCalled = true
                }
            }
            if !removeCalled {
                addAChildViewToView(child: galeryVC)
            }
            postNotifUserInfo = ["indexPath": (indexPath.row - 2)]
            NotificationCenter.default.post(name: NSNotification.Name("AnyChildAddedToView"), object: nil, userInfo: postNotifUserInfo)
            break;
        case 3:
            for child in childViewControllers {
                if galeryVC.view.frame == homeScrollView.frame {
                    removeCalled = true
                } else if child.view.frame == homeScrollView.frame && child != galeryVC {
                    executeChildRemovingAndAdding(child: child, childToAdd: self.galeryVC)
                    removeCalled = true
                }
            }
            if !removeCalled {
                addAChildViewToView(child: galeryVC)
            }
            postNotifUserInfo = ["indexPath": (indexPath.row - 2)]
            NotificationCenter.default.post(name: NSNotification.Name("AnyChildAddedToView"), object: nil, userInfo: postNotifUserInfo)
            break;
        case 4:
            for child in childViewControllers {
                if newsVC.view.frame == homeScrollView.frame {
                    removeCalled = true
                } else if child.view.frame == homeScrollView.frame && child != newsVC {
                    executeChildRemovingAndAdding(child: child, childToAdd: self.newsVC)
                    removeCalled = true
                }
            }
            if !removeCalled {
                addAChildViewToView(child: newsVC)
            }
            break;
        case 5:
            for child in childViewControllers {
                if resultsVC.view.frame == homeScrollView.frame {
                    removeCalled = true
                } else if child.view.frame == homeScrollView.frame && child != resultsVC {
                    executeChildRemovingAndAdding(child: child, childToAdd: self.resultsVC)
                    removeCalled = true
                }
            }
            if !removeCalled {
                addAChildViewToView(child: resultsVC)
            }
            break;
        default:
            for child in childViewControllers {
                executeChildRemovingAndAdding(child: child, childToAdd: nil)
                
            }
            break;
        }
        
        if #available(iOS 10.0, *) {
            _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                self.reactiveInteraction()
            })
        } else {
            _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HomeVC.reactiveInteraction), userInfo: nil, repeats: false)
        }
    }
    
    func reactiveInteraction() {
        sideMenuTableView.isUserInteractionEnabled = true
        mainScrollView.isUserInteractionEnabled = true
    }
    
    func executeChildRemovingAndAdding(child: UIViewController, childToAdd: UIViewController?) {
        if #available(iOS 10.0, *) {
            _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (timer) in
                self.removeAChildViewFromView(child: child, childToAdd: childToAdd)
            })
        } else {
            var childs = [UIViewController]()
            if let childToAdd = childToAdd {
               childs = [child, childToAdd]
            } else {
                childs = [child]
            }
            
            _ = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(HomeVC.callForRevomeAChildFunction(_:)), userInfo: childs, repeats: false)
        }
        
    }
    
    func callForRevomeAChildFunction(_ timer: Timer) {
        if let childs = timer.userInfo as? [UIViewController] {
            if childs.count == 2 {
                removeAChildViewFromView(child: childs[0], childToAdd: childs[1])
            } else if childs.count == 1 {
                removeAChildViewFromView(child: childs[0], childToAdd: nil)
            }
        }
    }
    
    func addFilterToImage(blendMode: CGBlendMode, alpha: CGFloat) -> UIImage? {
        
        if let img = UIImage(named: "Shadow"), let img2 = UIImage(named: "Button") {
            let rect = CGRect(x: 0, y: 0, width: galeryBtnView.frame.width, height: galeryBtnView.frame.height)
            if #available(iOS 10.0, *) {
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: galeryBtnView.frame.width, height: galeryBtnView.frame.height))
                
                let result = renderer.image { ctx in
                    // fill the background with white so that translucent colors get lighter
                    UIColor.white.set()
                    ctx.fill(rect)
                    
                    img2.draw(in: rect, blendMode: .normal, alpha: 1)
                    img.draw(in: CGRect(x: (galeryBtnView.frame.width - galeryBtnView.frame.width / 1.28) / 2, y: 0, width: galeryBtnView.frame.width / 1.28, height: galeryBtnView.frame.height / 1.83), blendMode: blendMode, alpha: alpha)
                }
                
                return result
                
            } else {
                
                UIGraphicsBeginImageContextWithOptions(galeryBtnView.frame.size, true, 0)
                let context = UIGraphicsGetCurrentContext()
                
                // fill the background with white so that translucent colors get lighter
                context!.setFillColor(UIColor.white.cgColor)
                context!.fill(rect)
                
                img.draw(in: CGRect(x: (galeryBtnView.frame.width - galeryBtnView.frame.width / 1.28) / 2, y: 0, width: galeryBtnView.frame.width / 1.28, height: galeryBtnView.frame.height / 1.83), blendMode: blendMode, alpha: alpha)
                img2.draw(in: rect, blendMode: .normal, alpha: 1)
                
                // grab the finished image and return it
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return result
                
            }
            
        }
        return nil
        
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
        return bottomNewsCount % 2 == 1 ? bottomNewsCount + 1 : bottomNewsCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newsCollectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCell
        if indexPath.row < bottomNewsCount {
            cell.news = news?[5 + indexPath.row]
        } else {
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
        }
        cell.backgroundColor = UIColor.white
        return cell
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newsCollectionView.deselectItem(at: indexPath, animated: true)
        
        if let news = news?[indexPath.row + 5] {
            addNewsContentViewToView(news: news)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    @IBAction func sideMenuBtnPressed(_ sender: UIButton) {
        if mainScrollView.contentOffset.x == 0 {
            arrangeMainScrollViewPosition(animated: true)
        } else if floor(mainScrollView.contentOffset.x) == floor(UIScreen.main.bounds.width / 3 * 2) {
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
    
    @IBAction func adBannerButtonPressed(_ sender: UIButton) {
        if let urlString = adBanner.addressURL {
            if let url = URL(string: urlString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
}

