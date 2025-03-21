//
//  TeamInfoPage.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 15/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class TeamInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "crewCell"
    
    var homeVC: HomeVC?
    
    var team: Team? {
        didSet {
            
            boatId.text = team?.boatId?.uppercased()
            boatType.text = team?.boatType?.uppercased()
            
            if let ircClass = team?.ircClass {
                if ircClass != "" {
                    boatClass.text = ircClass
                }
                if let orcClass = team?.orcClass {
                    if orcClass != "" && boatClass.text != "" {
                        boatClass.text = boatClass.text! + " / " + orcClass
                    } else if orcClass != "" {
                        boatClass.text = orcClass
                    }
                    
                }
            }
            
            if let ircRaiting = team?.ircRaiting {
                if ircRaiting != "" {
                    boatRaiting.text = ircRaiting
                }
                if let orcRaiting = team?.orcRaiting {
                    if orcRaiting != "" && boatRaiting.text != "" {
                        boatRaiting.text = boatRaiting.text! + " / " + orcRaiting
                    } else if orcRaiting != "" {
                        boatClass.text = orcRaiting
                    } else {
                        boatRaiting.text = "Unknown"
                    }
                    
                }
            }
            
            teamNameLbl.text = team?.teamName?.uppercased()
            
            crewTableView.reloadData()
        }
    }
    
    @IBOutlet weak var teamInfoImage: DesignableImageView!
    @IBOutlet weak var crewTableView: UITableView!
    @IBOutlet weak var teamsBackground: DesignableImageView!
    @IBOutlet weak var flamaView: UIImageView!
    @IBOutlet weak var teamNameLbl: UILabel!
    
    @IBOutlet weak var flameLeftConstraint: NSLayoutConstraint!
    
    var leftEgdeGesture: UIScreenEdgePanGestureRecognizer!
    var swipeGesture: UISwipeGestureRecognizer!
    
    let seperatorBar1: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 0.6)
        return imageView
    }()
    
    let seperatorBar2: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 0.6)
        return imageView
    }()
    
    let seperatorBar3: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 0.6)
        return imageView
    }()
    
    let _boatId: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        label.font = UIFont(name: "Futura-Bold", size: 8)
        label.text = "YELKEN NUMARASI:"
        return label
    }()
    
    let _boatType: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        label.font = UIFont(name: "Futura-Bold", size: 8)
        label.text = "TEKNE TİPİ:"
        return label
    }()
    
    let _boatRaiting: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        label.font = UIFont(name: "Futura-Bold", size: 8)
        label.text = "TCC / TCL:"
        return label
    }()
    
    let _boatClass: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        label.font = UIFont(name: "Futura-Bold", size: 8)
        label.text = "SINIF:"
        return label
    }()
    
    let boatId: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        label.font = UIFont(name: "Futura-Book", size: 8)
        return label
    }()
    
    let boatType: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        label.font = UIFont(name: "Futura-Book", size: 8)
        return label
    }()
    
    let boatRaiting: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        label.font = UIFont(name: "Futura-Book", size: 8)
        return label
    }()
    
    let boatClass: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        label.font = UIFont(name: "Futura-Book", size: 8)
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crewTableView.delegate = self
        crewTableView.dataSource = self
        crewTableView.register(CrewCell.self, forCellReuseIdentifier: cellId)
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(TeamInfoVC.swipeGestureActive))
        swipeGesture.direction = .right
        
        leftEgdeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(TeamInfoVC.leftEdgeGestureActive(sender:)))
        leftEgdeGesture.edges = .left
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        crewTableView.reloadData()
        
        if team?.crew != nil {
            crewTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.middle, animated: false)
        }
        
        view.addSubview(seperatorBar1)
        view.addConstraint(NSLayoutConstraint(item: seperatorBar1, attribute: .centerY, relatedBy: .equal, toItem: teamInfoImage, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraintsWithVisualFormat(format: "H:|-60-[v0]-60-|", views: seperatorBar1)
        view.addConstraintsWithVisualFormat(format: "V:[v0(1)]", views: seperatorBar1)
        
        view.addSubview(seperatorBar2)
        view.addConstraint(NSLayoutConstraint(item: seperatorBar2, attribute: .centerY, relatedBy: .equal, toItem: teamInfoImage, attribute: .centerY, multiplier: 1, constant: -teamInfoImage.frame.height / 4))
        view.addConstraintsWithVisualFormat(format: "H:|-60-[v0]-60-|", views: seperatorBar2)
        view.addConstraintsWithVisualFormat(format: "V:[v0(1)]", views: seperatorBar2)
        
        view.addSubview(seperatorBar3)
        view.addConstraint(NSLayoutConstraint(item: seperatorBar3, attribute: .centerY, relatedBy: .equal, toItem: teamInfoImage, attribute: .centerY, multiplier: 1, constant: teamInfoImage.frame.height / 4))
        view.addConstraintsWithVisualFormat(format: "H:|-60-[v0]-60-|", views: seperatorBar3)
        view.addConstraintsWithVisualFormat(format: "V:[v0(1)]", views: seperatorBar3)
        
        view.addSubview(_boatId)
        view.addConstraint(NSLayoutConstraint(item: _boatId, attribute: .centerY, relatedBy: .equal, toItem: teamInfoImage, attribute: .centerY, multiplier: 1, constant: -teamInfoImage.frame.height / 8 * 3))
        view.addConstraintsWithVisualFormat(format: "H:|-60-[v0]", views: _boatId)
        view.addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: _boatId)
        
        view.addSubview(boatId)
        view.addConstraint(NSLayoutConstraint(item: boatId, attribute: .centerY, relatedBy: .equal, toItem: teamInfoImage, attribute: .centerY, multiplier: 1, constant: -teamInfoImage.frame.height / 8 * 3))
        view.addConstraint(NSLayoutConstraint(item: boatId, attribute: .leading, relatedBy: .equal, toItem: _boatId, attribute: .trailing, multiplier: 1, constant: 10))
        view.addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: boatId)
        
        view.addSubview(_boatType)
        view.addConstraint(NSLayoutConstraint(item: _boatType, attribute: .centerY, relatedBy: .equal, toItem: teamInfoImage, attribute: .centerY, multiplier: 1, constant: -teamInfoImage.frame.height / 8))
        view.addConstraintsWithVisualFormat(format: "H:|-60-[v0]", views: _boatType)
        view.addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: _boatType)
        
        view.addSubview(boatType)
        view.addConstraint(NSLayoutConstraint(item: boatType, attribute: .centerY, relatedBy: .equal, toItem: teamInfoImage, attribute: .centerY, multiplier: 1, constant: -teamInfoImage.frame.height / 8))
        view.addConstraint(NSLayoutConstraint(item: boatType, attribute: .leading, relatedBy: .equal, toItem: _boatType, attribute: .trailing, multiplier: 1, constant: 10))
        view.addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: boatType)
        
        view.addSubview(_boatRaiting)
        view.addConstraint(NSLayoutConstraint(item: _boatRaiting, attribute: .centerY, relatedBy: .equal, toItem: teamInfoImage, attribute: .centerY, multiplier: 1, constant: teamInfoImage.frame.height / 8))
        view.addConstraintsWithVisualFormat(format: "H:|-60-[v0]", views: _boatRaiting)
        view.addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: _boatRaiting)
        
        view.addSubview(boatRaiting)
        view.addConstraint(NSLayoutConstraint(item: boatRaiting, attribute: .centerY, relatedBy: .equal, toItem: teamInfoImage, attribute: .centerY, multiplier: 1, constant: teamInfoImage.frame.height / 8))
        view.addConstraint(NSLayoutConstraint(item: boatRaiting, attribute: .leading, relatedBy: .equal, toItem: _boatRaiting, attribute: .trailing, multiplier: 1, constant: 10))
        view.addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: boatRaiting)
        
        view.addSubview(_boatClass)
        view.addConstraint(NSLayoutConstraint(item: _boatClass, attribute: .centerY, relatedBy: .equal, toItem: teamInfoImage, attribute: .centerY, multiplier: 1, constant: teamInfoImage.frame.height / 8 * 3))
        view.addConstraintsWithVisualFormat(format: "H:|-60-[v0]", views: _boatClass)
        view.addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: _boatClass)
        
        view.addSubview(boatClass)
        view.addConstraint(NSLayoutConstraint(item: boatClass, attribute: .centerY, relatedBy: .equal, toItem: teamInfoImage, attribute: .centerY, multiplier: 1, constant: teamInfoImage.frame.height / 8 * 3))
        view.addConstraint(NSLayoutConstraint(item: boatClass, attribute: .leading, relatedBy: .equal, toItem: _boatClass, attribute: .trailing, multiplier: 1, constant: 10))
        view.addConstraintsWithVisualFormat(format: "V:[v0(8)]", views: boatClass)
        
        
    }
    
    @objc func swipeGestureActive() {
        
        if homeVC?.teamsVC.view.frame == homeVC?.homeScrollView.frame {
            homeVC?.removeTeamInfoPageFromView()
        } else {
            homeVC?.removeTeamInfoPageFromViewFromResultsPage()
        }
        
    }
    
    @objc func leftEdgeGestureActive(sender: UIScreenEdgePanGestureRecognizer) {
        
        if sender.state == .began {
            if homeVC?.teamsVC.view.frame == homeVC?.homeScrollView.frame {
                homeVC?.removeTeamInfoPageFromView()
            } else {
                homeVC?.removeTeamInfoPageFromViewFromResultsPage()
            }
        }

    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team?.crew != nil ? (team?.crew?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = crewTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CrewCell
        if let member = team?.crew?[indexPath.row] {
            cell.setupViews(member: member)
        }
        return cell
    }

}
