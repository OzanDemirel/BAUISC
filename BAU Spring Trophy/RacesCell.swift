//
//  RacesCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class RacesCell: BaseCell {
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Medium", size: 8)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(red: 5/255, green: 58/255, blue: 92/255, alpha: 1)
        label.highlightedTextColor = UIColor(red: 251/255, green: 173/255, blue: 24/255, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RacesIcon")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(icon)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: icon)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: icon)
        
        addSubview(name)
        addConstraint(NSLayoutConstraint(item: name, attribute: .centerY, relatedBy: .equal, toItem: icon, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: name, attribute: .centerX, relatedBy: .equal, toItem: icon, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: name)
        
    }
    
}
