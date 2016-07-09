//
//  Unit.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//<unit updated="2016-06-27T11:55:58+00:00" id="16dcce48-37e7-44b6-ab9e-b06eff55830b" name="Men's First Round - Group D" phase="First Round - Group D" status="inprogress" type="Teams Head to Head" start_date="2016-08-04T20:00:00+00:00" end_date="2016-08-04T21:45:00+00:00" odf_id="FBM400D02" period="" clock="92:16">

//<unit updated="2016-06-27T11:59:25+00:00" id="496f51a8-70ba-41f8-ae0b-e9b7ff6578c4" name="Jumping Team Qualifier for Round 1" phase="Qualifier" status="scheduled" type="NOC" odf_id="EQX402901">

// <unit updated="2016-06-27T10:35:25Z" id="19cfbc76-5ddc-4812-8e30-724bcce310ab" name="Women's Light (60kg) Round of 16" phase="Preliminaries" status="scheduled" type="Individuals Head to Head" odf_id="BXW060402">

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
    
    
    func locationName() -> String {
        var string = ""
        if let text = self.location?.name {
            string = string + text
        }
        if let text = self.venue?.name {
            if string.isEmpty == false {
                string = string + "-"
            }
            string = string + text
        }
        return string
    }
    
    func medalImage() -> UIImage? {
        if let text = self.medal {
            return UIImage(named: text)
        }
        return nil
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
