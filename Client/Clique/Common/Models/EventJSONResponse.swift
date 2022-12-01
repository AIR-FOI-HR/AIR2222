//
//  File.swift
//  Clique
//
//  Created by Infinum on 27.11.2022..
//

import Foundation


struct EventJSONResponse: Codable {
    let status: String
    let method: String
    let events: [Event]
    
}
