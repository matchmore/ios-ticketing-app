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
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var alps: AlpsManager!
    var publications = [Publication]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = self.appDelegate?.orange
    }
    override func viewWillAppear(_ animated: Bool) {
        getPublications()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PublicationTableViewCell else {
            fatalError("The dequeued cell is not an instance of PublicationTableViewCell.")
        }
        // Configure the cell...
        guard let pub = publications[indexPath.row] as? Publication else {
            fatalError("PublicationTableViewController error : the publication is not from a Publication class.")
        }
        cell.concertLabel.text = pub.properties?["concert"]
        cell.priceLabel.text = pub.properties?["price"]
        cell.deviceTypeLabel.text = pub.properties?["deviceType"]
        return cell
    }

    @IBAction func unwindToSubscriptionList(sender: UIStoryboardSegue) {
    }
    // MARK: - HELPER method
    // Get the publication at index in publications array
    func publicationAtIndexPath(indexPath: NSIndexPath) -> Publication {
        let publication = publications[indexPath.row]
        return publication
    }

    // MARK: - AlpsSDK Functions
    private func getPublications() {
        MatchMore.publications.findAll(completion: { (result) in
            switch result {
            case .success(let publications):
                var ourPublications = [Publication]()
                for (p) in publications {
                    ourPublications.append(p)
                }
                self.publications = ourPublications
                self.tableView.reloadData()
            case .failure(let error):
                NSLog(error.debugDescription)
            }
        })
    }
}
