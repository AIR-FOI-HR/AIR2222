//
//  Event.swift
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import Foundation

struct Event: Codable {
    let id: Int
    let name: String
    let location: String
    let timestamp: TimeInterval
    let participantNumber: Int
    let cost: Double?
    let currency: String?
    let creator: UserCreatorEvent
    let category: String
    let description: String?
    let participants: [Participant?]
    let latitude: Decimal
    let longitude: Decimal
    
    enum CodingKeys: String, CodingKey {
            case id = "event_id"
            case name = "event_name"
            case location = "event_location"
            case timestamp = "event_timestamp"
            case participantNumber = "participants_no"
            case cost = "cost"
            case currency = "currency"
            case creator = "creator"
            case category = "category"
            case description = "description"
            case participants = "participants"
            case latitude = "location_latitude"
            case longitude = "location_longitude"
    }
    
    enum status: String {
            case pending
            case inProgress
            case done
    }
}

extension Event {
    func timeStampToString(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormats.dateFormatClient
        return dateFormatter.string(from: date)
    }
}
