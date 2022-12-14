//
//  Participant.swift
//  Clique
//
//  Created by Infinum on 13.12.2022..
//

import Foundation

struct Participant: Codable {
    let user: User
    let status: Int
    
    enum CodingKeys: String, CodingKey{
        case user = "participant"
        case status = "status"
    }
}
