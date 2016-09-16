//
//  KDMedalParser.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/5/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDMedalParser: KDParseOperation {
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "organization" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            if let country = self.context.findOrCreate(Country.classForCoder(), predicate: predicate) as? Country {
                country.identifier = attributeDict["id"]
                country.name = attributeDict["description"]
                country.alias = attributeDict["alias"]
                //gold="2" silver="3" bronze="2" total="7"/>
                if let text = attributeDict["bronze"], let index = Int(text) {
                    country.bronze = NSNumber(integer: index)
                }
                if let text = attributeDict["gold"], let index = Int(text) {
                    country.gold = NSNumber(integer: index)
                }
                if let text = attributeDict["silver"], let index = Int(text) {
                    country.silver = NSNumber(integer: index)
                }
            }
        }
        
    }
    
    // sent when an end tag is encountered. The various parameters are supplied as above.
    override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "organizations" {
            self.context.saveContext()
        }
    }
}
