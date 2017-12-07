//
//  Concert.swift
//  alps-ios-TicketingApp
//
//  Created by Maciej Burda on 07/12/2017.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import Foundation

struct Concert {
    let name: String
    let date: Date
    let maxPrice: Int
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "date": date,
            "maxPrice": maxPrice
        ]
    }
}
