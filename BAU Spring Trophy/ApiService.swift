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
    let racesRef = "races"
    let photosRef = "photos"
    let adsRef = "ads"
    
    var selectedDay: Int = 0 {
        didSet {
            print("Selected Day: \(selectedDay)")
            selectedRace = 0
        }
    }
    var selectedRace: Int = 0 {
        didSet {
            print("Selected Race: \(selectedRace)")
            NotificationCenter.default.post(name: NSNotification.Name("dayOrRaceSelected"), object: nil)
        }
    }
    var selectedCategory: Int = 0 {
        didSet {
            print("Selected Category: \(selectedCategory)")
            NotificationCenter.default.post(name: NSNotification.Name("categorySelected"), object: nil)
        }
    }
    
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
    
    var photos = [Photo]()
    
    func fetchPhotos(_ completion: @escaping ([Photo]) -> ()) {
        
        ref.child(photosRef).observe(FIRDataEventType.value, with: { (snapshot) in
            
            self.photos = []
            
            if let data = snapshot.value as? [String: AnyObject] {
                
                for dictionary in data {
                    
                    if let dict = dictionary.value as? [String: AnyObject] {
                        
                        let photo = Photo()
                        
                        if let order = dict["order"] as? Int {
                            photo.order = order
                        }
                        
                        if let imageURL = dict["imageURL"] as? String {
                            photo.imageURL = imageURL
                        }
                        
                        self.photos.append(photo)
                        
                    }
                    
                }
                
                self.photos = self.photos.sorted(by: { $0.order! > $1.order!})
                
                DispatchQueue.main.async(execute: {
                    completion(self.photos)
                })
            }
            
        })
        
    }
    
    func fetchAds(_ completion: @escaping (Ads) -> ()) {
        
        ref.child(adsRef).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let ads = Ads()
            
            if let data = snapshot.value as? [String: AnyObject] {
                
                if let imageURL = data["imageURL"] as? String {
                    
                    ads.imageURL = imageURL
                }
                
                if let addressURL = data["addressURL"] as? String {
                    
                    ads.addressURL = addressURL
                }
                
                if ads.imageURL != nil  || ads.addressURL != nil  {
                 
                    DispatchQueue.main.async(execute: {
                        completion(ads)
                    })
                }
                return
                
            }
            
        })
        
    }
    
