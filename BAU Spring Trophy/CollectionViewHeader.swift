//
//  CollectionViewHeader.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 05/05/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SectionHeaderBackground")
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Bold", size: 10)
        label.textColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(backgroundImageView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: backgroundImageView)
        addConstraintsWithVisualFormat(format: "V:|-1-[v0]-1-|", views: backgroundImageView)
        
        addSubview(titleLabel)
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintsWithVisualFormat(format: "V:[v0(12)]", views: titleLabel)
        
    }

}
