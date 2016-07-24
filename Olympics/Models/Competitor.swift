//
//  Competitor.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData

/*****
 
 <competitor id="4c6a49e0-50d7-4416-b2e0-1058366de615" last_name="Ferrer" first_name="David" gender="male" status="active" organization="ESP" type="individual" odf_id="7280875" outcome="win" sort_order="1" result_type="score" result="2"></competitor>
 
 <competitor id="bccc4efe-8fc4-4465-9c3b-ab9fc3ede1a7" description="Switzerland" organization="SUI" type="team" gender="mixed" odf_id="EQ402XSUI01" start_order="7" sort_order="1" result_type="points" result="1" rank="1"></competitor>
 
 <competitor id="5faeca92-274b-4f54-8378-0ddc3d9495c7" description="UA Emirates" organization="UAE" type="team" gender="male" odf_id="FBM400UAE01" outcome="tie" start_order="1" sort_order="1" result_type="points" result="1">
 <scoring>
 <score code="H1" number="1" description="First Half" score="1"/>
 <score code="H2" number="2" description="Second Half" score="0"/>
 </scoring>
 </competitor>
 
 
 @NSManaged var identifier: String?
 @NSManaged var type: String?
 @NSManaged var medal: String?
 @NSManaged var sort: Int16
 @NSManaged var start: Int16
 @NSManaged var status: String?
 @NSManaged var outcome: String?
 @NSManaged var resultValue: String?
 @NSManaged var resultType: String?
 @NSManaged var athlete: Athlete?
 @NSManaged var team: Team?
 @NSManaged var unit: Unit?
 @NSManaged var scores: NSSet?
 @NSManaged var results: NSSet?

 
 ****/


class Competitor: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    func name () -> String? {
        if let type = self.type where type == "team" {
            return self.team?.name
        }
        if let player = self.athlete {
            if let _ = player.name {
                return player.name
            }
            var string = ""
            if let text = player.firstName {
                string += text
            }
            if let text = player.lastName {
                if string.isEmpty == false {
                    string += " "
                }
                string += text
            }
            return string
        }
        return nil
    }

    
    
    func resultText() -> String {
        var string = ""
        if let text = self.outcome {
            string += text
        }
        
        if let text = self.resultValue {
            if string.isEmpty == false {
                string += "   "
            }
            string += text
        }
        
        if let text = self.resultType {
            if string.isEmpty == false {
                string += " with "
            }
            string += text
        }
        
        return string
    }
    
    func iconName() -> String? {
        if let type = self.type where type == "team" {
            return self.team?.country?.alias?.lowercaseString
        }
        if let player = self.athlete {
          return player.country?.alias?.lowercaseString
        }
        return nil
    }
    
}
