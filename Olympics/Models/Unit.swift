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
    
    
    
    class func minDay(context: NSManagedObjectContext) -> NSDate {
        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        let predicate = NSPredicate(format: "startDate != nil")
        
        if let unit = context.findFirst(Unit.classForCoder(), predicate:predicate, sortDescriptors:[sortDescriptor]) as? Unit {
            return unit.startDate!
        }
        return NSDate.distantPast()
    }
    
    
    class func maxDay(context: NSManagedObjectContext) -> NSDate {
        
        let sortDescriptor = NSSortDescriptor(key: "endDate", ascending: false)
        let predicate = NSPredicate(format: "endDate != nil")
        
        if let unit = context.findFirst(Unit.classForCoder(), predicate:predicate, sortDescriptors:[sortDescriptor]) as? Unit {
            return unit.endDate!
        }
        return NSDate.distantFuture()
    }
    
    
}
