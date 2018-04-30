//
//  TableViewHelper.swift
//  alps-ios-TicketingApp
//
//  Created by Maciej Burda on 08/12/2017.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import Foundation
import UIKit

class TableViewHelper {
    class func EmptyMessage(message: String, tableView: UITableView) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
}
