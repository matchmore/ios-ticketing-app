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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mobileView.isHidden = false
            pinView.isHidden = true
            iBeaconView.isHidden = true
        case 1:
            mobileView.isHidden = true
            pinView.isHidden = false
            iBeaconView.isHidden = true
        case 2:
            mobileView.isHidden = true
            pinView.isHidden = true
            iBeaconView.isHidden = false
        default:
            break
        }
    }
}
