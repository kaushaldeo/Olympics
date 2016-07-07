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
            if let  event = self.event {
                return event.fullName()
            }
            if let  event = self.team?.event {
                return event.fullName()
            }
            return nil
        }
    }
    
}
