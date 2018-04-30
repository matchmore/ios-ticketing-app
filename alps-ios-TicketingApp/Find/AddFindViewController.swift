//
//  AddFindViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Maciej Burda on 17/11/2017.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import Matchmore
import PKHUD
import SkyFloatingLabelTextField
import UIKit

class AddFindViewController: UIViewController {
    @IBOutlet var eventNameTextField: SkyFloatingLabelTextField!
    @IBOutlet var radiusLabel: UILabel!
    @IBOutlet var maxPriceLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var radiusSlider: UISlider!
    @IBOutlet var maxPriceSlider: UISlider!
    @IBOutlet var durationSlider: UISlider!

    // MARK: - Action

    @IBAction func radiusValueChanged(_ sender: UISlider) {
        radiusLabel.text = "RADIUS: \(String(format: "%.1f", sender.value)) km"
    }

    @IBAction func maxPriceValueChanged(_ sender: UISlider) {
        maxPriceLabel.text = "MAX PRICE: $\(String(format: "%.2f", sender.value))"
    }

    @IBAction func durationValueChanged(_ sender: UISlider) {
        durationLabel.text = "DURATION: \(Int(sender.value)) days"
    }

    // MARK: - Alps SDK

    @IBAction func createSubscription(_: Any) {
        let range = Double(Int(radiusSlider.value * 1000))
        let duration = Double(Int(durationSlider.value * 24 * 60 * 60))
        let name = eventNameTextField.text ?? ""
        let price = Int(maxPriceSlider.value)
        let email = "maciej.burda@me.com"

        var ticket = Ticket(name: name, price: price, sellerEmail: email, subscriptionId: nil)

        let subscription = Subscription(
            topic: "ticketstosale",
            range: range,
            duration: duration,
            selector: ticket.selector
        )
        subscription.pushers = ["ws"]
        if let deviceToken = Matchmore.deviceToken {
            subscription.pushers?.append("apns://\(deviceToken)")
        } else {
            print("Device is not configured to receive push notification.")
        }
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        Matchmore.createSubscriptionForMainDevice(subscription: subscription) { result in
            switch result {
            case let .success(subscription):
                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                ticket.subscriptionId = subscription.id
                self.navigationController?.popToRootViewController(animated: true)
            case let .failure(error):
                PKHUD.sharedHUD.contentView = PKHUDErrorView()
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
            PKHUD.sharedHUD.hide()
        }
    }
}
