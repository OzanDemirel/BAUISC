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
    var isReleased = 0  // was status
    var isOfficial = 0  // was resultStatus
    var ircGroupCategory = [Participant]()
    var ircGeneralCategory = [Participants]() // It was participantsByPlaceOfCategory
    var orcGeneralCategory = [Participants]()
    var orcGroupCategory = [Participant]()
    //var participantsByPlace = [Participant]()
    var participantsByPlaceOfClass = [Participants]()
    
    
}

class Participant: NSObject {
    
    var team: Team?
    var ircRank: Int? // was place
    var ircScore: String? // was extratime
    var ircPoint: String?
    var orcRank: Int?
    var orcScore: String?
    var orcPoint: String?

}
