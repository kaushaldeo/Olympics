//
//  Country.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/8/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import Foundation

class Country: Codable {
    let name: String
    let code: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case code = "code"
        case imageURL = "img"
    }
}

