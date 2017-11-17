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

class HomeViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
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
            case .success(_):
                MatchMore.startListeningForNewMatches()
            case .failure(let error):
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Action
    
    @IBAction func createMainDevice(_ sender: UIButton) {
        MatchMore.createMainDevice { result in
            switch result {
            case .success(_):
                self.createSubscription()
            case .failure(let error):
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
        }
    }
}
