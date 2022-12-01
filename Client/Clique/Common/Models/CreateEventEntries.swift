//
//  CreateEventEntries.swift
//  Clique
//
//  Created by Infinum on 30.11.2022..
//

import Foundation

struct CreateEventEntries: Codable {
    let eventName: String
    let eventLocation: String
    let eventTimeStamp: String
    let participantsNo: String
    let cost: String
    let currency: String
    let category: String
    let description: String
}
