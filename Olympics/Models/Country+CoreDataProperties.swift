//
//  Country+CoreDataProperties.swift
//  Olympics
//
//  Created by Kaushal Deo on 8/6/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Country {

    @NSManaged var alias: String?
    @NSManaged var bronze: NSNumber
    @NSManaged var gold: NSNumber
    @NSManaged var identifier: String?
    @NSManaged var name: String?
    @NSManaged var silver: NSNumber
    @NSManaged var rank: String?
    @NSManaged var events: NSSet?
    @NSManaged var members: NSSet?
    @NSManaged var teams: NSSet?

}
