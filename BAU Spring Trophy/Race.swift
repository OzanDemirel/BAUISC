//
//  Races.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 18/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

struct Participants {
    var classTitle: String!
    var classMembers: [Participant]!
}

class Race: NSObject {
    
    var name = 0
    var status = 0
    var resultStatus = 0
    var participantsByPlace = [Participant]()
    var participantsByPlaceOfClass = [Participants]()
    var participantsByPlaceOfCategory = [Participants]()
    
}

class Participant: NSObject {
    
    var place: Int?
    var team: Team?
    var finishTime: String?
    var extraTime: String?
    
}
