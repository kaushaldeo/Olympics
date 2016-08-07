//
//  Winner.swift
//  Olympics
//
//  Created by Kaushal Deo on 8/6/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData


class Winner: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    func name() -> String? {
        if let item = self.athlete {
            return item.printName()
        }
        else if let item = self.team {
            if let string = item.name where string.characters.count > 0 {
                return string
            }
            return self.team?.country?.name
        }
        return nil
    }
    
    func updateMedal(string: String?) {
        if let text = string?.lowercaseString {
            switch text {
            case "gold":
                self.medal = "1"
            case "silver":
                self.medal = "2"
            default:
                self.medal = "3"
                
            }
        }
    }
    
    func sports() -> String? {
        var string = ""
        if let item = self.event {
            if let name = item.name {
                string += name
            }
            if let discipline = item.discipline, let text = discipline.name {
                if string.isEmpty == false {
                    string += " - "
                }
                string += text
            }
        }
        return string
    }
    
}
