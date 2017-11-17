//
//  PublicationViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit

class AddPublicationViewController: UIViewController {

    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var pinView: UIView!
    @IBOutlet weak var iBeaconView: UIView!
    
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
