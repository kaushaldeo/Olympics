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
    
    func total() -> Int16 {
        return self.bronze + self.silver + self.gold
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
    
}
