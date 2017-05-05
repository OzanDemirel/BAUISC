//
//  RaceScheduleCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 02/05/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class RaceScheduleCell: UITableViewCell {
    
    var content: String? {
        didSet {
            if let name = content {
                self.name.text = name
            }
            setupViews()
        }
    }
    
    let cellIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TableCellIcon")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    let seperatorBar: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 0.6)
        return imageView
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "Futura-Bold", size: 10)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    func setupViews() {
    
        backgroundColor = UIColor(red: 9/255, green: 63/255, blue: 99/255, alpha: 1)
        
        addSubview(cellIcon)
        addConstraintsWithVisualFormat(format: "H:|-40-[v0(8)]", views: cellIcon)
        addConstraintsWithVisualFormat(format: "V:[v0(16)]", views: cellIcon)
        addConstraint(NSLayoutConstraint(item: cellIcon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addSubview(seperatorBar)
        addConstraintsWithVisualFormat(format: "V:[v0(1)]|", views: seperatorBar)
        addConstraintsWithVisualFormat(format: "H:|-40-[v0]-40-|", views: seperatorBar)

        addSubview(name)
        addConstraintsWithVisualFormat(format: "H:|-60-[v0]|", views: name)
        addConstraintsWithVisualFormat(format: "V:[v0(12)]", views: name)
        addConstraint(NSLayoutConstraint(item: name, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
}
