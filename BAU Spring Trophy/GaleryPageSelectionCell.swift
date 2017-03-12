//
//  GaleryPageSelectionCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 11/03/2017.
// Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class GaleryPageSelectionCell: BaseCell {
    
    var sectionTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 182/255, green: 133/255, blue: 17/255, alpha: 1)
        lbl.highlightedTextColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        lbl.textAlignment = NSTextAlignment.center
        lbl.font = UIFont(name: "Futura-Medium", size: 9)
        return lbl
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(sectionTitle)
        addConstraintsWithVisualFormat(format: "V:|-4-[v0]-4-|", views: sectionTitle)
        addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: sectionTitle)
        
    }
    
}
