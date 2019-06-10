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
    let region: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case code = "alpha3Code"
        case region = "region"
    }
}


struct Region {
    let name: String
    let items: [Country]
}
