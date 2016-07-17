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
    
}
