//
//  Ticket.swift
//  alps-ios-TicketingApp
//
//  Created by Maciej Burda on 07/12/2017.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import Foundation

struct Ticket {
    let name: String?
    let price: Int?
    let tags: [String]?
    
    var seller: Seller?
    
    var subscriptionId: String?
    
    var properties: [String: Any] {
        return [
            "name": name ?? "",
            "price": price ?? "",
            "tags": "\(String(describing: tags))" ,
            "seller": [
                "email": seller?.email ?? "",
                "phone": seller?.phone ?? ""
            ]
        ]
    }
    
    var selector: String {
        var selector = ""
        if let name = name, name != "" {
            selector += "name = \(name)"
        }
        if let price = price, price != 0 {
            if selector != "" {
                selector += " and "
            }
            selector += "price <= \(price)"
        }
        if let tags = tags, !tags.isEmpty {
            if selector != "" {
                selector += " and "
            }
            selector += "tags in "
            var tagsString = "\(tags)"
            tagsString = tagsString.replacingOccurrences(of: "[", with: "(")
            tagsString = tagsString.replacingOccurrences(of: "]", with: ")")
            selector += tagsString
        }
        return selector
    }
}

struct Seller {
    let email: String?
    let phone: String?
}