//    func fetchAds(_ completion: @escaping (Ads) -> ()) {
//        
//        ref.child(adsRef).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            let ads = Ads()
//            var adsOrder = AdsOrder()
//            
//            if let data = snapshot.value as? [String: AnyObject] {
//                
//                if let fps = data["fps"] as? Int {
//                    
//                    ads.fps = TimeInterval(fps)
//                }
//                
//                for ad in data.values {
//                    
//                    if let addressURL = ad["addressURL"] as? String {
//                        
//                        adsOrder.addressURL = addressURL
//                        
//                        if let order = ad["order"] as? Int {
//                            
//                            adsOrder.order = order
//                            
//                            if let imageURL = ad["imageURL"] as? String {
//                                
//                                adsOrder.imageURL = imageURL
//                                
//                            }
//                            
//                            ads.order.append(adsOrder)
//                        }
//                    }                
//                }
//                
//                ads.order = ads.order.sorted(by: { ($0.order! < $1.order!) })
//                
//                DispatchQueue.main.async(execute: {
//                    if ads.order.count > 0 {
//                        completion(ads)
//                        return
//                    }
//                    return
//                })
//                
//            }
//            
//        })
//        
//    }
    
    struct Result {
        var day: Int
        var races: [Race]?
    }
    
    var races = [Race]()
    
    var days = [Result(day: 0, races: []), Result(day: 1, races: []), Result(day: 2, races: []), Result(day: 3, races: []), Result(day: 4, races: []), Result(day: 5, races: []), Result(day: 6, races: [])]
    
    func fetchResult(day: Int,_ completion: @escaping ([Race]) -> ()) {
        
        var dayRef: String!
        
        if (days[day].races?.count)! > 0 {
            completion(days[day].races!)
            return
        }
        
        if day == 6 {
            dayRef = "total"
        } else {
            dayRef = "day\(day + 1)"
        }
        
        if teams.isEmpty {
            ApiService.sharedInstance.fetchTeams({ (teams) in
                ApiService.sharedInstance.fetchResult(day: ApiService.sharedInstance.selectedDay, completion)
            })
            return
        }
        
        ref.child(racesRef).child(dayRef).observe(FIRDataEventType.value, with: { (snapshot) in
            
            if let races = snapshot.value as? [String: AnyObject] {
                
                self.races = []
                
                if let race1 = races["race1"] as? [String: AnyObject] {
                    
                    let race = Race()
                    
                    var IRC0 = [Participant]()
                    var IRC1 = [Participant]()
                    var IRC2 = [Participant]()
                    var IRC3 = [Participant]()
                    var IRC4 = [Participant]()
                    var GEZGİN = [Participant]()
                    
                    for team in race1 {
                        
                        if team.key == "status" {
                        
                            race.name = 0
                            
                            if let status = team.value as? Int {
                                race.status = status
                            }
                            
                        } else {
                            
                            if let result = team.value as? [String: AnyObject] {
                                
                                let participant = Participant()
                                
                                if let place = result["place"] as? Int {
                                    
                                    participant.place = place
                                    
                                }
                                
                                if let time = result["time"] as? String {
                                    
                                    participant.finishTime = time
                                    
                                }
                                
                                if let extraTime = result["extraTime"] as? String {
                                    
                                    participant.extraTime = extraTime
                                    
                                }
                                
                                if let boatId = result["boatId"] as? String {
                                    
                                    participant.team = self.teams.first(where: { $0.boatId == boatId })
                                    
                                }
                                
                                race.participantsByPlace.append(participant)
                                
                                if let boatClass = participant.team?.boatClass {
                                    
                                    switch boatClass {
                                    case "IRC0":
                                        IRC0.append(participant)
                                        break;
                                    case "IRC1":
                                        IRC1.append(participant)
                                        break;
                                    case "IRC2":
                                        IRC2.append(participant)
                                        break;
                                    case "IRC3":
                                        IRC3.append(participant)
                                        break;
                                    case "IRC4":
                                        IRC4.append(participant)
                                        break;
                                    case "GEZGİN":
                                        GEZGİN.append(participant)
                                        break;
                                    default:
                                        break;
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    IRC0 = IRC0.sorted(by: { $0.place! < $1.place!})
                    IRC1 = IRC1.sorted(by: { $0.place! < $1.place!})
                    IRC2 = IRC2.sorted(by: { $0.place! < $1.place!})
                    IRC3 = IRC3.sorted(by: { $0.place! < $1.place!})
                    IRC4 = IRC4.sorted(by: { $0.place! < $1.place!})
                    GEZGİN = GEZGİN.sorted(by: { $0.place! < $1.place!})
                    
                    race.participantsByPlace = race.participantsByPlace.sorted(by: { $0.place! < $1.place!})

                    race.participantsByPlaceOfClass = [0 : IRC0, 1: IRC1, 2: IRC2, 3: IRC3, 4: IRC4, 5: GEZGİN]
                    
                    self.races.append(race)
                
                }
            
            
                if let race2 = races["race2"] as? [String: AnyObject] {
                    
                    let race = Race()

                    var IRC0 = [Participant]()
                    var IRC1 = [Participant]()
                    var IRC2 = [Participant]()
                    var IRC3 = [Participant]()
                    var IRC4 = [Participant]()
                    var GEZGİN = [Participant]()
                    
                    for team in race2 {
                        
                        if team.key == "status" {
                            
                            race.name = 1
                            
                            if let status = team.value as? Int {
                                race.status = status
                            }
                            
                        } else {
                            
                            if let result = team.value as? [String: AnyObject] {
                                
                                let participant = Participant()
                                
                                if let place = result["place"] as? Int {
                                    
                                    participant.place = place
                                    
                                }
                                
                                if let time = result["time"] as? String {
                                    
                                    participant.finishTime = time
                                    
                                }
                                
                                if let extraTime = result["extraTime"] as? String {
                                    
                                    participant.extraTime = extraTime
                                    
                                }
                                
                                if let boatId = result["boatId"] as? String {
                                    
                                    participant.team = self.teams.first(where: { $0.boatId == boatId })
                                    
                                }
                                
                                race.participantsByPlace.append(participant)
                                
                                if let boatClass = participant.team?.boatClass {
                                    
                                    switch boatClass {
                                    case "IRC0":
                                        IRC0.append(participant)
                                        break;
                                    case "IRC1":
                                        IRC1.append(participant)
                                        break;
                                    case "IRC2":
                                        IRC2.append(participant)
                                        break;
                                    case "IRC3":
                                        IRC3.append(participant)
                                        break;
                                    case "IRC4":
                                        IRC4.append(participant)
                                        break;
                                    case "GEZGİN":
                                        GEZGİN.append(participant)
                                        break;
                                    default:
                                        break;
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    IRC0 = IRC0.sorted(by: { $0.place! < $1.place!})
                    IRC1 = IRC1.sorted(by: { $0.place! < $1.place!})
                    IRC2 = IRC2.sorted(by: { $0.place! < $1.place!})
                    IRC3 = IRC3.sorted(by: { $0.place! < $1.place!})
                    IRC4 = IRC4.sorted(by: { $0.place! < $1.place!})
                    GEZGİN = GEZGİN.sorted(by: { $0.place! < $1.place!})
                    
                    race.participantsByPlace = race.participantsByPlace.sorted(by: { $0.place! < $1.place!})
                    
                    race.participantsByPlaceOfClass = [0 : IRC0, 1: IRC1, 2: IRC2, 3: IRC3, 4: IRC4, 5: GEZGİN]
                    
                    self.races.append(race)
                    
                }
                
                if let race3 = races["race3"] as? [String: AnyObject] {
                    
                    let race = Race()

                    var IRC0 = [Participant]()
                    var IRC1 = [Participant]()
                    var IRC2 = [Participant]()
                    var IRC3 = [Participant]()
                    var IRC4 = [Participant]()
                    var GEZGİN = [Participant]()
                    
                    for team in race3 {
                        
                        if team.key == "status" {
                            
                            race.name = 2
                            
                            if let status = team.value as? Int {
                                race.status = status
                            }
                            
                        } else {
                            
                            if let result = team.value as? [String: AnyObject] {
                                
                                let participant = Participant()
                                
                                if let place = result["place"] as? Int {
                                    
                                    participant.place = place
                                    
                                }
                                
                                if let time = result["time"] as? String {
                                    
                                    participant.finishTime = time
                                    
                                }
                                
                                if let extraTime = result["extraTime"] as? String {
                                    
                                    participant.extraTime = extraTime
                                    
                                }
                                
                                if let boatId = result["boatId"] as? String {
                                    
                                    participant.team = self.teams.first(where: { $0.boatId == boatId })
                                    
                                }
                                
                                race.participantsByPlace.append(participant)
                                
                                if let boatClass = participant.team?.boatClass {
                                    
                                    switch boatClass {
                                    case "IRC0":
                                        IRC0.append(participant)
                                        break;
                                    case "IRC1":
                                        IRC1.append(participant)
                                        break;
                                    case "IRC2":
                                        IRC2.append(participant)
                                        break;
                                    case "IRC3":
                                        IRC3.append(participant)
                                        break;
                                    case "IRC4":
                                        IRC4.append(participant)
                                        break;
                                    case "GEZGİN":
                                        GEZGİN.append(participant)
                                        break;
                                    default:
                                        break;
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    IRC0 = IRC0.sorted(by: { $0.place! < $1.place!})
                    IRC1 = IRC1.sorted(by: { $0.place! < $1.place!})
                    IRC2 = IRC2.sorted(by: { $0.place! < $1.place!})
                    IRC3 = IRC3.sorted(by: { $0.place! < $1.place!})
                    IRC4 = IRC4.sorted(by: { $0.place! < $1.place!})
                    GEZGİN = GEZGİN.sorted(by: { $0.place! < $1.place!})
                    
                    race.participantsByPlace = race.participantsByPlace.sorted(by: { $0.place! < $1.place!})
                    
                    race.participantsByPlaceOfClass = [0 : IRC0, 1: IRC1, 2: IRC2, 3: IRC3, 4: IRC4, 5: GEZGİN]
                    
                    self.races.append(race)
                    
                }
                
                
                if let overall = races["overall"] as? [String: AnyObject] {
                    
                    let race = Race()

                    var IRC0 = [Participant]()
                    var IRC1 = [Participant]()
                    var IRC2 = [Participant]()
                    var IRC3 = [Participant]()
                    var IRC4 = [Participant]()
                    var GEZGİN = [Participant]()
                    
                    for team in overall {
                        
                        if team.key == "status" {
                            
                            race.name = 3
                            
                            if let status = team.value as? Int {
                                race.status = status
                            }
                            
                        } else {
                            
                            if let result = team.value as? [String: AnyObject] {
                                
                                let participant = Participant()
                                
                                if let place = result["place"] as? Int {
                                    
                                    participant.place = place
                                    
                                }
                                
                                if let time = result["time"] as? String {
                                    
                                    participant.finishTime = time
                                    
                                }
                                
                                if let extraTime = result["extraTime"] as? String {
                                    
                                    participant.extraTime = extraTime
                                    
                                }
                                
                                if let boatId = result["boatId"] as? String {
                                    
                                    participant.team = self.teams.first(where: { $0.boatId == boatId })
                                    
                                }
                                
                                race.participantsByPlace.append(participant)
                                
                                if let boatClass = participant.team?.boatClass {
                                    
                                    switch boatClass {
                                    case "IRC0":
                                        IRC0.append(participant)
                                        break;
                                    case "IRC1":
                                        IRC1.append(participant)
                                        break;
                                    case "IRC2":
                                        IRC2.append(participant)
                                        break;
                                    case "IRC3":
                                        IRC3.append(participant)
                                        break;
                                    case "IRC4":
                                        IRC4.append(participant)
                                        break;
                                    case "GEZGİN":
                                        GEZGİN.append(participant)
                                        break;
                                    default:
                                        break;
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    IRC0 = IRC0.sorted(by: { $0.place! < $1.place!})
                    IRC1 = IRC1.sorted(by: { $0.place! < $1.place!})
                    IRC2 = IRC2.sorted(by: { $0.place! < $1.place!})
                    IRC3 = IRC3.sorted(by: { $0.place! < $1.place!})
                    IRC4 = IRC4.sorted(by: { $0.place! < $1.place!})
                    GEZGİN = GEZGİN.sorted(by: { $0.place! < $1.place!})
                    
                    race.participantsByPlace = race.participantsByPlace.sorted(by: { $0.place! < $1.place!})
                    
                    race.participantsByPlaceOfClass = [0 : IRC0, 1: IRC1, 2: IRC2, 3: IRC3, 4: IRC4, 5: GEZGİN]
                    
                    self.races.append(race)
                    
                }
                
                self.races = self.races.sorted(by: {$0.name < $1.name})
                
                self.days[day].races = self.races
                
                DispatchQueue.main.async(execute: { 
                    
                    if let races = self.days[day].races {
                        
                        completion(races)
                        
                    }
                    
                })

            }
            
        })
        
    }
    
}
