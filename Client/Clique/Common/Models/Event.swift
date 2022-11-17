//
//  Event.swift
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import Foundation

struct Event {
    
    let eventName: String
    let eventLocation: String
    let eventDate: Date?
    let eventTime: TimeZone?
    let eventParticipantNumber: Int
    let eventCost: Double
    let eventCreator: Int
    let eventCategory: Int
    let eventCurrency: String
    
}

extension Event{
    static let datasource: [Event] = [Event(eventName: "", eventLocation: "", eventDate: nil, eventTime: nil, eventParticipantNumber: 0, eventCost: 0, eventCreator: 0, eventCategory: 0, eventCurrency: "")]
}
