//
//  Country.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData


class Country: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
}


class CountryParser : KDParseOperation {
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "organizations" {
            self.startParsing = true
        }
        
        if self.startParsing && elementName == "organization" {
            if let entityDescription = NSEntityDescription.entityForName("Country", inManagedObjectContext: self.context) {
                let country = Country(entity: entityDescription, insertIntoManagedObjectContext: nil)
                country.identifier = attributeDict["id"]
                country.name = attributeDict["description"]
                country.alias = attributeDict["alias"]
                self.items.append(country)
            }
            
            if self.items.count > 20 {
                self.processedData(self.items)
                self.items.removeAll()
            }
        }
    }
    
    override func processedData(objects: [NSManagedObject]) {
        if let countries = objects as? [Country] {
            
            let fetchRequest = NSFetchRequest(entityName: "Country")
            
            let entityDescription = NSEntityDescription.entityForName("Country", inManagedObjectContext:self.context)
            fetchRequest.entity = entityDescription
            
            
            fetchRequest.propertiesToFetch = ["identifier"]
            fetchRequest.resultType = .DictionaryResultType
            
            
            for country in countries {
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", country.identifier!)
                if self.context.countForFetchRequest(fetchRequest, error: nil) == 0 {
                    self.context.insertObject(country)
                }
            }
            self.context.saveContext()
        }
    }
}