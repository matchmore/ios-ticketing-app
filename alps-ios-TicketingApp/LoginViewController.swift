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
    // Using appDelegate as a singleton
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var alps: AlpsManager!
    var username: String?
    var deviceName: String?
    // Mobile Device Location Properties
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var altitude: CLLocationDistance?
    var horizontalAccuracy: CLLocationAccuracy?
    var verticalAccuracy: CLLocationAccuracy?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.alps = appDelegate?.alps
        // SkyFloatingLabel for UI
        usernameLabel.title = "Username"
        usernameLabel.tintColor = self.appDelegate?.orange
        usernameLabel.selectedLineColor = (self.appDelegate?.orange)!
        usernameLabel.selectedLineHeight = 2.0
        usernameLabel.lineHeight = 1.0
        usernameLabel.selectedTitleColor = (self.appDelegate?.orange)!
        // Do any additional setup after loading the view.
        // Authorization status control
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .authorizedWhenInUse:
            NSLog("Location is authorized")
        case .authorizedAlways:
            NSLog("Location is authorized")
        case .denied :
            self.appDelegate?.locationManager.requestWhenInUseAuthorization()
        case .notDetermined:
            self.appDelegate?.locationManager.requestWhenInUseAuthorization()
        case .restricted :
            self.appDelegate?.locationManager.requestWhenInUseAuthorization()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AlpsSDK functions
    
    // Calls Matchmore to create the user and device
    func createDevice(username: String, completion: @escaping (_ device: MobileDevice?) -> Void) {
        let deviceCompletion = completion
        if self.latitude != nil, self.longitude != nil, self.altitude != nil, self.horizontalAccuracy != nil, self.verticalAccuracy != nil {
            let location = Location(latitude: self.latitude!, longitude: self.longitude!, altitude: self.altitude!, horizontalAccuracy: self.horizontalAccuracy!, verticalAccuracy: self.verticalAccuracy!)
            let mobileDevice = MobileDevice(name: "Test's device", platform: "iOS 10.2", deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb662", location: location)
            self.appDelegate?.alps.createMainDevice(device: mobileDevice) { (result) in
                    switch result {
                    case .success(let device):
                        guard let deviceId = device?.id else {
                            NSLog("ERROR : No deviceId found.")
                            return
                        }
                        guard let name = device?.name else {
                            NSLog("ERROR : No device name found.")
                            return
                        }
                        
                        NSLog("Created device: id = \(String(describing: deviceId)), name = \(String(describing: name))")
                        self.appDelegate?.device = device
                        self.appDelegate?.deviceId = deviceId
                        deviceCompletion(device)
                    case .failure(let error):
                        NSLog(error.debugDescription)
                    }
                }
            } else {
            let location = Location(latitude: 0, longitude: 0, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0)
            let mobileDevice = MobileDevice(name: "Test's device", platform: "iOS 10.2", deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb662", location: location)
            self.appDelegate?.alps.createMainDevice(device: mobileDevice) { (result) in
                switch result {
                case .success(let device):
                    guard let deviceId = device?.id else {
                        NSLog("ERROR : No deviceId found.")
                        return
                    }
                    guard let name = device?.name else {
                        NSLog("ERROR : No device name found.")
                        return
                    }
                    NSLog("Created device: id = \(String(describing: deviceId)), name = \(String(describing: name))")
                    self.appDelegate?.device = device
                    self.appDelegate?.deviceId = deviceId
                    deviceCompletion(device)
                case .failure(let error):
                    NSLog(error.debugDescription)
                }
            }
        }
    }
    
    // Calls The AlpsSDK to create a subscription
    func createSubscription() {
        if self.appDelegate?.device != nil {
            let topic = "ticketstosale"
            let selector = "concert='Montreux Jazz'"
            let range = 100.0
            let duration = 300.0
            let subscription = Subscription.init(deviceId: self.appDelegate?.deviceId, topic: topic, range: range, duration: duration, selector: selector)
            NSLog("la subscription")
            self.appDelegate?.alps.createSubscription(subscription: subscription) { (result) in
                switch result {
                case .success(let subscription):
                    NSLog("Created subscription: id = \(String(describing: subscription?.id)), topic = \(String(describing: subscription?.topic)), selector = \(String(describing: subscription?.selector))")
                case .failure(let error):
                    NSLog(error.debugDescription)
                }
            }
        }
    }
    
    // MARK: - Action
    
    @IBAction func login(_ sender: UIButton) {
        if let username = usernameLabel.text {
            createDevice(username: username) {(_ device) in
                if device != nil {
                    let refreshAlert = UIAlertController(title: "Subscription", message: "Do you want to subscribe to the topic : ticketstosale and selector : Montreux Jazz ?", preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Yes, please subscribe to this topic", style: .default, handler: { (action: UIAlertAction!) in
                        self.createSubscription()
                        NSLog("SUBCRIBED")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        self.present(vc, animated: true, completion: nil)
                    }))
                    refreshAlert.addAction(UIAlertAction(title: "No, thank you", style: .default, handler: { (action: UIAlertAction!) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        self.present(vc, animated: true, completion: nil)
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                } else {
                    NSLog("ERROR IN API CALL, check MatchMore service is active.")
                }
            }
        } else {
            NSLog("ERROR username text is not allowed.")
        }
    }
}
