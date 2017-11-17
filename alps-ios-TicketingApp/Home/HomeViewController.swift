//
//  LoginViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 06.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import AlpsSDK
import Alps
import CoreLocation
import MapKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table View Data Source and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    
    // MARK: - Action
    
    @IBAction func useMainDevice(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        MatchMore.createMainDevice { result in
            switch result {
            case .success(_):
                self.createSubscription()
            case .failure(let error):
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
            sender.isEnabled = true
        }
    }
    
    func createSubscription() {
        let subscription = Subscription(
            topic: "ticketstosale",
            range: 100,
            duration: 300,
            selector: "concert='Montreux Jazz'"
        )
        subscription.pushers = ["ws"]
        if let deviceToken = MatchMore.deviceToken {
            subscription.pushers?.append("apns://\(deviceToken)")
        }
        MatchMore.createSubscription(subscription: subscription) { (result) in
            switch result {
            case .success(_):
                MatchMore.startListeningForNewMatches()
            case .failure(let error):
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
        }
    }
}
