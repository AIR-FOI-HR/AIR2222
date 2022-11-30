//
//  UserGet.swift
//  Clique
//
//  Created by Infinum on 29.11.2022..
//

import Foundation

struct UserGet: Codable {
    let status: String
    let method: String
    let users: [UserProfile]
}
