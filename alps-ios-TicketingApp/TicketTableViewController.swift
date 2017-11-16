//
//  TicketTableViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import AlpsSDK
import Alps

class TicketTableViewController: UITableViewController, AlpsManagerDelegate {
    var matches = [Match]()
    var notificationCounter = 0
    
    var onMatch: OnMatchClosure? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.myOrange
        
        // Start Monitoring
        self.onMatch = { matches, _ in
            self.matches = matches
            self.tabBarController?.tabBar.items?[0].badgeValue = String(describing: matches.count)
            self.tableView.reloadData()
        }
        MatchMore.matchDelegates += self
        
        // Fill with cached data
        self.matches = MatchMore.matches
        self.tabBarController?.tabBar.items?[0].badgeValue = String(describing: matches.count)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TicketTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TicketTableViewCell
        
        let match = matches[indexPath.row]
        let properties = match.publication?.properties

        cell.concertLabel.text = properties?["concert"]
        cell.priceLabel.text = properties?["price"]
        cell.deviceTypeLabel.text = properties?["deviceType"]
        return cell
    }
}
