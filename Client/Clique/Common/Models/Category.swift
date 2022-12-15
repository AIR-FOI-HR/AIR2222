//
//  Category.swift
//  Clique
//
//  Created by Infinum on 15.12.2022..
//

import Foundation

struct Category: Codable {
    
    let id: Int
    let name: String
    let pic: String
    let color: String
    
    enum CodingKeys: String, CodingKey {
        case id = "category_id"
        case name = "category_name"
        case pic = "category_pic"
        case color = "category_color"
    }
}
