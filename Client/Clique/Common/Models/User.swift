//
//  UserProfile.swift
//  Clique
//
//  Created by Infinum on 29.11.2022..
//

import Foundation

struct User: Codable {
    let id: Int?
    let name: String
    let surname: String
    let email: String
    let contact: String
    let birthDate : String
    let profilePicture: String
    let bio: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name = "name"
        case surname = "surname"
        case email = "email"
        case contact = "contact_no"
        case birthDate = "birth_data"
        case profilePicture = "profile_pic"
        case bio = "bio"
    }
}

