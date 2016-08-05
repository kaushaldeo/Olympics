//
//  Discipline+CoreDataProperties.swift
//  Olympics
//
//  Created by Kaushal Deo on 8/4/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Discipline {

    @NSManaged var alias: String?
    @NSManaged var identifier: String?
    @NSManaged var name: String?
    @NSManaged var play: Bool
    @NSManaged var status: Bool
    @NSManaged var events: NSSet?
    @NSManaged var sport: Sport?
    @NSManaged var athletes: NSSet?

}
