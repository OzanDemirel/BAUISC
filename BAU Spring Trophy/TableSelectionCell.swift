//
//  TableSelectionCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class TableSelectionCell: BaseCell {
    
    var sectionTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 182/255, green: 133/255, blue: 17/255, alpha: 1)
        lbl.highlightedTextColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        lbl.numberOfLines = 2
        lbl.font = UIFont(name: "Futura-Medium", size: 9)
        return lbl
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(sectionTitle)
        addConstraint(NSLayoutConstraint(item: sectionTitle, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: sectionTitle)
        
    }
    
}
