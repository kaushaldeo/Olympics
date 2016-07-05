//
//  KDScheduleParser.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/4/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDScheduleParser: KDParseOperation {
    var sport : Sport? = nil
    
    var displine : Discipline? = nil
    
    var event : Event? = nil
    
    var unit :Unit? = nil
    
    
    var displines = [Discipline]()
    
    var events = [Event]()
    
    var units = [Unit]()
    
    
    
    lazy var dateFormatter : NSDateFormatter = {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        return dateFormatter
    }()
    
    override func parserDidEndDocument(parser: NSXMLParser) {
        NSUserDefaults.schedule(true)
    }
    
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "sport" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            self.sport = self.context.findOrCreate(Sport.classForCoder(), predicate: predicate) as? Sport
            self.sport?.identifier = attributeDict["id"]
            self.sport?.name = attributeDict["description"]
            self.sport?.alias = attributeDict["alias"]
        }
        else if elementName == "discipline" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            self.displine = self.context.findOrCreate(Discipline.classForCoder(), predicate: predicate) as? Discipline
            self.displine?.identifier = attributeDict["id"]
            self.displine?.name = attributeDict["description"]
            self.displine?.alias = attributeDict["alias"]
            self.displine?.status = attributeDict["stats"] == "true"
            self.displine?.play = attributeDict["play-by-play"] == "true"
            self.displine?.sport = self.sport
            
        }
        else if elementName == "event" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            self.event = self.context.findOrCreate(Event.classForCoder(), predicate: predicate) as? Event
            self.event?.identifier = attributeDict["id"]
            self.event?.name = attributeDict["description"]
            self.event?.gender = attributeDict["gender"]
            self.event?.discipline = self.displine
            
            
        }
        else if elementName == "unit" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            self.unit = self.context.findOrCreate(Unit.classForCoder(), predicate: predicate) as? Unit
            self.unit?.identifier = attributeDict["id"]
            self.unit?.name = attributeDict["name"]
            self.unit?.phase = attributeDict["gender"]
            if let text = attributeDict["start_date"] {
                self.unit?.startDate = self.dateFormatter.dateFromString(text)
            }
            if let text = attributeDict["end_date"] {
                self.unit?.endDate = self.dateFormatter.dateFromString(text)
            }
            self.unit?.event = self.event
            
        }
        else if elementName == "venue" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            let venue = self.context.findOrCreate(Venue.classForCoder(), predicate: predicate) as? Venue
            venue?.identifier = attributeDict["id"]
            venue?.name = attributeDict["name"]
            venue?.alias = attributeDict["alias"]
            self.unit?.venue = venue
        }
        else if elementName == "location" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            let location = self.context.findOrCreate(Location.classForCoder(), predicate: predicate) as? Location
            location?.identifier = attributeDict["id"]
            location?.name = attributeDict["name"]
            location?.alias = attributeDict["alias"]
            self.unit?.location = location
            
        }
    }
    
    // sent when an end tag is encountered. The various parameters are supplied as above.
    override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "sports" {
            self.context.saveContext()
        }
    }

}
