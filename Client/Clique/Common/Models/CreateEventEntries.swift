//
//  CreateEventEntries.swift
//  Clique
//
//  Created by Infinum on 30.11.2022..
//

import Foundation

struct CreateEventEntries: Codable {
    let name: String
    let location: String
    let timeStamp: String
    let participantsCount: String
    let cost: String
    let currency: String
    let category: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case name = "eventName"
        case location = "eventLocation"
        case timeStamp = "eventTimeStamp"
        case participantsCount = "participantsNo"
        case cost = "cost"
        case currency = "currency"
        case category = "category"
        case description = "description"
    }
}
