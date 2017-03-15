//
//  ResultsVC.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 14/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class TeamsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var teamsTableView: UITableView!
    
    var teamInfoVC: TeamInfoVC!
    
    var homeVC: HomeVC?
    
    let cellId = "teamsCell"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        teamsTableView.delegate = self
        teamsTableView.dataSource = self
        teamsTableView.register(TeamsCell.self, forCellReuseIdentifier: cellId)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        teamsTableView.deselectRow(at: indexPath, animated: true)
        
        
        homeVC?.addTeamInfoPageToView()
        homeVC?.mainScrollView.isScrollEnabled = false
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = teamsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TeamsCell
        cell.setupViews(rowId: indexPath.row)
        return cell
    }
    

}
