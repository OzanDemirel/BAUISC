//
//  ApiService.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 13/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let ref = FIRDatabase.database().reference()
    let newsRef = "news"
    let teamsRef = "teams"
    
    var news = [News]()
    
    func fetchNews(_ completion: @escaping ([News]) -> ()) {
        
        ref.child(newsRef).observe(FIRDataEventType.value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String: AnyObject] {
                
                self.news = []
                
                for dictionary in data {
                    
                    if let dict = dictionary.value as? [String: AnyObject] {

                        let new = News()
                    
                        if let title = dict["title"] as? String {
                            new.title = title
                        }
                    
                        if let content = dict["content"] as? String {
                            new.content = content
                        }
                    
                        if let order = dict["order"] as? Int {
                            new.order = order
                        }
                    
                        if let url = dict["image"] as? String {
                            new.imageURL = url
                        }
                    
                        self.news.append(new)
                    
                    }
            
                }
                
                self.news = self.news.sorted(by: { $0.order! > $1.order!})
                
                DispatchQueue.main.async(execute: { 
                    completion(self.news)
                })
            }
            
        })
        
    }
    
    var teams = [Team]()
    
    func fetchTeams(_ completion: @escaping ([Team]) -> ()) {
        
        ref.child(teamsRef).observe(FIRDataEventType.value, with: { (snapshot) in
            
            self.teams = []
            
            if let data = snapshot.value as? [String: AnyObject] {
                
                for dictionary in data {
                    
                    if let dict = dictionary.value as? [String: AnyObject] {
                        
                        let team = Team()
                        
                        if let teamName = dict["teamName"] as? String {
                            team.teamName = teamName
                        }
                        
                        if let boatClass = dict["boatClass"] as? String {
                            team.boatClass = boatClass
                        }
                        
                        if let boatId = dict["boatId"] as? String {
                            team.boatId = boatId
                        }
                        
                        if let boatRaiting = dict["boatRaiting"] as? String {
                            team.boatRaiting = boatRaiting
                        }
                        
                        if let boatType = dict["boatType"] as? String {
                            team.boatType = boatType
                        }
                        
                        if let skipper = dict["skipper"] as? String {
                            team.skipper = skipper
                        }
                        
                        if let crew = dict["crew"] as? [String] {
                            team.crew = crew
                        }
                        
                        self.teams.append(team)
                        
                    }
                    
                }
                
                DispatchQueue.main.async(execute: {
                    completion(self.teams)
                })
            }
            
        })
        
    }
    
    
    
//    func fetchData(completion: @escaping (([String]) -> Void)) {
//
//        ref.child("news").queryOrdered(byChild: "order").observe(.value, with: { (news) in
//
//            print(news)
////            if let news = news.value as? [String:AnyObject] {
//                
////                for value in news {
////                    
////                    if let dict = value.value as? [String:AnyObject] {
////                        
////                        if let order = dict["title"] as? String {
////                            
////                        }
////                        
////                    }
////                    
////                }
////            }
////            print(orders)
//        })
//        
//    }
    
}
