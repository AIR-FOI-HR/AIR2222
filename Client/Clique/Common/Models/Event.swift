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
    let timestamp: String
    let participantNumber: Int
    let cost: Double?
    let currency: String?
    let creator: UserCreatorEvent
    let category: String
    let description: String?
    let participants: [Participant?]
    
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
    }
    
    enum status: String {
            case pending
            case inProgress
            case done
    }
}

extension Event {
//    var didItEnd(timestamp: TimeInterval): status {
//        let currentTimestamp = Date().timeIntervalSince1970
//        if(currentTimestamp < currentTimestamp) {
//            return .pending
//        } else if(currentTimestamp > currentTimestamp) {
//            return .done
//        } else {
//            return .inProgress
//        }
//    }
}
