//
//  Currency.swift
//  Clique
//
//  Created by Infinum on 28.11.2022..
//

import Foundation

struct Currency: Codable {
    let id: Int
    let name: String
    let abbreviation: String
    
    enum CodingKeys: String, CodingKey {
        case id = "currency_id"
        case name = "currency_name"
        case abbreviation = "currency_abbr"
    }
}
