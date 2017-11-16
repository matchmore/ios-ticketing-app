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
    var publications = [Publication]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.myOrange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPublications()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PublicationTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PublicationTableViewCell else {
            fatalError("The dequeued cell is not an instance of PublicationTableViewCell.")
        }
        // Configure the cell...
        let pub = publications[indexPath.row]
        cell.concertLabel.text = pub.properties?["concert"]
        cell.priceLabel.text = pub.properties?["price"]
        cell.deviceTypeLabel.text = pub.properties?["deviceType"]
        return cell
    }

    @IBAction func unwindToSubscriptionList(sender: UIStoryboardSegue) { }

    // MARK: - AlpsSDK Functions
    private func getPublications() {
        MatchMore.publications.findAll(completion: { (result) in
            switch result {
            case .success(let publications):
                self.publications = publications
                self.tableView.reloadData()
            case .failure(let error):
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
        })
    }
}
