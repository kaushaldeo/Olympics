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
    
    var events = [Event]()
    
    var participants = [Athlete]()
    
    var teams = [Team]()
    
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
            if let event = self.context.findFirst(Event.classForCoder(), predicate: predicate) as? Event {
                self.events.append(event)
            }
        }
        else if elementName == "participants" {
            self.participants = [Athlete]()
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
                self.participants.append(athlete)
            }
            
        }
        else if elementName == "team" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            if let team = self.context.findOrCreate(Team.classForCoder(), predicate: predicate) as? Team {
                team.identifier = attributeDict["id"]
                team.name = attributeDict["description"]
                team.country = self.country
                self.teams.append(team)
                self.participants = [Athlete]()
            }
        }
        else if elementName == "teams" {
            self.teams = [Team]()
        }
        
    }
    
    // sent when an end tag is encountered. The various parameters are supplied as above.
    override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "events" {
            self.country?.events = NSSet(array: self.events)
            self.context.saveContext()
        }
        else if elementName == "participants" {
            if let event = self.events.last  {
                event.participants = NSSet(array: self.participants)
            }
        }
        else if elementName == "team" {
            if let team = self.teams.last  {
                team.members = NSSet(array: self.participants)
            }
        }
        else if elementName == "teams" {
            if let event = self.events.last  {
                event.teams = NSSet(array: self.teams)
            }
        }
    }
}
