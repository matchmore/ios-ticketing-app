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
import Kingfisher

class PublicationTableViewController: UITableViewController {
    
    var publications = [Publication]()
    override func viewWillAppear(_ animated: Bool) {
        getPublications()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PublicationTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PublicationTableViewCell else {
            fatalError("The dequeued cell is not an instance of PublicationTableViewCell.")
        }
        let pub = publications[indexPath.row]
        cell.concertLabel.text = pub.properties?["concert"] as? String
        cell.priceLabel.text = String(describing: pub.properties?["price"] as? Int)
        cell.deviceTypeLabel.text = pub.properties?["deviceType"] as? String
        
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
