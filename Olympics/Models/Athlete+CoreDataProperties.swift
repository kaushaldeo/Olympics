//
//  Athlete+CoreDataProperties.swift
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

extension Athlete {

    @NSManaged var firstName: String?
    @NSManaged var identifier: String?
    @NSManaged var lastName: String?
    @NSManaged var competitor: Competitor?
    @NSManaged var country: Country?
    @NSManaged var event: Event?
    @NSManaged var team: Team?

}
