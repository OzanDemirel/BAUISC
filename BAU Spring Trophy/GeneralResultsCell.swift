//
//  GeneralResultsCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class GeneralResultsCell: UITableViewCell {
    
    var participant: Participant? {
        didSet {
            if let participant = participant {
                if let team = participant.team {
                    teamName.text = "- " + ((team.teamName)?.uppercased())!
                }
                if let team = participant.team {
                    boatType.text = team.boatType?.uppercased()
                    
//                    if let ircRank = participant.ircRank {
//                        rank.text = String(ircRank)
//                    }
                    
                    rank.text = participant.ircPoint
                    boatClass.text = team.ircClass?.uppercased()
                    boatRaiting.text = team.ircRaiting
                    
                    score.text = participant.ircScore
                }
            }
            setupViews()
        }
    }
    
    let cellIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TableCellIcon")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    let seperatorBar: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 0.6)
        return imageView
    }()
    
    let teamName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "Futura-Bold", size: 10)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let arrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TableCellArrow")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    let boatType: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 1)
        label.font = UIFont(name: "Futura-Book", size: 8)
        return label
    }()
    
    let rank: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "Futura-Bold", size: 10)
        label.textAlignment = .right
        return label
    }()
    
    let boatClass: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 1)
        label.font = UIFont(name: "Futura-Book", size: 8)
        label.textAlignment = .right
        return label
    }()
    
    let boatRaiting: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 1)
        label.font = UIFont(name: "Futura-Book", size: 8)
        return label
    }()
    
    let score: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.font = UIFont(name: "Futura-Book", size: 8)
        label.textAlignment = .right
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
        
        addSubview(arrowIcon)
        addConstraintsWithVisualFormat(format: "H:[v0(16)]-40-|", views: arrowIcon)
        addConstraintsWithVisualFormat(format: "V:[v0(16)]", views: arrowIcon)
        addConstraint(NSLayoutConstraint(item: arrowIcon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addSubview(teamName)
        addConstraintsWithVisualFormat(format: "H:|-60-[v0]-\(frame.width / 5 + 80)-|", views: teamName)
        addConstraintsWithVisualFormat(format: "V:[v0(12)]", views: teamName)
        addConstraint(NSLayoutConstraint(item: teamName, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addSubview(boatRaiting)
        addConstraintsWithVisualFormat(format: "H:|-60-[v0]-\(frame.width / 2)-|", views: boatRaiting)
        addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: boatRaiting)
        addConstraint(NSLayoutConstraint(item: boatRaiting, attribute: .top, relatedBy: .equal, toItem: teamName, attribute: .bottom, multiplier: 1, constant: 2))
        
        addSubview(boatType)
        addConstraintsWithVisualFormat(format: "H:|-60-[v0]-\(frame.width / 2)-|", views: boatType)
        addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: boatType)
        addConstraint(NSLayoutConstraint(item: boatType, attribute: .bottom, relatedBy: .equal, toItem: teamName, attribute: .top, multiplier: 1, constant: -2))
        
        addSubview(rank)
        addConstraintsWithVisualFormat(format: "H:[v0(\(frame.width / 5))]-68-|", views: rank)
        addConstraintsWithVisualFormat(format: "V:[v0(12)]", views: rank)
        addConstraint(NSLayoutConstraint(item: rank, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addSubview(boatClass)
        addConstraintsWithVisualFormat(format: "H:[v0(\(frame.width / 6))]-68-|", views: boatClass)
        addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: boatClass)
        addConstraint(NSLayoutConstraint(item: boatClass, attribute: .bottom, relatedBy: .equal, toItem: rank, attribute: .top, multiplier: 1, constant: -2))
        
        addSubview(score)
        addConstraintsWithVisualFormat(format: "H:[v0(\(frame.width / 6))]-68-|", views: score)
        addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: score)
        addConstraint(NSLayoutConstraint(item: score, attribute: .top, relatedBy: .equal, toItem: rank, attribute: .bottom, multiplier: 1, constant: 2))
        
    }
    
    func setPlace(place: Int) {
        if let teamName = teamName.text {
            self.teamName.text = "\(place + 1)" + teamName
        }
    }
    
}
