//
//  Event.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Event: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    func fullName() -> String? {
        var string = ""
        if let text = self.discipline?.name {
            string = string + text
        }
        if let text = self.name {
            if string.isEmpty == false {
                string = string + "-"
            }
            string = string + text
        }
        return string
    }
    
    
    func genderImage() -> UIImage? {
        if let text = self.gender {
            return UIImage(named: "\(text)Icon")
        }
        return nil
    }
    
    func unit(date: NSDate) -> Unit? {
        if let items = self.units?.allObjects as? [Unit] {
            if let nextDate = date.nextDate() {
                let predicate = NSPredicate(format: "startDate > %@ AND startDate < %@",date, nextDate)
                return (items as NSArray).filteredArrayUsingPredicate(predicate).first as? Unit
            }
        }
        return nil
    }
    
    func playingUnit(date: NSDate, withCountry country:Country) -> Unit? {
        if let items = self.units?.allObjects as? [Unit] {
           return items.filter({ (unit) -> Bool in
                if unit.startDate?.compare(date) == .OrderedAscending {
                    
                    let status = unit.statusValue()
                    return status != "progress" && status == "closed"
                }
                return false
            }).first
        }
        return nil
    }
    
    func addTeam(team: Team) {
        let sets = NSMutableSet()
        if let items = self.teams where items.count > 0 {
            sets.addObjectsFromArray(items.allObjects)
        }
        sets.addObject(team)
        self.teams = sets
    }
    
    func addParticipant(participant: Athlete) {
        let sets = NSMutableSet()
        if let items = self.participants where items.count > 0 {
            sets.addObjectsFromArray(items.allObjects)
        }
        sets.addObject(participant)
        self.participants = sets
    }
    
}
