//
//  Result+CoreDataProperties.swift
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

extension Result {

    @NSManaged var code: String?
    @NSManaged var rank: Int16
    @NSManaged var difference: String?
    @NSManaged var sequence: Int16
    @NSManaged var order: Int16
    @NSManaged var type: String?
    @NSManaged var value: String?
    @NSManaged var valueType: String?
    @NSManaged var competitor: Competitor?

}
