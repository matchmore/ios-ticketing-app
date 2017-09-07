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
        self.navigationController?.navigationBar.barTintColor = self.appDelegate.orange
        // This function will be called everytime there is a match.
        self.monitorMatchesWithCompletion { (_ match) in self.notificationOnMatch(match: match)}
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if appDelegate.userId != nil && appDelegate.deviceId != nil {
            // call the API, to retrieve all the subscriptions for current user and device
            getAllMatches()
            self.resetNotificationOnMatch()
        }else{
            print("ERROR in MATCHESVIEWCONTROLLER: UserId or deviceId is nil.")
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

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    func notificationOnMatch(match: Match){
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
        self.appDelegate.alps.startMonitoringMatches()
    }
    
    // Get the match
    func monitorMatchesWithCompletion(completion: @escaping (_ match: Match) -> Void) {
        self.appDelegate.alps.onMatch(completion: completion)
        self.appDelegate.alps.startMonitoringMatches()
    }
    
    // Calls the SDK to get all matches for actual userId and deviceId
    func getAllMatches(){
        self.appDelegate.alps.getAllMatches() {
            (_ matches) in
            self.matches = matches
            self.tableView.reloadData()
        }
    }


}
