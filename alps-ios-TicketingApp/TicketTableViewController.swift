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

class MatchDelegate: AlpsManagerDelegate {
    var onMatch: OnMatchClosure
    init(_ onMatch: @escaping OnMatchClosure) {
        self.onMatch = onMatch
    }
}

class TicketTableViewController: UITableViewController {
    var matches = [Match]()
    var notificationCounter = 0
    // Using appDelegate as a singleton
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var alps: AlpsManager!
    var matchDelegate: MatchDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.alps = self.appDelegate?.alps
        self.navigationController?.navigationBar.barTintColor = self.appDelegate?.orange
        // Start Monitoring
        self.matchDelegate = MatchDelegate { (matches, _) in
//            let s1 = Set(self.matches)
//            let s2 = Set(matches)
//            self.matches = Array(s1.symmetricDifference(s2))
            self.matches = matches
            self.notificationOnMatch()
            self.tableView.reloadData()
        }
        MatchMore.matchDelegates.add(self.matchDelegate)
        MatchMore.startMonitoringFor(device: (appDelegate?.device!)!)
        MatchMore.startPollingMatches()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if appDelegate?.deviceId != nil {
            // call the API, to retrieve all the subscriptions for current user and device
            
            self.resetNotificationOnMatch()
        } else {
            NSLog("ERROR in MATCHESVIEWCONTROLLER: deviceId is nil.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TicketTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TicketTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let match = matches[indexPath.row]
        let properties = match.publication?.properties
        // Configure the cell...
        cell.concertLabel.text = properties?["concert"]
        cell.priceLabel.text = properties?["price"]
        cell.deviceTypeLabel.text = properties?["deviceType"]

        return cell
    }

    // MARK: - HELPER method
    // Get the match at index in matches array
    func matchAtIndexPath(indexPath: NSIndexPath) -> Match {
        let match = matches[indexPath.row]
        return match
    }
    
    // Use this function to transform timestampe to local date displayed in String
    func transformTimestampToDate(timestamp: Int64) -> String {
        let dateTimeStamp = NSDate(timeIntervalSince1970: Double(timestamp)/1000)  //UTC time
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Edit
        dateFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeStyle = DateFormatter.Style.short
        let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
        return strDateSelect
    }
    
    // MARK: - Notification related
    // Shows notifications on match
    func notificationOnMatch() {
        notificationCounter += 1
        tabBarController?.tabBar.items?[0].badgeValue = String(describing: notificationCounter)
    }
    
    // Resets the TabBar Item badge value
    func resetNotificationOnMatch() {
        notificationCounter = 0
        tabBarController?.tabBar.items?[0].badgeValue = nil
    }
    
    // MARK: - AlpsSDK functions
    
    // Start the match service
    func monitorMatches() {
        MatchMore.startMonitoringFor(device: (self.appDelegate?.device!)!)
    }
}
