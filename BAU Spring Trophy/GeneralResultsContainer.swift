//
//  GeneralResultsContainer.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 16/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class GeneralResultsContainer: BaseCell, UITableViewDelegate, UITableViewDataSource {
    
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
        indicator.color = UIColor(red: 251/255, green: 173/255, blue: 24/255, alpha: 1)
        return indicator
    }()
    
    let cellId = "generalResultsCell"
    
    var status = 0
    
    var results: [Race]? {
        didSet {
            if results != nil, (results?.count)! >= ApiService.sharedInstance.selectedRace, let status = results?[ApiService.sharedInstance.selectedRace].status {
                self.status = status
            }
            tableView.reloadData()
            if results == nil {
                print("nil")
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        tableView.register(GeneralResultsCell.self, forCellReuseIdentifier: cellId)
        
        addSubview(activityIndicator)
        addConstraintsWithVisualFormat(format: "H:|-\(UIScreen.main.bounds.width / 2 - 20)-[v0(40)]-\(UIScreen.main.bounds.width / 2 - 20)-|", views: activityIndicator)
        addConstraintsWithVisualFormat(format: "H:[v0(40)]", views: activityIndicator)
        addConstraintsWithVisualFormat(format: "V:|-40-[v0(40)]", views: activityIndicator)
        activityIndicator.startAnimating()
        
        addSubview(tableView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: tableView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: tableView)
        
        fetchResults()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GeneralResultsContainer.setTablePosition), name: NSNotification.Name("AnyChildAddedToView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GeneralResultsContainer.fetchResults), name: NSNotification.Name("dayOrRaceSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GeneralResultsContainer.fetchResults), name: NSNotification.Name("categorySelected"), object: nil)
    
    }
    
    func fetchResults() {
        
        ApiService.sharedInstance.fetchResult(day: ApiService.sharedInstance.selectedDay) { (races) in
            self.results = races
        }
        
    }
    
    func setTablePosition() {

        ApiService.sharedInstance.fetchResult(day: 0) { (races: [Race]) in
            self.results = races
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        NotificationCenter.default.post(name: NSNotification.Name("teamSelected"), object: nil)
        
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
