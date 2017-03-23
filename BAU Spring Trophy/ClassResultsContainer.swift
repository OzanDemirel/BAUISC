//
//  ClassResultsContainer.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class ClassResultsContainer: BaseCell, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        return table
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor(red: 182/255, green: 133/255, blue: 17/255, alpha: 1)
        return indicator
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 182/255, green: 133/255, blue: 17/255, alpha: 1)
        label.font = UIFont(name: "Futura", size: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    var status = 0
    
    var results: [Race]? {
        didSet {
            if results != nil, (results?.count)! >= ApiService.sharedInstance.selectedRace, let status = results?[ApiService.sharedInstance.selectedRace].status {
                self.status = status
            }
            if status == 0 {
                statusLabel.text = "Bu yarış henüz gerçekleşmemiştir."
                statusLabel.alpha = 1
            } else if status == 1 {
                statusLabel.alpha = 0
            } else if status == 2 {
                statusLabel.text = "Bu yarış iptal edilmiştir."
                statusLabel.alpha = 1
            }
            tableView.reloadData()
            if results != nil {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
        }
    }
    
    let cellId = "classResultsCell"
    
    let classes = ["IRC0", "IRC1", "IRC2", "IRC3", "IRC4", "GEZGİN"]
    
    override func setupViews() {
        super.setupViews()
        
        tableView.register(ClassResultsCell.self, forCellReuseIdentifier: cellId)
        
        addSubview(activityIndicator)
        addConstraintsWithVisualFormat(format: "H:|-\(UIScreen.main.bounds.width / 2 - 20)-[v0(40)]-\(UIScreen.main.bounds.width / 2 - 20)-|", views: activityIndicator)
        addConstraintsWithVisualFormat(format: "V:|-40-[v0(40)]", views: activityIndicator)
        
        addSubview(statusLabel)
        addConstraintsWithVisualFormat(format: "H:|-40-[v0]-40-|", views: statusLabel)
        addConstraintsWithVisualFormat(format: "V:|-50-[v0(60)]", views: statusLabel)
        activityIndicator.startAnimating()
        
        addSubview(tableView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: tableView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: tableView)
        
        fetchResults()

        NotificationCenter.default.addObserver(self, selector: #selector(ClassResultsContainer.setTablePosition), name: NSNotification.Name("AnyChildAddedToView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ClassResultsContainer.fetchResults), name: NSNotification.Name("dayOrRaceSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ClassResultsContainer.fetchResults), name: NSNotification.Name("categorySelected"), object: nil)
        
    }

    func fetchResults() {
        
        statusLabel.alpha = 0
        results = nil
        
        ApiService.sharedInstance.fetchResult(day: ApiService.sharedInstance.selectedDay) { (races) in
            self.results = races
        }
        
    }

    func setTablePosition() {
        
        statusLabel.alpha = 0
        results = nil
        
        ApiService.sharedInstance.fetchResult(day: 0) { (races: [Race]) in
            self.results = races
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let team = results?[ApiService.sharedInstance.selectedRace].participantsByPlaceOfClass[indexPath.section]?[indexPath.row].team {
            
            NotificationCenter.default.post(name: NSNotification.Name("teamSelected"), object: nil, userInfo: ["team": team])
            
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
            label.text = classes[section]
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ClassResultsCell
        if let participant = results?[ApiService.sharedInstance.selectedRace].participantsByPlaceOfClass[indexPath.section]?[indexPath.row] {
            cell.participant = participant
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return status == 1 ? (results?[ApiService.sharedInstance.selectedRace].participantsByPlaceOfClass.count ?? 0) : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?[ApiService.sharedInstance.selectedRace].participantsByPlaceOfClass[section]!.count ?? 0
    }
    
}
