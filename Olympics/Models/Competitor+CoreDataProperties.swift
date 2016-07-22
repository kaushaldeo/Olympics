//
//  Competitor+CoreDataProperties.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/21/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Competitor {

    @NSManaged var identifier: String?
    @NSManaged var medal: String?
    @NSManaged var outcome: String?
    @NSManaged var rank: String?
    @NSManaged var resultType: String?
    @NSManaged var resultValue: String?
    @NSManaged var sort: Int16
    @NSManaged var start: Int16
    @NSManaged var status: String?
    @NSManaged var type: String?
    @NSManaged var athlete: Athlete?
    @NSManaged var results: NSSet?
    @NSManaged var scores: NSSet?
    @NSManaged var team: Team?
    @NSManaged var units: NSSet?

}
