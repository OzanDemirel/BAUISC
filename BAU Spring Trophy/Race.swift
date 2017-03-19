//
//  Races.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 18/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class Race: NSObject {
    
    var name = 0
    var status = 0
    var participantsByPlace = [Participant]()
    var participantsByPlaceOfClass = [Int: [Participant]]()
    
}

class Participant: NSObject {
    
    var place: Int?
    var team: Team?
    var finishTime: String?
    var extraTime: String?
    
}
