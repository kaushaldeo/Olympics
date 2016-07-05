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
    
    var events = [Event]()
    
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
    }
    
    // sent when an end tag is encountered. The various parameters are supplied as above.
    override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "events" {
            self.country?.events = NSSet(array: self.events)
            self.context.saveContext()
        }
    }
}
