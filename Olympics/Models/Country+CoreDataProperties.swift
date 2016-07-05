//
//  Country+CoreDataProperties.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/5/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Country {

    @NSManaged var alias: String?
    @NSManaged var identifier: String?
    @NSManaged var name: String?
    @NSManaged var gold: Int16
    @NSManaged var silver: Int16
    @NSManaged var bronze: Int16
    @NSManaged var events: NSSet?
    @NSManaged var members: NSSet?
    @NSManaged var teams: NSSet?

}
