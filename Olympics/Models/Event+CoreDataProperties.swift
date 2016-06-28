//
//  Event+CoreDataProperties.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
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
    @NSManaged var country: Country?
    @NSManaged var discipline: Discipline?
    @NSManaged var participants: Athlete?
    @NSManaged var teams: Team?
    @NSManaged var units: NSSet?

}
