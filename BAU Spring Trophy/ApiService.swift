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
    
    let ref = Database.database().reference()
    let newsRef = "news"
    let teamsRef = "teams"
    let racesRef = "races"
    let photosRef = "photos"
    let adsRef = "ads"
    let raceAccouncementRef = "raceAnnouncement"
    let schedule = "schedule"
    let routeCards = "routeCards"
    
    var selectedDay: Int = 0 {
        didSet {
            selectedRace = 0
        }
    }
    var selectedRace: Int = 0 {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("dayOrRaceSelected"), object: nil)
        }
    }
    var selectedCategory: Int = 0 {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("categorySelected"), object: nil)
        }
    }
    
    var selectedRaitingType: String = "IRC" {
        didSet {
            //NotificationCenter.default.post(name: NSNotification.Name("raitingTypeHasBeenSetted"), object: nil)
        }
    }
    
    func fetchRaceAnnouncement(_ completion: @escaping (String) -> ()) {
        
        ref.child(raceAccouncementRef).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String: AnyObject] {
                
                if let url = data["fileURL"] as? String {
                    
                    completion(url)
                    
                }
                
            }

        })
        
    }
    
    func fetchRouteCards(_ completion: @escaping ([RouteCard], [RouteCard]) -> ()) {
        
        ref.child(routeCards).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String: AnyObject] {
                
                var routeCardsCategory1 = [RouteCard]()
                var routeCardsCategory2 = [RouteCard]()
                
                for aRouteCard in data {
                    
                    var routeCard = RouteCard()
                    
                    if let category = aRouteCard.value["category"] as? Int {
                        
                        routeCard.category = category
                        
                        if let imageURL = aRouteCard.value["imageURL"] as? String {
                            
                            routeCard.imageURL = imageURL
                            
                            if let order = aRouteCard.value["order"] as? Int {
                                
                                routeCard.order = order
                                
                                if let title = aRouteCard.value["title"] as? String {
                                    
                                    routeCard.title = title
                                    
                                    if routeCard.category == 1 {
                                        
                                        routeCardsCategory1.append(routeCard)
                                    } else if routeCard.category == 2 {
                                        
                                        routeCardsCategory2.append(routeCard)
                                    }
                                }
                            }
                        }
                    }
                }
                
                if routeCardsCategory1.count > 0 {
                    
                    routeCardsCategory1 = routeCardsCategory1.sorted(by: { $0.order! < $1.order!})
                }
                
                if routeCardsCategory2.count > 0 {
                    
                    routeCardsCategory2 = routeCardsCategory2.sorted(by: { $0.order! < $1.order!})
                }
                
                DispatchQueue.main.async(execute: { 
                    
                    completion(routeCardsCategory1, routeCardsCategory2)
                })
            }
        })
    }
    
    func fetchSchedule(_ completion: @escaping ([Day]) -> ()) {
        
        ref.child(schedule).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String:AnyObject] {
                
                var schedules = [Day]()
                
                for days in data {
                    
                    if let aDay = days.value as? [String: AnyObject] {
                        
                        var day = Day()
                        
                        if let name = aDay["name"] as? String {
                            
                            day.Name = name
                            
                            if let order = aDay["order"] as? Int {
                                
                                day.Order = order
                                
                                if let contents = aDay["content"] as? [String: AnyObject] {
                                    
                                    var dayContents = [DayContent]()
                                    
                                    for aContent in contents {
                                        
                                        var dayContent = DayContent()
                                        
                                        if let content = aContent.value as? [String: AnyObject] {
                                            
                                            if let name = content["name"] as? String {
                                                
                                                dayContent.Name = name
                                                
                                                if let order = content["order"] as? Int {
                                                    
                                                    dayContent.Order = order
                                                    
                                                    dayContents.append(dayContent)
                                                }
                                            }
                                        }
                                    }
                                    
                                    if dayContents.count > 0 {
                                        
                                        dayContents = dayContents.sorted(by: { $0.Order! < $1.Order!})
                                        day.Content = dayContents
                                        schedules.append(day)
                                    }
                                }
                            }
                        }
                    }
                }
                
                if schedules.count > 0 {
                    
                    schedules = schedules.sorted(by: { $0.Order! < $1.Order!})
                    DispatchQueue.main.async(execute: { 
                        completion(schedules)
                    })
                }
            }
        })
    }
    
    var news = [News]()
    
    func fetchNews(_ completion: @escaping ([News]) -> ()) {
        
        ref.child(newsRef).observe(DataEventType.value, with: { (snapshot) in
            
            self.news = []
            
            if let data = snapshot.value as? [String: AnyObject] {
                
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
                    
                        if let url = dict["imageURL"] as? String {
                            new.imageURL = url
                        }
                    
                        self.news.append(new)
                    
                    }
            
                }
                
                self.news = self.news.sorted(by: { $0.order! > $1.order!})
                NotificationCenter.default.post(name: NSNotification.Name("newsChanged"), object: nil)
                
                DispatchQueue.main.async(execute: { 
                    completion(self.news)
                })
            }
            
        })
        
    }
    
    var teams = [Team]()
    
    func fetchTeams(_ completion: @escaping ([Team]) -> ()) {
        
        ref.child(teamsRef).observe(DataEventType.value, with: { (snapshot) in
            
            self.teams = []
            
            if let data = snapshot.value as? [String: AnyObject] {
                
                for dictionary in data {
                    
                    if let dict = dictionary.value as? [String: AnyObject] {
                        
                        let team = Team()
                        
                        if let teamName = dict["teamName"] as? String {
                            team.teamName = teamName
                        }
                        
                        if let ircClass = dict["ircClass"] as? String {
                            team.ircClass = ircClass
                        }
                        
                        if let orcClass = dict["orcClass"] as? String {
                            team.orcClass = orcClass
                        }
                        
                        if let boatId = dict["boatId"] as? String {
                            team.boatId = boatId
                        }
                        
                        if let ircRaiting = dict["ircRaiting"] as? String {
                            team.ircRaiting = ircRaiting
                        }
                        
                        if let orcRaiting = dict["orcRaiting"] as? String {
                            team.orcRaiting = orcRaiting
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
            
            DispatchQueue.main.async(execute: {
                completion(self.teams)
            })
            
        })
        
    }
    
    var photos = [Photo]()
    
    func fetchPhotos(_ completion: @escaping ([Photo]) -> ()) {
        
        ref.child(photosRef).observe(DataEventType.value, with: { (snapshot) in
            
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
        
        ref.child(racesRef).child(dayRef).observe(DataEventType.value, with: { (snapshot) in
            
            if let races = snapshot.value as? [String: AnyObject] {
                
                self.races = []
                
                if let race1 = races["race1"] as? [String: AnyObject] {
                    
                    let race = Race()
                    
                    var IRC0 = [Participant]()
                    var IRC1 = [Participant]()
                    var IRC2 = [Participant]()
                    var IRC3 = [Participant]()
                    var IRC4 = [Participant]()
                    var IRCGEZGIN = [Participant]()
                    var ircGeneralCategory = [Participant]()
                    
                    var ORCA = [Participant]()
                    var ORCB = [Participant]()
                    var ORCC = [Participant]()
                    var ORCD = [Participant]()
                    var ORCE = [Participant]()
                    var ORCGEZGIN = [Participant]()
                    var orcGeneralCategory = [Participant]()
                    
                    
                    for team in race1 {
                        
                        if team.key == "isReleased" {
                        
                            race.name = 0
                            
                            if let isReleased = team.value as? Int {
                                race.isReleased = isReleased
                            }
                            
                        } else if team.key == "isOfficial" {
                            
                            if let isOfficial = team.value as? Int {
                                race.isOfficial = isOfficial
                            }
                                
                        } else if let result = team.value as? [String: AnyObject] {
                            
                            let participant = Participant()
                            
                            if let rank = result["ircRank"] as? Int {
                                
                                participant.ircRank = rank
                                
                            }
                            
                            if let rank = result["orcRank"] as? Int {
                                
                                participant.orcRank = rank
                                
                            }
                            
                            if let score = result["ircScore"] as? String {
                                
                                participant.ircScore = score
                                
                            }
                            
                            if let score = result["orcScore"] as? String {
                                
                                participant.orcScore = score
                                
                            }
                            
                            if let point = result["ircPoint"] as? String {
                                
                                participant.ircPoint = point
                                
                            }
                            
                            if let point = result["orcPoint"] as? String {
                                
                                participant.orcPoint = point
                                
                            }
                            
                            if let boatId = result["boatId"] as? String {
                                
                                participant.team = self.teams.first(where: { $0.boatId == boatId })
                                
                            }
                            
                            //race.participantsByPlace.append(participant)
                            
                            if let ircClass = participant.team?.ircClass, let _ = participant.ircScore {
                                
                                switch ircClass {
                                case "IRC0":
                                    ircGeneralCategory.append(participant)
                                    IRC0.append(participant)
                                    break;
                                case "IRC1":
                                    ircGeneralCategory.append(participant)
                                    IRC1.append(participant)
                                    break;
                                case "IRC2":
                                    ircGeneralCategory.append(participant)
                                    IRC2.append(participant)
                                    break;
                                case "IRC3":
                                    ircGeneralCategory.append(participant)
                                    IRC3.append(participant)
                                    break;
                                case "IRC4":
                                    IRC4.append(participant)
                                    break;
                                case "GEZGİN":
                                    IRCGEZGIN.append(participant)
                                    break;
                                default:
                                    break;
                                }
                            }
                            
                            if let orcClass = participant.team?.orcClass, let _ = participant.orcScore {
                                
                                switch orcClass {
                                case "ORC A":
                                    orcGeneralCategory.append(participant)
                                    ORCA.append(participant)
                                    break;
                                case "ORC B":
                                    orcGeneralCategory.append(participant)
                                    ORCB.append(participant)
                                    break;
                                case "ORC C":
                                    orcGeneralCategory.append(participant)
                                    ORCC.append(participant)
                                    break;
                                case "ORC D":
                                    orcGeneralCategory.append(participant)
                                    ORCD.append(participant)
                                    break;
                                case "ORC E":
                                    ORCE.append(participant)
                                    break;
                                case "GEZGİN":
                                    ORCGEZGIN.append(participant)
                                    break;
                                default:
                                    break;
                                }
                            }
                            
                        }
                    }
                    
                    if ircGeneralCategory.count > 0 {
                        ircGeneralCategory = ircGeneralCategory.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC 0-1-2-3"
                        participants.classMembers = ircGeneralCategory
                        race.ircGeneralCategory.append(participants)
                    }
            
                    if IRC0.count > 0 {
                        IRC0 = IRC0.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC0"
                        participants.classMembers = IRC0
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC1.count > 0 {
                        IRC1 = IRC1.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC1"
                        participants.classMembers = IRC1
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC2.count > 0 {
                        IRC2 = IRC2.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC2"
                        participants.classMembers = IRC2
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC3.count > 0 {
                        IRC3 = IRC3.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC3"
                        participants.classMembers = IRC3
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC4.count > 0 {
                        IRC4 = IRC4.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC4"
                        participants.classMembers = IRC4
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRCGEZGIN.count > 0 {
                        IRCGEZGIN = IRCGEZGIN.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "GEZGİN"
                        participants.classMembers = IRCGEZGIN
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    
                    if orcGeneralCategory.count > 0 {
                        print("count: \(orcGeneralCategory.count)")
                        orcGeneralCategory = orcGeneralCategory.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC A-B-C-D"
                        participants.classMembers = orcGeneralCategory
                        race.orcGeneralCategory.append(participants)
                    }
                    
                    if ORCA.count > 0 {
                        ORCA = ORCA.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC A"
                        participants.classMembers = ORCA
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCB.count > 0 {
                        ORCB = ORCB.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC B"
                        participants.classMembers = ORCB
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCC.count > 0 {
                        ORCC = ORCC.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC C"
                        participants.classMembers = ORCC
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCD.count > 0 {
                        ORCD = ORCD.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC D"
                        participants.classMembers = ORCD
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCE.count > 0 {
                        ORCE = ORCE.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC E"
                        participants.classMembers = ORCE
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCGEZGIN.count > 0 {
                        ORCGEZGIN = ORCGEZGIN.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "GEZGİN"
                        participants.classMembers = ORCGEZGIN
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    
                    //race.participantsByPlace = race.participantsByPlace.sorted(by: { $0.ircRank! < $1.ircRank!})

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
                    var ircGeneralCategory = [Participant]()
                    
                    var ORCA = [Participant]()
                    var ORCB = [Participant]()
                    var ORCC = [Participant]()
                    var ORCD = [Participant]()
                    var ORCE = [Participant]()
                    var ORCGEZGIN = [Participant]()
                    var orcGeneralCategory = [Participant]()
                    
                    for team in race2 {
                        
                        if team.key == "isReleased" {
                            
                            race.name = 1
                            
                            if let isReleased = team.value as? Int {
                                race.isReleased = isReleased
                            }
                            
                        } else if team.key == "isOfficial" {
                            
                            if let isOfficial = team.value as? Int {
                                race.isOfficial = isOfficial
                            }
                            
                        } else if let result = team.value as? [String: AnyObject] {
                                
                                let participant = Participant()
                                
                                if let ircRank = result["ircRank"] as? Int {
                                    
                                    participant.ircRank = ircRank
                                    
                                }
                            
                                if let orcRank = result["orcRank"] as? Int {
                                    
                                    participant.orcRank = orcRank
                                    
                                }
                                
                                if let ircScore = result["ircScore"] as? String {
                                    
                                    participant.ircScore = ircScore
                                    
                                }
                            
                                if let orcScore = result["orcScore"] as? String {
                                    
                                    participant.ircScore = orcScore
                                    
                                }
                            
                                if let point = result["ircPoint"] as? String {
                                    
                                    participant.ircPoint = point
                                    
                                }
                                
                                if let point = result["orcPoint"] as? String {
                                    
                                    participant.orcPoint = point
                                    
                                }
                                
                                if let boatId = result["boatId"] as? String {
                                    
                                    participant.team = self.teams.first(where: { $0.boatId == boatId })
                                    
                                }
                                
                                //race.participantsByPlace.append(participant)
                                
                                if let ircClass = participant.team?.ircClass, let _ = participant.ircScore {
                                    
                                    switch ircClass {
                                    case "IRC0":
                                        ircGeneralCategory.append(participant)
                                        IRC0.append(participant)
                                        break;
                                    case "IRC1":
                                        ircGeneralCategory.append(participant)
                                        IRC1.append(participant)
                                        break;
                                    case "IRC2":
                                        ircGeneralCategory.append(participant)
                                        IRC2.append(participant)
                                        break;
                                    case "IRC3":
                                        ircGeneralCategory.append(participant)
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
                            
                                if let orcClass = participant.team?.orcClass, let _ = participant.orcScore {
                                    
                                    switch orcClass {
                                    case "ORC A":
                                        orcGeneralCategory.append(participant)
                                        ORCA.append(participant)
                                        break;
                                    case "ORC B":
                                        orcGeneralCategory.append(participant)
                                        ORCB.append(participant)
                                        break;
                                    case "ORC C":
                                        orcGeneralCategory.append(participant)
                                        ORCC.append(participant)
                                        break;
                                    case "ORC D":
                                        orcGeneralCategory.append(participant)
                                        ORCD.append(participant)
                                        break;
                                    case "ORC E":
                                        ORCE.append(participant)
                                        break;
                                    case "GEZGİN":
                                        ORCGEZGIN.append(participant)
                                        break;
                                    default:
                                        break;
                                    }
                                }
                                
                            }
                            
                        }
                        
                    
                    if ircGeneralCategory.count > 0 {
                        ircGeneralCategory = ircGeneralCategory.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC 0-1-2-3"
                        participants.classMembers = ircGeneralCategory
                        race.ircGeneralCategory.append(participants)
                    }
                    
                    if IRC0.count > 0 {
                        IRC0 = IRC0.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC0"
                        participants.classMembers = IRC0
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC1.count > 0 {
                        IRC1 = IRC1.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC1"
                        participants.classMembers = IRC1
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC2.count > 0 {
                        IRC2 = IRC2.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC2"
                        participants.classMembers = IRC2
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC3.count > 0 {
                        IRC3 = IRC3.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC3"
                        participants.classMembers = IRC3
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC4.count > 0 {
                        IRC4 = IRC4.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC4"
                        participants.classMembers = IRC4
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if GEZGİN.count > 0 {
                        GEZGİN = GEZGİN.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "GEZGİN"
                        participants.classMembers = GEZGİN
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    
                    if orcGeneralCategory.count > 0 {
                        orcGeneralCategory = orcGeneralCategory.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC A-B-C-D"
                        participants.classMembers = orcGeneralCategory
                        race.orcGeneralCategory.append(participants)
                    }
                    
                    if ORCA.count > 0 {
                        ORCA = ORCA.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC A"
                        participants.classMembers = ORCA
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCB.count > 0 {
                        ORCB = ORCB.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC B"
                        participants.classMembers = ORCB
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCC.count > 0 {
                        ORCC = ORCC.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC C"
                        participants.classMembers = ORCC
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCD.count > 0 {
                        ORCD = ORCD.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC D"
                        participants.classMembers = ORCD
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCE.count > 0 {
                        ORCE = ORCE.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC E"
                        participants.classMembers = ORCE
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCGEZGIN.count > 0 {
                        ORCGEZGIN = ORCGEZGIN.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "GEZGİN"
                        participants.classMembers = ORCGEZGIN
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    
                    // race.participantsByPlace = race.participantsByPlace.sorted(by: { $0.ircRank! < $1.ircRank!})
                    
                    self.races.append(race)
                    
                }
                
                if let race3 = races["race3"] as? [String: AnyObject] {
                    
                    let race = Race()

                    var IRC0 = [Participant]()
                    var IRC1 = [Participant]()
                    var IRC2 = [Participant]()
                    var IRC3 = [Participant]()
                    var IRC4 = [Participant]()
                    var IRCGEZGIN = [Participant]()
                    var ircGeneralCategory = [Participant]()
                    
                    var ORCA = [Participant]()
                    var ORCB = [Participant]()
                    var ORCC = [Participant]()
                    var ORCD = [Participant]()
                    var ORCE = [Participant]()
                    var ORCGEZGIN = [Participant]()
                    var orcGeneralCategory = [Participant]()
                    
                    for team in race3 {
                        
                        if team.key == "isReleased" {
                            
                            race.name = 2
                            
                            if let isReleased = team.value as? Int {
                                race.isReleased = isReleased
                            }
                            
                        } else if team.key == "isOfficial" {
                            
                            if let isOfficial = team.value as? Int {
                                race.isOfficial = isOfficial
                            }
                            
                        } else if let result = team.value as? [String: AnyObject] {
                                
                                let participant = Participant()
                                
                                if let ircRank = result["ircRank"] as? Int {
                                    
                                    participant.ircRank = ircRank
                                    
                                }
                                
                                if let orcRank = result["orcRank"] as? Int {
                                    
                                    participant.orcRank = orcRank
                                    
                                }
                                
                                if let ircScore = result["ircScore"] as? String {
                                    
                                    participant.ircScore = ircScore
                                    
                                }
                            
                                if let orcScore = result["orcScore"] as? String {
                                    
                                    participant.orcScore = orcScore
                                    
                                }
                            
                                if let point = result["ircPoint"] as? String {
                                    
                                    participant.ircPoint = point
                                    
                                }
                                
                                if let point = result["orcPoint"] as? String {
                                    
                                    participant.orcPoint = point
                                    
                                }
                                
                                if let boatId = result["boatId"] as? String {
                                    
                                    participant.team = self.teams.first(where: { $0.boatId == boatId })
                                    
                                }
                                
                                //race.participantsByPlace.append(participant)
                                
                                if let ircClass = participant.team?.ircClass, let _ = participant.ircScore {
                                    
                                    switch ircClass {
                                    case "IRC0":
                                        ircGeneralCategory.append(participant)
                                        IRC0.append(participant)
                                        break;
                                    case "IRC1":
                                        ircGeneralCategory.append(participant)
                                        IRC1.append(participant)
                                        break;
                                    case "IRC2":
                                        ircGeneralCategory.append(participant)
                                        IRC2.append(participant)
                                        break;
                                    case "IRC3":
                                        ircGeneralCategory.append(participant)
                                        IRC3.append(participant)
                                        break;
                                    case "IRC4":
                                        IRC4.append(participant)
                                        break;
                                    case "GEZGİN":
                                        IRCGEZGIN.append(participant)
                                        break;
                                    default:
                                        break;
                                    }
                                }
                            
                                if let orcClass = participant.team?.orcClass, let _ = participant.orcScore {
                                    
                                    switch orcClass {
                                    case "ORC A":
                                        orcGeneralCategory.append(participant)
                                        ORCA.append(participant)
                                        break;
                                    case "ORC B":
                                        orcGeneralCategory.append(participant)
                                        ORCB.append(participant)
                                        break;
                                    case "ORC C":
                                        orcGeneralCategory.append(participant)
                                        ORCC.append(participant)
                                        break;
                                    case "ORC D":
                                        orcGeneralCategory.append(participant)
                                        ORCD.append(participant)
                                        break;
                                    case "ORC E":
                                        ORCE.append(participant)
                                        break;
                                    case "GEZGİN":
                                        ORCGEZGIN.append(participant)
                                        break;
                                    default:
                                        break;
                                    }
                                }
                                
                            }
                            
                        }
                    
                    if ircGeneralCategory.count > 0 {
                        ircGeneralCategory = ircGeneralCategory.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC 0-1-2-3"
                        participants.classMembers = ircGeneralCategory
                        race.ircGeneralCategory.append(participants)
                    }
                    
                    if IRC0.count > 0 {
                        IRC0 = IRC0.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC0"
                        participants.classMembers = IRC0
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC1.count > 0 {
                        IRC1 = IRC1.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC1"
                        participants.classMembers = IRC1
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC2.count > 0 {
                        IRC2 = IRC2.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC2"
                        participants.classMembers = IRC2
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC3.count > 0 {
                        IRC3 = IRC3.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC3"
                        participants.classMembers = IRC3
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC4.count > 0 {
                        IRC4 = IRC4.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC4"
                        participants.classMembers = IRC4
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRCGEZGIN.count > 0 {
                        IRCGEZGIN = IRCGEZGIN.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "GEZGİN"
                        participants.classMembers = IRCGEZGIN
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    
                    if orcGeneralCategory.count > 0 {
                        orcGeneralCategory = orcGeneralCategory.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC A-B-C-D"
                        participants.classMembers = orcGeneralCategory
                        race.orcGeneralCategory.append(participants)
                    }
                    
                    if ORCA.count > 0 {
                        ORCA = ORCA.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC A"
                        participants.classMembers = ORCA
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCB.count > 0 {
                        ORCB = ORCB.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC B"
                        participants.classMembers = ORCB
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCC.count > 0 {
                        ORCC = ORCC.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC C"
                        participants.classMembers = ORCC
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCD.count > 0 {
                        ORCD = ORCD.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC D"
                        participants.classMembers = ORCD
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCE.count > 0 {
                        ORCE = ORCE.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC E"
                        participants.classMembers = ORCE
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCGEZGIN.count > 0 {
                        ORCGEZGIN = ORCGEZGIN.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "GEZGİN"
                        participants.classMembers = ORCGEZGIN
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    
                    // race.participantsByPlace = race.participantsByPlace.sorted(by: { $0.ircRank! < $1.ircRank!})
                    
                    self.races.append(race)
                    
                }
                
                
                if let overall = races["overall"] as? [String: AnyObject] {
                    
                    let race = Race()

                    var IRC0 = [Participant]()
                    var IRC1 = [Participant]()
                    var IRC2 = [Participant]()
                    var IRC3 = [Participant]()
                    var IRC4 = [Participant]()
                    var IRCGEZGIN = [Participant]()
                    var ircGeneralCategory = [Participant]()
                    
                    var ORCA = [Participant]()
                    var ORCB = [Participant]()
                    var ORCC = [Participant]()
                    var ORCD = [Participant]()
                    var ORCE = [Participant]()
                    var ORCGEZGIN = [Participant]()
                    var orcGeneralCategory = [Participant]()
                    
                    for team in overall {
                        
                        if team.key == "isReleased" {
                            
                            race.name = 3
                            
                            if let isReleased = team.value as? Int {
                                race.isReleased = isReleased
                            }
                            
                        } else if team.key == "isOfficial" {
                            
                            if let isOfficial = team.value as? Int {
                                race.isOfficial = isOfficial
                            }
                            
                        } else if let result = team.value as? [String: AnyObject] {
                                
                                let participant = Participant()
                                
                                if let ircRank = result["ircRank"] as? Int {
                                    
                                    participant.ircRank = ircRank
                                    
                                }
                                
                                if let orcRank = result["orcRank"] as? Int {
                                    
                                    participant.orcRank = orcRank
                                    
                                }
                                
                                if let ircScore = result["ircScore"] as? String {
                                    
                                    participant.ircScore = ircScore
                                    
                                }
                            
                                if let orcScore = result["orcScore"] as? String {
                                    
                                    participant.orcScore = orcScore
                                    
                                }
                            
                                if let point = result["ircPoint"] as? String {
                                    
                                    participant.ircPoint = point
                                    
                                }
                                
                                if let point = result["orcPoint"] as? String {
                                    
                                    participant.orcPoint = point
                                    
                                }
                                
                                if let boatId = result["boatId"] as? String {
                                    
                                    participant.team = self.teams.first(where: { $0.boatId == boatId })
                                    
                                }
                                
                                //race.participantsByPlace.append(participant)
                                
                                if let ircClass = participant.team?.ircClass, let _ = participant.ircScore {
                                    
                                    switch ircClass {
                                    case "IRC0":
                                        ircGeneralCategory.append(participant)
                                        IRC0.append(participant)
                                        break;
                                    case "IRC1":
                                        ircGeneralCategory.append(participant)
                                        IRC1.append(participant)
                                        break;
                                    case "IRC2":
                                        ircGeneralCategory.append(participant)
                                        IRC2.append(participant)
                                        break;
                                    case "IRC3":
                                        ircGeneralCategory.append(participant)
                                        IRC3.append(participant)
                                        break;
                                    case "IRC4":
                                        IRC4.append(participant)
                                        break;
                                    case "GEZGİN":
                                        IRCGEZGIN.append(participant)
                                        break;
                                    default:
                                        break;
                                    }
                                    
                                }
                            
                                if let orcClass = participant.team?.orcClass, let _ = participant.orcScore {
                                    
                                    switch orcClass {
                                    case "ORCA":
                                        orcGeneralCategory.append(participant)
                                        ORCA.append(participant)
                                        break;
                                    case "ORCB":
                                        orcGeneralCategory.append(participant)
                                        ORCB.append(participant)
                                        break;
                                    case "ORCC":
                                        orcGeneralCategory.append(participant)
                                        ORCC.append(participant)
                                        break;
                                    case "ORCD":
                                        orcGeneralCategory.append(participant)
                                        ORCD.append(participant)
                                        break;
                                    case "ORCE":
                                        ORCE.append(participant)
                                        break;
                                    case "ORCGEZGİN":
                                        ORCGEZGIN.append(participant)
                                        break;
                                    default:
                                        break;
                                    }
                                }
                                
                        }
                        
                    }
                    
                    if ircGeneralCategory.count > 0 {
                        ircGeneralCategory = ircGeneralCategory.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC 0-1-2-3"
                        participants.classMembers = ircGeneralCategory
                        race.ircGeneralCategory.append(participants)
                    }
                    
                    if IRC0.count > 0 {
                        IRC0 = IRC0.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC0"
                        participants.classMembers = IRC0
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC1.count > 0 {
                        IRC1 = IRC1.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC1"
                        participants.classMembers = IRC1
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC2.count > 0 {
                        IRC2 = IRC2.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC2"
                        participants.classMembers = IRC2
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC3.count > 0 {
                        IRC3 = IRC3.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC3"
                        participants.classMembers = IRC3
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRC4.count > 0 {
                        IRC4 = IRC4.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "IRC4"
                        participants.classMembers = IRC4
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if IRCGEZGIN.count > 0 {
                        IRCGEZGIN = IRCGEZGIN.sorted(by: { $0.ircRank! < $1.ircRank!})
                        var participants = Participants()
                        participants.classTitle = "GEZGİN"
                        participants.classMembers = IRCGEZGIN
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    
                    if orcGeneralCategory.count > 0 {
                        orcGeneralCategory = orcGeneralCategory.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC A-B-C-D"
                        participants.classMembers = orcGeneralCategory
                        race.orcGeneralCategory.append(participants)
                    }
                    
                    if ORCA.count > 0 {
                        ORCA = ORCA.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC A"
                        participants.classMembers = ORCA
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCB.count > 0 {
                        ORCB = ORCB.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC B"
                        participants.classMembers = ORCB
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCC.count > 0 {
                        ORCC = ORCC.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC C"
                        participants.classMembers = ORCC
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCD.count > 0 {
                        ORCD = ORCD.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC D"
                        participants.classMembers = ORCD
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCE.count > 0 {
                        ORCE = ORCE.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "ORC E"
                        participants.classMembers = ORCE
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    if ORCGEZGIN.count > 0 {
                        ORCGEZGIN = ORCGEZGIN.sorted(by: { $0.orcRank! < $1.orcRank!})
                        var participants = Participants()
                        participants.classTitle = "GEZGİN"
                        participants.classMembers = ORCGEZGIN
                        race.participantsByPlaceOfClass.append(participants)
                    }
                    
                    // race.participantsByPlace = race.participantsByPlace.sorted(by: { $0.ircRank! < $1.ircRank!})
                    
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
