//
//  Winner+CoreDataProperties.swift
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

extension Winner {

    @NSManaged var identifier: String?
    @NSManaged var medal: String?
    @NSManaged var type: String?
    @NSManaged var event: Event?
    @NSManaged var athlete: Athlete?
    @NSManaged var team: Team?

}
