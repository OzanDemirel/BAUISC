//
//  GeneralResultsContainer.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class GeneralResultsContainer: BaseCell, UITableViewDelegate, UITableViewDataSource {
    
    var homeVC: HomeVC?
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        //table.contentInset.top = 40
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
        label.font = UIFont(name: "Futura-Book", size: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    let resultStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.font = UIFont(name: "Futura-Book", size: 14)
        label.backgroundColor = UIColor(red: 9/255, green: 63/255, blue: 99/255, alpha: 1)
        //label.layer.shadow
        label.textAlignment = .center
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    let cellId = "generalResultsCell"
    
    var status = 0
    var resultStatus = 0
    
    var results: [Race]? {
        didSet {
            if results != nil, (results?.count)! >= ApiService.sharedInstance.selectedRace, let status = results?[ApiService.sharedInstance.selectedRace].status {
                self.status = status
                if let resultStatus = results?[ApiService.sharedInstance.selectedRace].resultStatus {
                    self.resultStatus = resultStatus
                }
            }
            if status == 0 {
                resultStatusLabel.alpha = 0
                statusLabel.text = "Bu yarış henüz gerçekleşmemiştir."
                statusLabel.alpha = 1
            } else if status == 1 {
                statusLabel.alpha = 0
                if resultStatus == 0 {
                    resultStatusLabel.text = "RESMİ OLMAYAN SONUÇLAR"
                } else if resultStatus == 1 {
                    resultStatusLabel.text = "RESMİ SONUÇLAR"
                }
                resultStatusLabel.alpha = 1
            } else if status == 2 {
                resultStatusLabel.alpha = 0
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
    
    override func setupViews() {
        super.setupViews()
        
        tableView.register(GeneralResultsCell.self, forCellReuseIdentifier: cellId)

        addSubview(activityIndicator)
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithVisualFormat(format: "H:[v0(40)]", views: activityIndicator)
        addConstraintsWithVisualFormat(format: "V:|-40-[v0(40)]", views: activityIndicator)
        activityIndicator.startAnimating()
        
        addSubview(statusLabel)
        addConstraintsWithVisualFormat(format: "H:|-40-[v0]-40-|", views: statusLabel)
        addConstraintsWithVisualFormat(format: "V:|-50-[v0(60)]", views: statusLabel)
        
        addSubview(resultStatusLabel)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: resultStatusLabel)
        addConstraintsWithVisualFormat(format: "V:|[v0(40)]", views: resultStatusLabel)
        
        addSubview(tableView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: tableView)
        addConstraintsWithVisualFormat(format: "V:|-40-[v0]|", views: tableView)
        
        layoutIfNeeded()
        
        fetchResults()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GeneralResultsContainer.setTablePosition), name: NSNotification.Name("AnyChildAddedToView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GeneralResultsContainer.fetchResults), name: NSNotification.Name("dayOrRaceSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GeneralResultsContainer.fetchResults), name: NSNotification.Name("categorySelected"), object: nil)
    
    }
    
    func fetchResults() {
        
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        resultStatusLabel.alpha = 0
        statusLabel.alpha = 0
        status = -1
        results = nil
        
        ApiService.sharedInstance.fetchResult(day: ApiService.sharedInstance.selectedDay) { (races) in
            self.results = races
        }
        
    }
    
    func setTablePosition() {
        
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        resultStatusLabel.alpha = 0
        statusLabel.alpha = 0
        status = -1
        results = nil
        
        ApiService.sharedInstance.fetchResult(day: 0) { (races: [Race]) in
            self.results = races
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let team = results?[ApiService.sharedInstance.selectedRace].participantsByPlace[indexPath.row].team {
            
            NotificationCenter.default.post(name: NSNotification.Name("teamSelected"), object: nil, userInfo: ["team": team])
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GeneralResultsCell
        cell.participant = results?[ApiService.sharedInstance.selectedRace].participantsByPlace[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return status == 1 ? (results?[ApiService.sharedInstance.selectedRace].participantsByPlace.count ?? 0) : 0
    }
    
}
