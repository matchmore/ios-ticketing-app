//
//  LoginViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 06.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import AlpsSDK
import Alps

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var subscriptions = [Subscription]()
    override func viewWillAppear(_ animated: Bool) {
        getSubscriptions()
    }
    
    // MARK: - Table View Data Source and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "WantedCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let sub = subscriptions[indexPath.row]
        cell.textLabel?.text = sub.id
        cell.detailTextLabel?.text = sub.selector
        return cell
    }
    
    // MARK: - AlpsSDK Functions
    
    private func getSubscriptions() {
        MatchMore.subscriptions.findAll(completion: { (result) in
            switch result {
            case .success(let subscriptions):
                self.subscriptions = subscriptions
                self.tableView.reloadData()
            case .failure(let error):
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
        })
    }
}
