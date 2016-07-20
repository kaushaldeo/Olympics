//
//  KDEventParser.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/9/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDEventParser: KDParseOperation {
    
    var event : Event? = nil
    
    var unit : Unit? = nil
    
    var competitor : Competitor? = nil
    
    lazy var dateFormatter : NSDateFormatter = {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        return dateFormatter
    }()
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "event" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            self.event = self.context.findFirst(Event.classForCoder(), predicate: predicate) as? Event
        }
        else if elementName == "unit" {
            let predicate = NSPredicate(format: "identifier = %@", attributeDict["id"]!)
            if let unit = self.context.findOrCreate(Unit.classForCoder(), predicate: predicate) as? Unit {
                unit.name = attributeDict["name"]
                unit.phase = attributeDict["phase"]
                unit.status = attributeDict["status"]
                unit.type = attributeDict["type"]
                unit.medal = attributeDict["medal"]
                if let text = attributeDict["start_date"] {
                    unit.startDate = self.dateFormatter.dateFromString(text)
                }
                if let text = attributeDict["end_date"] {
                    unit.endDate = self.dateFormatter.dateFromString(text)
                }
                
                unit.period = attributeDict["period"]
                unit.clock = attributeDict["clock"]
                unit.event = self.event
                self.unit = unit
            }
        }
        else if elementName == "competitor" {
            if let identifier = attributeDict["id"] {
                let predicate = NSPredicate(format: "identifier = %@", identifier)
                if let competitor = self.context.findOrCreate(Competitor.classForCoder(), predicate: predicate) as? Competitor {
                    competitor.identifier = identifier
                    competitor.type = attributeDict["type"]
                    if let type = competitor.type  where type == "individual" {
                        if let athlete = self.context.findOrCreate(Athlete.classForCoder(), predicate: predicate) as? Athlete {
                            athlete.identifier = identifier
                            athlete.firstName = attributeDict["first_name"]
                            athlete.lastName = attributeDict["last_name"]
                            athlete.gender = attributeDict["gender"]
                            athlete.name = attributeDict["print_name"]
                            if let text = attributeDict["birth_date"] {
                                athlete.date = self.dateFormatter.dateFromString(text)
                            }
                            if let alias = attributeDict["organization"] {
                             athlete.country = self.context.findFirst(Country.classForCoder(), predicate: NSPredicate(format: "alias = %@",alias)) as? Country
                            }
                            competitor.athlete = athlete
                        }
                    }
                    else {
                        if let team = self.context.findOrCreate(Team.classForCoder(), predicate: predicate) as? Team {
                            team.identifier = identifier
                            team.name = attributeDict["description"]
                            if let alias = attributeDict["organization"] {
                                team.country = self.context.findFirst(Country.classForCoder(), predicate: NSPredicate(format: "alias = %@",alias)) as? Country
                            }
                            competitor.team = team
                        }
                    }
                    competitor.medal = attributeDict["medal"]
                    competitor.status = attributeDict["status"]
                    competitor.outcome = attributeDict["outcome"]
                    competitor.resultValue = attributeDict["result"]
                    competitor.resultType = attributeDict["result_type"]
                    if let text = attributeDict["sort_order"] {
                        competitor.sort = Int16(text)!
                    }
                    if let text = attributeDict["start_order"] {
                        competitor.start = Int16(text)!
                    }
                    competitor.unit = self.unit
                    self.competitor = competitor
                }
            }
        }
            
        else if elementName == "score" {
            if let score = self.context.createObject(Score.classForCoder()) as? Score {
                score.name = attributeDict["id"]
                score.code = attributeDict["type"]
                if let text = attributeDict["sort_order"] {
                    score.number = Int16(text)!
                }
                if let text = attributeDict["start_order"] {
                    score.value = Int16(text)!
                }
                score.competitor = self.competitor
            }
        }
            
        else if elementName == "extended-result" {
            if let result = self.context.createObject(Result.classForCoder()) as? Result {
                result.code = attributeDict["code"]
                result.difference = attributeDict["diff"]
                result.type = attributeDict["type"]
                result.value = attributeDict["value"]
                result.valueType = attributeDict["value_type"]
                
                if let text = attributeDict["rank"] {
                    result.rank = Int16(text)!
                }
                if let text = attributeDict["sequence"] {
                    //result.sequence = Int16(text)!
                }
                if let text = attributeDict["sort_order"] {
                    result.order = Int16(text)!
                }
                result.competitor = self.competitor
            }
        }
    }
    
    // sent when an end tag is encountered. The various parameters are supplied as above.
    override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "unit" ||  elementName == "event" {
            self.context.saveContext()
        }
    }
}
