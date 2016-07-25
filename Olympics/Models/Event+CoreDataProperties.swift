//
//  Event+CoreDataProperties.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/24/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var gender: String?
    @NSManaged var identifier: String?
    @NSManaged var name: String?
    @NSManaged var countries: NSSet?
    @NSManaged var discipline: Discipline?
    @NSManaged var participants: NSSet?
    @NSManaged var teams: NSSet?
    @NSManaged var units: NSSet?

}
