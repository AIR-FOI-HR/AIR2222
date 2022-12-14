//
//  Category.swift
//  Clique
//
//  Created by Infinum on 28.11.2022..
//

import Foundation

struct Category: Codable {
    let id: Int
    let name: String
    let color: String
    
    enum CodingKeys: String, CodingKey {
        case id = "category_id"
        case name = "category_name"
        case color = "category_color"
    }
}



