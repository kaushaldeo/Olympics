//
//  KDWinnerParser.swift
//  Olympics
//
//  Created by Kaushal Deo on 8/6/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDWinnerParser: KDParseOperation {
    
    var event : Event? = nil
    
    var country : Country? = nil
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
       
        if elementName == "organization" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            self.country = self.context.findFirst(Country.classForCoder(), predicate: predicate) as? Country
        }
        else if elementName == "event" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            self.event = self.context.findFirst(Event.classForCoder(), predicate: predicate) as? Event
        }
        else if elementName == "competitor" {
            if let identifier = attributeDict["id"], let event = self.event {
                var predicate = NSPredicate(format: "identifier = %@ AND event = %@", identifier,event)
                if let item = self.context.findOrCreate(Winner.classForCoder(), predicate: predicate) as? Winner {
                    item.identifier = identifier
                    item.updateMedal(attributeDict["medal"])
                    item.type = attributeDict["type"]
                    item.event = event
                    predicate = NSPredicate(format: "identifier = %@",identifier)
                    if let type = item.type  where type == "individual" {
                        if let athlete = self.context.findOrCreate(Athlete.classForCoder(), predicate: predicate) as? Athlete {
                            athlete.identifier = identifier
                            athlete.firstName = attributeDict["first_name"]
                            athlete.lastName = attributeDict["last_name"]
                            athlete.country = self.country
                            item.athlete = athlete
                        }
                    }
                    else {
                        if let team = self.context.findOrCreate(Team.classForCoder(), predicate: predicate) as? Team {
                            team.identifier = identifier
                            team.name = attributeDict["description"]
                            team.country = self.country
                            item.team = team
                        }
                    }
                    
                }
            }
            
        }
        
    }
    
    // sent when an end tag is encountered. The various parameters are supplied as above.
    override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "events" {
            self.context.saveContext()
        }
        else if elementName == "event" {
            self.event = nil
        }
    }
}
