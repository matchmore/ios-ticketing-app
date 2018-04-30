//
//  PublicationViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import UIKit

class AddPublicationViewController: UIViewController {
    @IBOutlet var mobileView: UIView!
    @IBOutlet var pinView: UIView!
    @IBOutlet var iBeaconView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mobileView.isHidden = false
        pinView.isHidden = true
        iBeaconView.isHidden = true
    }

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        let views = [mobileView, pinView, iBeaconView]
        views.forEach { $0?.isHidden = true }
        views[sender.selectedSegmentIndex]?.isHidden = false
    }
}
