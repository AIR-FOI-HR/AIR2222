//
//  PasswordData.swift
//  Clique
//
//  Created by Infinum on 01.12.2022..
//

import Foundation

struct PasswordData: Codable {
    let oldPassword: String
    let newPassword: String
    
    enum CodingKeys: String, CodingKey {
        case oldPassword = "OldPassword"
        case newPassword = "NewPassword"
    }
}
