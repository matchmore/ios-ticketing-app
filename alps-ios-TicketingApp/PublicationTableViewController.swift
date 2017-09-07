//
//  PublicationTableViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 06.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import AlpsSDK
import Alps

class PublicationTableViewController: UITableViewController {
    
    // Using appDelegate as a singleton
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var alps : AlpsManager!
    var publications = [Publication]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = self.appDelegate.orange
        if self.appDelegate.userId != nil && self.appDelegate.deviceId != nil {
            // call the API, to retrieve all the subscriptions for current user and device
            getAllPublicationsForDevice(self.appDelegate.userId!, deviceId: self.appDelegate.deviceId!)
        }else{
            print("ERROR in PUBLICATIONTABLEVIEWCONTROLLER: UserId or deviceId is nil.")
        }
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSForegroundColorAttributeName : UIColor.white
//        ]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.appDelegate.userId != nil && self.appDelegate.deviceId != nil {
            // call the API, to retrieve all the subscriptions for current user and device
            print("HEY")
            getAllPublicationsForDevice(self.appDelegate.userId!, deviceId: self.appDelegate.deviceId!)
        }else{
            print("ERROR in PUBLICATIONTABLEVIEWCONTROLLER: UserId or deviceId is nil.")
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
        return publications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PublicationTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PublicationTableViewCell else{
            fatalError("The dequeued cell is not an instance of PublicationTableViewCell.")
        }
        
        // Configure the cell...
        guard let pub = publications[indexPath.row] as? Publication else{
            fatalError("PublicationTableViewController error : the publication is not from a Publication class.")
        }
        cell.concertLabel.text = pub.properties?["concert"]
        cell.priceLabel.text = pub.properties?["price"]
        
        return cell
    }

    @IBAction func unwindToSubscriptionList(sender: UIStoryboardSegue) {
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
    
    // Get the publication at index in publications array
    func publicationAtIndexPath(indexPath: NSIndexPath) -> Publication{
        let publication = publications[indexPath.row]
        return publication
    }
    
    //MARK: AlpsSDK Functions
    
    // Calls the SDK to get all publications for specified userId and deviceId
    func getAllPublicationsForDevice(_ userId:String, deviceId: String) {
        self.appDelegate.alps.getAllPublicationsForDevice(userId, deviceId: deviceId) {
            (_ publications) in
            self.publications = publications
            self.tableView.reloadData()
        }
    }

}
