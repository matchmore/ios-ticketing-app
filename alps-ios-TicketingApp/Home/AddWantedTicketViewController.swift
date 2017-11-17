//
//  AddWantedTicketViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Maciej Burda on 17/11/2017.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import AlpsSDK
import Alps
import PKHUD

class AddWantedTicketViewController: UIViewController {

    @IBOutlet weak var concertTextField: UITextField!
    @IBOutlet weak var maxPriceTextField: UITextField!
    @IBOutlet weak var rangeTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!

    // MARK: - Action
    @IBAction func createSubscription(_ sender: Any) {
        if let concert = concertTextField.text,
            let price = Double(maxPriceTextField.text ?? "0"),
            let range = Double(rangeTextField.text ?? "0"),
            let duration = Double(durationTextField.text ?? "0") {
            
            let subscription = Subscription(
                topic: "ticketstosale",
                range: range,
                duration: duration,
                selector: "concert='\(concert)' and price<=\(price)"
            )
            subscription.pushers = ["ws"]
            if let deviceToken = MatchMore.deviceToken {
                subscription.pushers?.append("apns://\(deviceToken)")
            } else {
                print("Device is not configured to receive push notification.")
            }
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            MatchMore.createSubscription(subscription: subscription) { (result) in
                switch result {
                case .success(_):
                    PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                    PKHUD.sharedHUD.hide()
                    self.navigationController?.popToRootViewController(animated: true)
                case .failure(let error):
                    PKHUD.sharedHUD.contentView = PKHUDErrorView()
                    PKHUD.sharedHUD.hide()
                    self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
                }
            }
            
        } else {
            self.present(AlertHelper.simpleError(title: "Please fill all needed fields."), animated: true, completion: nil)
        }
    }
}
