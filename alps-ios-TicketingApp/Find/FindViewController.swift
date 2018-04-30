//
//  FindViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 06.09.17.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import Matchmore
import PKHUD
import UIKit

class FindViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    var subscriptions = [Subscription]()

    override func viewWillAppear(_: Bool) {
        getSubscriptions()
    }

    // MARK: - Table View Data Source and Delegate

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return subscriptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FindCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FindTableViewCell else { return UITableViewCell() }
        let sub = subscriptions[indexPath.row]

        cell.nameLabel.text = sub.selector?.slice(from: "'", to: "'")
        cell.radiusLabel.text = "\(String(sub.range! / 1000)) km"
        cell.priceLabel.text = "$\(sub.selector?.slice(from: "<= ") ?? "")"

        let secondsFromCreation = (Date().timeIntervalSince1970 - Double(sub.createdAt! / 1000))
        let timeLeft: Double = sub.duration! - secondsFromCreation
        cell.durationLabel.text = secondsToHoursMinutes(timeLeft)
        return cell
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let subscription = subscriptions[indexPath.row]
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            Matchmore.subscriptions.delete(item: subscription, completion: { error in
                if error == nil {
                    PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                    PKHUD.sharedHUD.hide()
                    self.subscriptions.remove(at: indexPath.row)
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

    private func getSubscriptions() {
        Matchmore.subscriptions.findAll(completion: { subscriptions in
            self.subscriptions = subscriptions
            self.tableView.reloadData()
        })
    }

    // MARK: - Helper

    func secondsToHoursMinutes(_ seconds: Double?) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .full

        let formattedString = formatter.string(from: TimeInterval(seconds!))!
        return formattedString.replacingOccurrences(of: ",", with: "")
    }
}

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom ..< endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom ..< substringTo])
            }
        }
    }

    func slice(from: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            String(self[substringFrom...])
        }
    }
}
