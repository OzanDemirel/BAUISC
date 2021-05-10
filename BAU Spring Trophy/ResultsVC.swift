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
    
    @IBOutlet weak var orcFlamaWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ircFlamaWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var orcButton: DesignableButton!
    @IBOutlet weak var ircButton: DesignableButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var homeVC: HomeVC?
    
    var raitingCategoryButtons: [DesignableButton]!
    
    let classCellId = "classResultsContainer"
    let generalCellId = "generalResultsContainer"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
        resultsTableContainer.delegate = self
        resultsTableContainer.dataSource = self
        resultsTableContainer.allowsSelection = false
        resultsTableContainer.register(GeneralResultsContainer.self, forCellWithReuseIdentifier: generalCellId)
        resultsTableContainer.register(ClassResultsContainer.self, forCellWithReuseIdentifier: classCellId)
        
        resultsTableContainer.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.centeredVertically, animated: false)
        tableSectionView.selectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        
        daysSectionView.resultsVC = self
        tableSectionView.resultsVC = self
        
        raitingCategoryButtons = [ircButton, orcButton]
        
        ircButton.isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.asd), name: NSNotification.Name("raitingTypeHasBeenSetted"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resultsTableContainer.reloadData()
        
    }

    @IBAction func categoryButtonPressed(sender: DesignableButton) {
        if sender.isActive == false {
            animateCategoryButtons()
        }
    }
    
    @objc func asd() {
        animateCategoryButtons()
        
//        for button in raitingCategoryButtons {
//            if button.isActive == false &&
//        }
//        if ircButton.isActive == true {
//            ircButton.sendActions(for: .touchUpInside)
//            animateCategoryButtons()
//        } else if orcButton.isActive == true {
//            ircButton.sendActions(for: .touchUpInside)
//            animateCategoryButtons()
//        }
    }
    
    func animateCategoryButtons() {
        
        if ircButton.isActive == true {
            ircFlamaWidthConstraint.constant = ircFlamaWidthConstraint.constant * 0.8
        } else {
            ircFlamaWidthConstraint.constant = ircFlamaWidthConstraint.constant * 1.25
        }
        
        changeStatus(ircButton)
        
        if orcButton.isActive == true {
            orcFlamaWidthConstraint.constant = orcFlamaWidthConstraint.constant * 0.8
        } else {
            orcFlamaWidthConstraint.constant = orcFlamaWidthConstraint.constant * 1.25
        }
        
        changeStatus(orcButton)
        
    }
    
    func changeStatus(_ button: DesignableButton) {
        
        if button.isActive == true {
            button.isActive = false
        } else {
            button.isActive = true
        }
    
    }
    
    
    func scrollToSectionInRaces(indexPath: Int) {
        racesSectionView.selectionView.scrollToItem(at: IndexPath(item: 0, section: indexPath), at: [], animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("aDaySelected"), object: nil)
    }
     
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        tableSectionView.selectionView.selectItem(at: IndexPath(item: Int(scrollView.contentOffset.x / scrollView.frame.width), section: 0), animated: false, scrollPosition: [])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableSectionView.selectionView.selectItem(at: IndexPath(item: Int(round(scrollView.contentOffset.x / scrollView.frame.width)), section: 0), animated: false, scrollPosition: [])
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
