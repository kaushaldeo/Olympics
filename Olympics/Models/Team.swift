//
//  Team.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData


class Team: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    func addMember(athlete: Athlete) {
        let sets = NSMutableSet()
        if let items = self.members where items.count > 0 {
            sets.addObjectsFromArray(items.allObjects)
        }
        sets.addObject(athlete)
        self.members = sets
    }

}
