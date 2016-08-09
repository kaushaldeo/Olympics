//
//  Country.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData


class Country: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    func total() -> Int {
        return self.bronze.integerValue + self.silver.integerValue + self.gold.integerValue
    }
    
    class func country(context: NSManagedObjectContext) -> Country? {
        let setting = NSUserDefaults.standardUserDefaults()
        if let identifier = setting.valueForKey("kCountry") as? String {
           if let objectID = context.persistentStoreCoordinator?.managedObjectIDForURIRepresentation(NSURL(string: identifier)!) {
                return context.objectWithID(objectID) as? Country
            }
        }
        return nil
    }
    
    
    func addEvent(event: Event) {
        let sets = NSMutableSet()
        if let items = self.events where items.count > 0 {
            sets.addObjectsFromArray(items.allObjects)
        }
        sets.addObject(event)
        self.events = sets
    }
}
