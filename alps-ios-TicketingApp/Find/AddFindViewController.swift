//
//  AddFindViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Maciej Burda on 17/11/2017.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import AlpsSDK
import Alps
import PKHUD
import SkyFloatingLabelTextField
import TagListView

class AddFindViewController: UIViewController {
    
    @IBOutlet weak var eventNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var maxPriceSlider: UISlider!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var tagsView: TagListView!
    
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
    
    var textField: UITextField?
    @IBAction func addTag() {
        let alert = UIAlertController(title: "Add Tag", message: nil, preferredStyle:.alert)
        alert.addTextField { textField in
            self.textField = textField
        }
        alert.addAction(
            UIAlertAction(title: "Ok", style: .default, handler: { _ in
                if let tagName = self.textField?.text, tagName != "" {
                    self.tagsView.addTag(tagName)
                }
                self.textField = nil
            })
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion:nil)
    }
    
    @IBAction func createSubscription(_ sender: Any) {
        let range = Double(Int(radiusSlider.value * 1000))
        let duration = Double(Int(durationSlider.value * 24 * 60 * 60))
        let name = eventNameTextField.text ?? ""
        let price = Int(maxPriceSlider.value)
        let tags = tagsView.tagViews.map { $0.title(for: .normal)! }
        
        let ticket = Ticket(name: name, price: price, tags: tags, seller: nil)
        
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
    }
}
