//
//  LoginResponse.swift
//  Clique
//
//  Created by Infinum on 21.11.2022..
//

import Foundation

struct LoginResponse: Codable {
    let token: String
    let validUntil: String
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case validUntil = "validTo"
    }
}
