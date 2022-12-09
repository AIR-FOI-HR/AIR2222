//
//  UserProfile.swift
//  Clique
//
//  Created by Infinum on 29.11.2022..
//

import Foundation

struct UserProfile: Codable {
    let id: Int
    let name: String
    let surname: String
    let email: String
    let contact: String
    let birth_data: String
    let profile_pic: String
    let bio: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name = "name"
        case surname = "surname"
        case email = "email"
        case contact = "contact_no"
        case birth_data = "birth_data"
        case profile_pic = "profile_pic"
        case bio = "bio"
    }
}

struct UserProfileUpdateData: Codable {
    let name: String
    let surname: String
    let email: String
    let contact_no: String
    let birth_data: String
    let gender: String
    let profile_pic: String
    let bio: String
}

