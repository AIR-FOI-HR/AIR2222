//
//  User2.swift
//  Clique
//
//  Created by Infinum on 14.12.2022..
//

import Foundation

struct UserCreatorEvent: Codable {
    let id: Int?
    let name: String
    let surname: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name = "name"
        case surname = "surname"
        case email = "email"
    }
}
