//
//  PublicationTableViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 06.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import AlpsSDK
import PKHUD

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
        cell.concertLabel.text = String(describing: pub.properties?["concert"] as! String)
        cell.priceLabel.text = "$\(String(describing: pub.properties?["price"] as! Double))"
        cell.deviceTypeLabel.text = pub.properties?["deviceType"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let publication = publications[indexPath.row]
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            MatchMore.publications.delete(item: publication, completion: { (error) in
                if error == nil {
                    PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                    PKHUD.sharedHUD.hide()
                    self.publications.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    PKHUD.sharedHUD.contentView = PKHUDErrorView()
                    PKHUD.sharedHUD.hide()
                    self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
                }
            })
        }
    }

    // MARK: - AlpsSDK Functions
    
    private func getPublications() {
        MatchMore.publications.findAll(completion: { publications in
            self.publications = publications
            self.tableView.reloadData()
        })
    }
}
