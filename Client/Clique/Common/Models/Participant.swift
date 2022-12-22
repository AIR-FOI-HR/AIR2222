//
//  Participant.swift
//  Clique
//
//  Created by Infinum on 14.12.2022..
//

import Foundation

struct Participant: Codable {
    let user: User
    let userStatusOnEvent: Int
    
    enum CodingKeys: String, CodingKey{
        case user = "participant"
        case userStatusOnEvent = "status"
    }
}
