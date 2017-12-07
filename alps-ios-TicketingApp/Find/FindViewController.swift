//
//  FindViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 06.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import AlpsSDK
import Alps
import PKHUD

class FindViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let subscription = subscriptions[indexPath.row]
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            MatchMore.subscriptions.delete(item: subscription, completion: { (error) in
                if error == nil {
                    PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                    PKHUD.sharedHUD.hide()
                    self.subscriptions.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    PKHUD.sharedHUD.contentView = PKHUDErrorView()
                    PKHUD.sharedHUD.hide()
                    self.show(AlertHelper.simpleError(title: "Couldn't remove the subscription."), sender: nil)
                }
            })
        }
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
