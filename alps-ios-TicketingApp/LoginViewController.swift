//
//  LoginViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 06.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameLabel: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.title = "Username"
        usernameLabel.tintColor = UIColor(red:0.93, green:0.51, blue:0.31, alpha:1.0)
        usernameLabel.selectedLineColor = UIColor(red:0.93, green:0.51, blue:0.31, alpha:1.0)
        usernameLabel.selectedLineHeight = 2.0
        usernameLabel.lineHeight = 1.0
        usernameLabel.selectedTitleColor = UIColor(red:0.93, green:0.51, blue:0.31, alpha:1.0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
