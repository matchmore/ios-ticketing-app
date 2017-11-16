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

class LoginViewController: UIViewController {

    // MARK: UI Properties
    @IBOutlet weak var usernameLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Make all such configs from storyboard
        usernameLabel.title = "Username"
        usernameLabel.tintColor = UIColor.myOrange
        usernameLabel.selectedLineColor = UIColor.myOrange
        usernameLabel.selectedLineHeight = 2.0
        usernameLabel.lineHeight = 1.0
        usernameLabel.selectedTitleColor = UIColor.myOrange
    }
    
    // Calls The AlpsSDK to create a subscription
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
            case .success(let subscription):
                // MatchMore.startListeningForNewMatches()
                NSLog("Created subscription: id = \(String(describing: subscription.id)), topic = \(String(describing: subscription.topic)), selector = \(String(describing: subscription.selector))")
            case .failure(let error):
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Action
    
    @IBAction func login(_ sender: UIButton) {
        MatchMore.createMainDevice { result in
            switch result {
            case .success(_):
                let refreshAlert = UIAlertController(title: "Subscription", message: "Do you want to subscribe to the topic : ticketstosale and selector : Montreux Jazz ?", preferredStyle: UIAlertControllerStyle.alert)
                func presentMainScreen() {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                    vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    self.present(vc, animated: true, completion: nil)
                }
                refreshAlert.addAction(UIAlertAction(title: "Yes, please subscribe to this topic", style: .default, handler: { (action: UIAlertAction!) in
                    self.createSubscription()
                    presentMainScreen()
                }))
                refreshAlert.addAction(UIAlertAction(title: "No, thank you", style: .default, handler: { (action: UIAlertAction!) in
                    presentMainScreen()
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            case .failure(let error):
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
        }
    }
}
