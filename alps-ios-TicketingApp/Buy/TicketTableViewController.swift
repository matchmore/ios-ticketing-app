//
//  TicketTableViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import AlpsSDK

class TicketTableViewController: UITableViewController, MatchDelegate {
    var matches = [Match]()
    var onMatch: OnMatchClosure? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start Monitoring
        self.onMatch = { matches, _ in
            self.matches = matches
            self.tabBarController?.tabBar.items?[0].badgeValue = self.matches.count > 0 ? String(describing: matches.count) : nil
            self.tableView.reloadData()
        }
        MatchMore.matchDelegates += self
        
        // Fill with cached data
        self.matches = MatchMore.allMatches
        self.tabBarController?.tabBar.items?[0].badgeValue =  self.matches.count > 0 ? String(describing: matches.count) : nil
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

        cell.concertLabel.text = properties?["concert"] as? String
        cell.priceLabel.text = "$\(String(describing: properties?["price"] as! Double))"
        cell.deviceTypeLabel.text = properties?["deviceType"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let match = matches[indexPath.row]
        let properties = match.publication?.properties
        let ticketName = properties?["concert"] as! String
        let phoneNumber = properties?["phone"] as! String
        let alert = UIAlertController(title: "Contact Seller", message: "Do you want to call \(ticketName)'s seller?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Call", style: .default) { _ in
            let cleanPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            let urlString:String = "tel://\(cleanPhoneNumber)"
            if let phoneCallURL = URL(string: urlString) {
                if (UIApplication.shared.canOpenURL(phoneCallURL)) {
                    UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
