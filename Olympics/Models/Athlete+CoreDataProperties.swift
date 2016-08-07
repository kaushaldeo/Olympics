//
//  Athlete+CoreDataProperties.swift
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

extension Athlete {

    @NSManaged var date: NSDate?
    @NSManaged var firstName: String?
    @NSManaged var gender: String?
    @NSManaged var identifier: String?
    @NSManaged var lastName: String?
    @NSManaged var name: String?
    @NSManaged var status: String?
    @NSManaged var competitors: NSSet?
    @NSManaged var country: Country?
    @NSManaged var discipline: Discipline?
    @NSManaged var events: NSSet?
    @NSManaged var teams: NSSet?
    @NSManaged var winners: NSSet?

}
