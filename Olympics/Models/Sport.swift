//
//  Sport.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/11/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import Foundation

class Sport: Codable {
    let name: String
    let code: String
    let sports: [Sport]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case code = "code"
        case sports = "sports"
    }
}

extension Sport: CustomStringConvertible {
    var description: String {
        return """
        <Sport>
        <name>\(self.name)</name>
        <code>\(self.code)</code>
        </Sport>
        """
    }
}
