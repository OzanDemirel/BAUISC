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
    
    @IBOutlet weak var orcFlamaWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ircFlamaWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var orcButton: DesignableButton!
    @IBOutlet weak var ircButton: DesignableButton!

    var teamInfoVC: TeamInfoVC!
    var homeVC: HomeVC?
    
    struct Classes {
        var classTitle: String!
        var classMembers: [Team]?
    }
    
    var teams: [Team]?
    
    let classTitle = ["IRC0", "IRC1", "IRC2", "IRC3", "IRC4", "ORC A", "ORC B", "ORC C", "ORC D", "ORC E", "GEZGİN"]
    var classes = [Classes]()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.raitingTypeSelected), name: NSNotification.Name("raitingTypeSelectedInTeamsPage"), object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(RacesBaseCell.selectFirstItemAtSection), name: NSNotification.Name("aDaySelected"), object: nil)
        
        ircButton.isActive = true
        
        fetchTeams()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if teams != nil {
            setTeams()
            teamsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.middle, animated: false)
        }
        
    }
    
    @objc func raitingTypeSelected() {
        setTeams()
    }
    
    func fetchTeams() {
        
        ApiService.sharedInstance.fetchTeams { (teams: [Team]) in
            self.teams = nil
            self.classes = []
            self.teamsTableView.reloadData()
            if teams.count > 0 {
                self.teams = teams
                self.setTeams()
            }
        }
        
    }
    
    func setTeams() {
        
        if teams != nil {
            
            classes = []
            
            if ircButton.isActive {
                
                var IRC0 = [Team]()
                var IRC1 = [Team]()
                var IRC2 = [Team]()
                var IRC3 = [Team]()
                var IRC4 = [Team]()
                var GEZGİN = [Team]()
                
                for team in teams! {
                    
                    if let ircClass = team.ircClass {
                        
                        switch ircClass {
                        case "IRC0":
                            IRC0.append(team)
                            break;
                        case "IRC1":
                            IRC1.append(team)
                            break;
                        case "IRC2":
                            IRC2.append(team)
                            break;
                        case "IRC3":
                            IRC3.append(team)
                            break;
                        case "IRC4":
                            IRC4.append(team)
                            break;
                        case "GEZGİN":
                            GEZGİN.append(team)
                            break;
                        default:
                            break;
                        }
                        
                    }
                    
                }
                
                for i in classTitle {
                    
                    switch i {
                    case "IRC0":
                        if IRC0.count > 0 {
                            let object = Classes(classTitle: i, classMembers: IRC0)
                            classes.append(object)
                        }
                        break;
                    case "IRC1":
                        if IRC1.count > 0 {
                            let object = Classes(classTitle: i, classMembers: IRC1)
                            classes.append(object)
                        }
                        break;
                    case "IRC2":
                        if IRC2.count > 0 {
                            let object = Classes(classTitle: i, classMembers: IRC2)
                            classes.append(object)
                        }
                        break;
                    case "IRC3":
                        if IRC3.count > 0 {
                            let object = Classes(classTitle: i, classMembers: IRC3)
                            classes.append(object)
                        }
                        break;
                    case "IRC4":
                        if IRC4.count > 0 {
                            let object = Classes(classTitle: i, classMembers: IRC4)
                            classes.append(object)
                        }
                        break;
                    case "GEZGİN":
                        if GEZGİN.count > 0 {
                            let object = Classes(classTitle: i, classMembers: GEZGİN)
                            classes.append(object)
                        }
                        break;
                    default:
                        break;
                    }
                    
                }
                
            } else if orcButton.isActive {
                
                var ORCA = [Team]()
                var ORCB = [Team]()
                var ORCC = [Team]()
                var ORCD = [Team]()
                var ORCE = [Team]()
                var GEZGİN = [Team]()
                
                for team in teams! {
                    
                    if let orcClass = team.orcClass {
                        
                        switch orcClass {
                        case "ORC A":
                            ORCA.append(team)
                            break;
                        case "ORC B":
                            ORCB.append(team)
                            break;
                        case "ORC C":
                            ORCC.append(team)
                            break;
                        case "ORC D":
                            ORCD.append(team)
                            break;
                        case "ORC E":
                            ORCE.append(team)
                            break;
                        case "GEZGİN":
                            GEZGİN.append(team)
                            break;
                        default:
                            break;
                            
                        }
                        
                    }
                    
                }
                
                for i in classTitle {
                    
                    switch i {
                    case "ORC A":
                        if ORCA.count > 0 {
                            let object = Classes(classTitle: i, classMembers: ORCA)
                            classes.append(object)
                        }
                        break;
                    case "ORC B":
                        if ORCB.count > 0 {
                            let object = Classes(classTitle: i, classMembers: ORCB)
                            classes.append(object)
                        }
                        break;
                    case "ORC C":
                        if ORCC.count > 0 {
                            let object = Classes(classTitle: i, classMembers: ORCC)
                            classes.append(object)
                        }
                        break;
                    case "ORC D":
                        if ORCD.count > 0 {
                            let object = Classes(classTitle: i, classMembers: ORCD)
                        classes.append(object)
                        }
                        break;
                    case "ORC E":
                        if ORCE.count > 0 {
                            let object = Classes(classTitle: i, classMembers: ORCE)
                            classes.append(object)
                        }
                        break;
                    case "GEZGİN":
                        if GEZGİN.count > 0 {
                            let object = Classes(classTitle: i, classMembers: GEZGİN)
                            classes.append(object)
                        }
                        break;
                    default:
                        break;
                    }
                    
                }
                
            }
            
            teamsTableView.reloadData()
            
        }
        
    }
    
    @IBAction func categoryButtonPressed(sender: DesignableButton) {
        if sender.isActive == false {
            animateCategoryButtons()
            teamsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.middle, animated: true)
        }
    }
    
    func animateCategoryButtons() {
        
        if ircButton.isActive == true {
            ircFlamaWidthConstraint.constant = ircFlamaWidthConstraint.constant * 0.8
        } else {
            ircFlamaWidthConstraint.constant = ircFlamaWidthConstraint.constant * 1.25
        }
        
        changeStatus(ircButton)
        
        if orcButton.isActive == true {
            orcFlamaWidthConstraint.constant = orcFlamaWidthConstraint.constant * 0.8
        } else {
            orcFlamaWidthConstraint.constant = orcFlamaWidthConstraint.constant * 1.25
        }
        
        changeStatus(orcButton)
    }
    
    func changeStatus(_ button: DesignableButton) {
        
        if button.isActive == true {
            button.isActive = false
        } else {
            button.isActive = true
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
            label.text = classes[section].classTitle
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        teamsTableView.deselectRow(at: indexPath, animated: true)
        
        homeVC?.addTeamInfoPageToView(team: (classes[indexPath.section].classMembers?[indexPath.row])!)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes[section].classMembers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = teamsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TeamsCell
        if ircButton.isActive {
            cell.setupViews(team: (classes[indexPath.section].classMembers?[indexPath.row])!, raitingType: "IRC")
        } else {
            cell.setupViews(team: (classes[indexPath.section].classMembers?[indexPath.row])!, raitingType: "ORC")
        }
        return cell
    }
    

}
