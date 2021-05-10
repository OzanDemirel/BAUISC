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
        table.bounces = false
        return table
    }()
    
    var activeRaitingType: String = "IRC" {
        didSet{
            ApiService.sharedInstance.selectedRaitingType = activeRaitingType
        }
    }
    
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
    
    var isReleased = 0
    var isOfficial = 0
    
    var results: [Race]? {
        didSet {
            if results != nil, (results?.count)! >= ApiService.sharedInstance.selectedRace, let isReleased = results?[ApiService.sharedInstance.selectedRace].isReleased {
                self.isReleased = isReleased
                if let isOfficial = results?[ApiService.sharedInstance.selectedRace].isOfficial {
                    self.isOfficial = isOfficial
                }
            }
            if isReleased == 0 {
                resultStatusLabel.alpha = 0
                statusLabel.text = "Bu yarış henüz gerçekleşmemiştir."
                statusLabel.alpha = 1
            } else if isReleased == 1 {
                statusLabel.alpha = 0
                if isOfficial == 0 {
                    resultStatusLabel.text = "RESMİ OLMAYAN SONUÇLAR"
                } else if isOfficial == 1 {
                    resultStatusLabel.text = "RESMİ SONUÇLAR"
                }
                resultStatusLabel.alpha = 1
    
                setRaitingType("")
                
            } else if isReleased == 2 {
                resultStatusLabel.alpha = 0
                statusLabel.text = "Bu yarış gerçekleşmemiştir."
                statusLabel.alpha = 1
            } else if isReleased == 3 {
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.raitingTypeSelected(_:)), name: NSNotification.Name("raitingTypeSelectedInResultsPage"), object: nil)
        
    }
    
    @objc func raitingTypeSelected(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let id = dict["identifier"] as? String {
                if id == "IRC" || id == "ORC" {
                    setRaitingType(id)
                }
            }
        }
    }
    
    func setRaitingType(_ type: String) {
        
        if type == "IRC" || type == "ORC" {
            if isReleased == 1 {
                if type == "IRC" && results?[ApiService.sharedInstance.selectedRace].ircGeneralCategory.count ?? 0 > 0 && activeRaitingType != type {
                    activeRaitingType = type
                    //ApiService.sharedInstance.selectedRaitingType = "IRC"
                } else if type == "ORC" && results?[ApiService.sharedInstance.selectedRace].orcGeneralCategory.count ?? 0 > 0 && activeRaitingType != type {
                    activeRaitingType = type
                    //ApiService.sharedInstance.selectedRaitingType = "ORC"
                } else {
                    presentAlert(selectedRaitingType: type, reselectRaitingType: true)
//                    if activeRaitingType == "IRC" {
//                        activeRaitingType = "ORC"
//                    } else {
//                        activeRaitingType = "IRC"
//                    }
                }
            } else {
                presentAlert(selectedRaitingType: "", reselectRaitingType: false)
            }
        } else {
            if ApiService.sharedInstance.selectedRaitingType == "IRC" && !(results?[ApiService.sharedInstance.selectedRace].ircGeneralCategory.count ?? 0 > 0) {
                if results?[ApiService.sharedInstance.selectedRace].orcGeneralCategory.count ?? 0 > 0 {
                    activeRaitingType = "ORC"
                }
            } else if ApiService.sharedInstance.selectedRaitingType == "ORC" && !(results?[ApiService.sharedInstance.selectedRace].orcGeneralCategory.count ?? 0 > 0) {
                if results?[ApiService.sharedInstance.selectedRace].ircGeneralCategory.count ?? 0 > 0 {
                    activeRaitingType = "IRC"
                }
            }
        }
        
    }
    
    @objc func fetchResults() {
        
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        resultStatusLabel.alpha = 0
        statusLabel.alpha = 0
        isReleased = -1
        results = nil
        

        ApiService.sharedInstance.fetchResult(day: ApiService.sharedInstance.selectedDay) { (races) in
            self.results = races
        }
        
    }
    
    @objc func setTablePosition() {
        
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        resultStatusLabel.alpha = 0
        statusLabel.alpha = 0
        isReleased = -1
        results = nil
        
        ApiService.sharedInstance.fetchResult(day: 0) { (races: [Race]) in
            self.results = races
        }
        
    }
    
    func presentAlert(selectedRaitingType: String, reselectRaitingType: Bool) {
        
        let alert = UIAlertController(title: "Unreleased Results", message: "\(selectedRaitingType) Results havent been published yet.", preferredStyle: UIAlertController.Style.alert)
        if reselectRaitingType {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { (notification) in
                NotificationCenter.default.post(name: NSNotification.Name("raitingTypeHasBeenSetted"), object: nil)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        }
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let team = results?[ApiService.sharedInstance.selectedRace].ircGeneralCategory[0].classMembers[indexPath.row].team {
            
            NotificationCenter.default.post(name: NSNotification.Name("teamSelected"), object: nil, userInfo: ["team": team])
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GeneralResultsCell
        cell.participant = results?[ApiService.sharedInstance.selectedRace].ircGeneralCategory[0].classMembers[indexPath.row]
        cell.setPlace(place: indexPath.row)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isReleased == 1 ? (results?[ApiService.sharedInstance.selectedRace].ircGeneralCategory[0].classMembers.count ?? 0) : 0
    }
    
}
