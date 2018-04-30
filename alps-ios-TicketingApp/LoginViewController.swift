//
//  LoginViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 06.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import Alps
import AlpsSDK
import CoreLocation
import MapKit
import SkyFloatingLabelTextField
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!

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
        MatchMore.createSubscription(subscription: subscription) { result in
            switch result {
            case .success:
                MatchMore.startListeningForNewMatches()
            case let .failure(error):
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
        }
    }

    // MARK: - Action

    @IBAction func createMainDevice(_: UIButton) {
        MatchMore.createMainDevice { result in
            switch result {
            case .success:
                self.createSubscription()
            case let .failure(error):
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
        }
    }
}
