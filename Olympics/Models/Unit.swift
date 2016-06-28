//
//  Unit.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData


class Unit: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    var day: String {
        get {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd"
            if let date = self.startDate {
                return dateFormatter.stringFromDate(date)
            }
            return "Today"
        }
    }
    
    
}
