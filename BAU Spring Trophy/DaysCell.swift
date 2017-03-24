//
//  DaysCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class DaysCell: BaseCell {
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Book", size: 8)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SelectionIcon")
        imageView.highlightedImage = UIImage(named: "SelectionIconHighlighted")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(name)
        addConstraintsWithVisualFormat(format: "V:|-\((frame.height - 24) / 2)-[v0(9)]", views: name)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: name)
        
        addSubview(icon)
        addConstraintsWithVisualFormat(format: "H:|-4-[v0(22)]-4-|", views: icon)
        addConstraintsWithVisualFormat(format: "V:[v0(11)]-\((frame.height - 24) / 2)-|", views: icon)
        
    }
    
}
