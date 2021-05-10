//
//  RaceSelectionCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 07/04/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class RacesSelectionCell: BaseCell {
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Book", size: 10)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SelectionIcon")
        imageView.highlightedImage = UIImage(named: "SelectionIconHighlighted")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(name)
        addConstraintsWithVisualFormat(format: "V:|-\((frame.height - 40) / 2)-[v0(24)]", views: name)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: name)
        
        addSubview(icon)
        addConstraintsWithVisualFormat(format: "H:|-14-[v0(22)]-14-|", views: icon)
        addConstraintsWithVisualFormat(format: "V:[v0(11)]-\((frame.height - 40) / 2)-|", views: icon)
        
    }
    
}
