//
//  UserProfileUpdateData.swift
//  Clique
//
//  Created by Infinum on 30.11.2022..
//

import Foundation

struct UserProfileUpdateData: Codable {
    let name: String
    let surname: String
    let email: String
    let gender: String
    let contact_no: String
    let birth_data: String
    let profile_pic: String
    let bio: String
}
