//
//  Athlete.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData


class Athlete: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    var association: String? {
        get {
            if let  event = self.events?.anyObject() as? Event {
                return event.fullName()
            }
            if let team = self.teams?.anyObject() as? Team {
                if let event = team.events?.anyObject() as? Event {
                    return event.fullName()
                }
            }
            return nil
        }
    }
    
}
