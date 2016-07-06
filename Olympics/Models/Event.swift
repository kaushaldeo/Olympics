//
//  Event.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData


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

}
