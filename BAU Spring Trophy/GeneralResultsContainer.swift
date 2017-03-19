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
    
    let cellId = "generalResultsCell"
    
    var results: [Race]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        tableView.register(GeneralResultsCell.self, forCellReuseIdentifier: cellId)
        
        addSubview(tableView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: tableView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GeneralResultsContainer.setTablePosition), name: NSNotification.Name("AnyChildAddedToView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GeneralResultsContainer.resultsReceived(_:)), name: NSNotification.Name("resultsReceived"), object: nil)
    
    }
    
    func resultsReceived(_ notification: NSNotification) {
        
        if let info = notification.userInfo?.first?.value as? [Race] {
            results = info
        }
    }
    
    func setTablePosition() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.middle, animated: false)
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
        
        if results != nil {
            return results![ApiService.sharedInstance.selectedRace].participantsByPlace.count
        }
        return 0
    }
    
}
