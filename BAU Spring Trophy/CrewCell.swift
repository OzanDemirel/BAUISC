//
//  CrewCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 15/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class CrewCell: UITableViewCell {
    
    let seperatorBar: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 1)
        return imageView
    }()
    
    let memberName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 1)
        label.font = UIFont(name: "Futura", size: 8)
        return label
    }()
    
    func setupViews(member: String) {
        
        backgroundColor = UIColor(red: 9/255, green: 63/255, blue: 99/255, alpha: 1)
        
        addSubview(seperatorBar)
        addConstraintsWithVisualFormat(format: "V:[v0(1)]|", views: seperatorBar)
        addConstraintsWithVisualFormat(format: "H:|-60-[v0]-60-|", views: seperatorBar)
        
        addSubview(memberName)
        addConstraintsWithVisualFormat(format: "H:|-60-[v0]-60-|", views: memberName)
        addConstraintsWithVisualFormat(format: "V:[v0(10)]", views: memberName)
        addConstraint(NSLayoutConstraint(item: memberName, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        memberName.text = "• " + member.uppercased()

    }
}
