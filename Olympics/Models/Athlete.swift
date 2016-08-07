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
                return event.discipline?.name
            }
            if let team = self.teams?.anyObject() as? Team {
                if let event = team.events?.anyObject() as? Event {
                    return event.discipline?.name
                }
            }
            return nil
        }
    }
    
    func printName () -> String {
        if let text = self.name {
            return text
        }
        var string = ""
        if let text = self.firstName {
            string += text
        }
        if let text = self.lastName {
            if string.isEmpty == false {
                string += " "
            }
            string += text
        }
        return string
    }
    
    var imageName: String? {
        get {
            if let discipline = self.discipline {
                return discipline.alias?.lowercaseString
            }
            if let  event = self.events?.anyObject() as? Event {
                return event.discipline?.alias?.lowercaseString
            }
            if let team = self.teams?.anyObject() as? Team {
                if let event = team.events?.anyObject() as? Event {
                    return event.discipline?.alias?.lowercaseString
                }
            }
            return nil
        }
    }
    
}
