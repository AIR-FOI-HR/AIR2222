//
//  UserProfile.swift
//  Clique
//
//  Created by Infinum on 29.11.2022..
//

import Foundation

struct UserProfile: Codable {
    let user_id: Int
    let name: String
    let surname: String
    let email: String
    let contact_no: String
    let birth_data: String
    let profile_pic: String
    let bio: String
}

