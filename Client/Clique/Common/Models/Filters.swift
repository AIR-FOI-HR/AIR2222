//
//  Filters.swift
//  Clique
//
//  Created by Infinum on 13.12.2022..
//

import Foundation

struct Filter {
//    var distance: Int
    var dateFrom: Date
    var dateTo: Date
    var numOfPart: Int
    var state: Cost
    var category: String
}

extension Filter {
    
    enum Cost {
        case trueTrue
        case trueFalse
        case falseTrue
    }
}
