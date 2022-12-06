//
//  Creator.swift
//  Clique
//
//  Created by Infinum on 26.11.2022..
//

import Foundation

struct User: Codable {
    
    let userID: Int
    let userName: String
    let userSurname: String
    let userEmail: String
    
    enum CodingKeys: String, CodingKey{
        case userID = "user_id"
        case userName = "name"
        case userSurname = "surname"
        case userEmail = "email"

    }
}

