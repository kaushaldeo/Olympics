//
//  Score+CoreDataProperties.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/9/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Score {

    @NSManaged var name: String?
    @NSManaged var code: String?
    @NSManaged var number: Int16
    @NSManaged var value: Int16
    @NSManaged var competitor: Competitor?

}
