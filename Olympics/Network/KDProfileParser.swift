//
//  KDProfileParser.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/4/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDProfileParser: KDParseOperation {
    var country : Country? = nil
    
    var event : Event? = nil
    
    var team : Team? = nil
    
    var discipline : Discipline? = nil
    
    
    lazy var dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "organization" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            self.country = self.context.findFirst(Country.classForCoder(), predicate: predicate) as? Country
        }
        else if elementName == "event" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            if let event = self.context.findOrCreate(Event.classForCoder(), predicate: predicate) as? Event {
                event.identifier = attributeDict["id"]
                event.name = attributeDict["description"]
                event.gender = attributeDict["gender"]
                self.event = event
                self.country?.addEvent(event)
            }
        }
        else if elementName == "discipline" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            self.discipline = self.context.findFirst(Discipline.classForCoder(), predicate: predicate) as? Discipline
        }
        else if elementName == "athlete" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            if let athlete = self.context.findOrCreate(Athlete.classForCoder(), predicate: predicate) as? Athlete {
                athlete.country = self.country
                athlete.identifier = attributeDict["id"]
                athlete.firstName = attributeDict["first_name"]
                athlete.lastName = attributeDict["last_name"]
                athlete.gender = attributeDict["gender"]
                athlete.name = attributeDict["print_name"]
                if let text = attributeDict["birth_date"] {
                    athlete.date = self.dateFormatter.dateFromString(text)
                }
                athlete.discipline = discipline
                if let item = self.team {
                    item.addMember(athlete)
                }
                else if let item = self.event {
                    item.addParticipant(athlete)
                }
            }
        }
        else if elementName == "team" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            if let team = self.context.findOrCreate(Team.classForCoder(), predicate: predicate) as? Team {
                team.identifier = attributeDict["id"]
                team.name = attributeDict["description"]
                team.country = self.country
                self.team = team
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
        else if elementName == "team" {
            self.team = nil
        }
    }
}
