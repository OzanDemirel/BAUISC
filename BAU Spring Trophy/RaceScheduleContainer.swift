//
//  RaceScheduleContainer.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 15/04/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class RaceScheduleContainer: BaseCell, UITableViewDelegate, UITableViewDataSource {
    
    var schedule = [Day]() {
        didSet {
            activityIndicator.stopAnimating()
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.allowsSelection = false
        table.bounces = false
        return table
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor(red: 182/255, green: 133/255, blue: 17/255, alpha: 1)
        return indicator
    }()
    
    let cellId = "raceScheduleCell"
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(activityIndicator)
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintsWithVisualFormat(format: "H:[v0(40)]", views: activityIndicator)
        addConstraintsWithVisualFormat(format: "V:[v0(40)]", views: activityIndicator)
        activityIndicator.startAnimating()
        
        tableView.register(RaceScheduleCell.self, forCellReuseIdentifier: cellId)
        
        addSubview(tableView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: tableView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: tableView)
        
        ApiService.sharedInstance.fetchSchedule { (schedule) in
            self.schedule = schedule
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 24))
            view.backgroundColor = UIColor(red: 9/255, green: 63/255, blue: 99/255, alpha: 1)
            return view
        }()
        
        let backgroundImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "SectionHeaderBackground")
            return imageView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "Futura-Bold", size: 8)
            label.textColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
            label.text = schedule[section].Name
            return label
        }()
        
        headerView.addSubview(backgroundImageView)
        headerView.addConstraintsWithVisualFormat(format: "H:|-40-[v0]-40-|", views: backgroundImageView)
        headerView.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: backgroundImageView)
        
        headerView.addSubview(titleLabel)
        headerView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: headerView, attribute: .centerX, multiplier: 1, constant: 0))
        headerView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 0))
        headerView.addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: titleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule[section].Content.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RaceScheduleCell
        cell.content = "- " + schedule[indexPath.section].Content[indexPath.row].Name
        return cell
    }
    
}
