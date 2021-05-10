//
//  RouteCardsContainer.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 07/04/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class RouteCardsContainer: BaseCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        cv.backgroundColor = UIColor.clear
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader)
        cv.register(RouteCardCell.self, forCellWithReuseIdentifier: "routeCardCell")
        cv.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "collectionViewHeader")
        return cv
    }()
    
    var category1Count = 0
    var category2Count = 0
    
    var routeCardsCategory1: [RouteCard]? {
        didSet {
            if let photoCount = routeCardsCategory1?.count {
                self.category1Count = photoCount
            }
        }
    }
    
    var routeCardsCategory2: [RouteCard]? {
        didSet {
            if let photoCount = routeCardsCategory2?.count {
                self.category2Count = photoCount
            }
        }
    }
    
    var category = ["IRC0  -  IRC1  -  IRC2  -  IRC3", "IRC4  -  GEZGİN"]
    
    override func setupViews() {
        addSubview(collectionView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: collectionView)
        
        fetchRouteCards()
    }
    
    func fetchRouteCards() {
        
        ApiService.sharedInstance.fetchRouteCards { (routeCardsCategory1, routeCardsCategory2) in
            
            self.routeCardsCategory1 = routeCardsCategory1
            self.routeCardsCategory2 = routeCardsCategory2
            self.collectionView.reloadData()
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if let routeCard = routeCardsCategory1?[indexPath.row] {
                imageSelected(routeCard: routeCard)
            }
        } else if indexPath.section == 1 {
            if let routeCard = routeCardsCategory2?[indexPath.row] {
                imageSelected(routeCard: routeCard)
            }
        }
        
    }
    
    func imageSelected(routeCard: RouteCard) {
        if let image = imageCache[routeCard.imageURL] {
            NotificationCenter.default.post(name: NSNotification.Name("didSelectAnImage"), object: nil, userInfo: ["image": image])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "collectionViewHeader", for: indexPath) as! CollectionViewHeader
        header.titleLabel.text = category[indexPath.section]
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 32)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if category1Count > 0 && category2Count > 0 {
            return 2
        } else if category1Count > 0 || category2Count > 0 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return category1Count
        } else if section == 1 {
            return category2Count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "routeCardCell", for: indexPath) as! RouteCardCell
        if indexPath.section == 0 {
            cell.urlString = routeCardsCategory1?[indexPath.row].imageURL
            cell.title.text = routeCardsCategory1?[indexPath.row].title
        } else if indexPath.section == 1 {
            cell.urlString = routeCardsCategory2?[indexPath.row].imageURL
            cell.title.text = routeCardsCategory2?[indexPath.row].title
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2 - 0.5, height: frame.width / 2 - 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
