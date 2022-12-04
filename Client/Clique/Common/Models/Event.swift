//
//  Event.swift
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import Foundation

struct Event: Codable {
    let eventID: Int
    let eventName: String
    let eventLocation: String
    let eventTimestamp: String
    let eventParticipantNumber: Int
    let eventCost: Double?
    let eventCurrency: String?
    let eventCreator: Creator
    let eventCategory: String
    let eventDescription: String?
    
    enum CodingKeys: String, CodingKey {
            case eventID = "event_id"
            case eventName = "event_name"
            case eventLocation = "event_location"
            case eventTimestamp = "event_timestamp"
            case eventParticipantNumber = "participants_no"
            case eventCost = "cost"
            case eventCurrency = "currency"
            case eventCreator = "creator"
            case eventCategory = "category"
            case eventDescription = "description"
    }  
}
