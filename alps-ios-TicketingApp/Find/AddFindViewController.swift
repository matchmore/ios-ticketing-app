//
//  AddFindViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Maciej Burda on 17/11/2017.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import AlpsSDK
import PKHUD
import SkyFloatingLabelTextField

class AddFindViewController: UIViewController {
    
    @IBOutlet weak var eventNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var maxPriceSlider: UISlider!
    @IBOutlet weak var durationSlider: UISlider!
    
    // MARK: - Action
    
    @IBAction func radiusValueChanged(_ sender: UISlider) {
        radiusLabel.text = "RADIUS: \(Int(sender.value)) km"
    }
    
    @IBAction func maxPriceValueChanged(_ sender: UISlider) {
        maxPriceLabel.text = "MAX PRICE: $\(Int(sender.value))"
    }
    
    @IBAction func durationValueChanged(_ sender: UISlider) {
        durationLabel.text = "DURATION: \(Int(sender.value)) days"
    }
    
    // MARK: - Alps SDK
    
    @IBAction func createSubscription(_ sender: Any) {
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
        if let deviceToken = MatchMore.deviceToken {
            subscription.pushers?.append("apns://\(deviceToken)")
        } else {
            print("Device is not configured to receive push notification.")
        }
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        MatchMore.createSubscriptionForMainDevice(subscription: subscription) { (result) in
            switch result {
            case .success(let subscription):
                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                ticket.subscriptionId = subscription.id
                self.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
                PKHUD.sharedHUD.contentView = PKHUDErrorView()
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
            PKHUD.sharedHUD.hide()
        }
    }
}
