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


class TicketTableViewController: UITableViewController {
    
    var matches = [Match]()
    var notificationCounter = 0
    // Using appDelegate as a singleton
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var alps : AlpsManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.alps = self.appDelegate.alps
        self.navigationController?.navigationBar.barTintColor = self.appDelegate.orange
        // This function will be called everytime there is a match.
//        self.monitorMatchesWithCompletion { (_ match) in self.notificationOnMatch(match: match)}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if appDelegate.deviceId != nil {
            // call the API, to retrieve all the subscriptions for current user and device
            getAllMatches()
            self.resetNotificationOnMatch()
        }else{
            print("ERROR in MATCHESVIEWCONTROLLER: deviceId is nil.")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TicketTableViewCell  else {
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

    //MARK: HELPER method
    
    // Get the match at index in matches array
    func matchAtIndexPath(indexPath: NSIndexPath) -> Match{
        let match = matches[indexPath.row]
        return match
    }
    
    // Use this function to transform timestampe to local date displayed in String
    func transformTimestampToDate(timestamp : Int64) -> String {
        let dateTimeStamp = NSDate(timeIntervalSince1970:Double(timestamp)/1000)  //UTC time
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Edit
        dateFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeStyle = DateFormatter.Style.short
        let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
        
        return strDateSelect
    }
    
    
    //MARK: Notification related
    
    // Shows notifications on match
    func notificationOnMatch(){
        notificationCounter += 1
        tabBarController?.tabBar.items?[0].badgeValue = String(describing: notificationCounter)
//        let topic = match.publication?.topic
//        let selector = match.subscription?.selector
//        let alert = UIAlertController(title: "An interesting offer is close to you!", message: "Topic : \(String(describing: topic!))\nSelector : \(String(describing: selector!))", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Understood", style: .default, handler: nil))
//        self.present(alert, animated: true)
    }
    
    // Resets the TabBar Item badge value
    func resetNotificationOnMatch(){
        notificationCounter = 0
        tabBarController?.tabBar.items?[0].badgeValue = nil
    }
    
    //MARK: AlpsSDK functions
    
    // Start the match service
    func monitorMatches() {
        self.appDelegate.alps.matchMonitor.startMonitoringFor(device: self.appDelegate.device!)
    }
    
    // Get the match
//    func monitorMatchesWithCompletion(completion: @escaping (_ match: Match) -> Void) {
//        self.appDelegate.alps.onMatch(completion: completion)
//    }
    
    // Calls the SDK to get all matches for actual userId and deviceId
    func getAllMatches(){
        self.appDelegate.alps.onMatch = {(matches, device) in
            self.matches = matches
            self.notificationOnMatch()
            self.tableView.reloadData()
        }
    }


}
