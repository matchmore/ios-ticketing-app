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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var alps : AlpsManager!
    var username : String?
    var deviceName : String?
    
    // Mobile Device Location Properties
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    var altitude : CLLocationDistance?
    var horizontalAccuracy : CLLocationAccuracy?
    var verticalAccuracy : CLLocationAccuracy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alps = appDelegate.alps
        // SkyFloatingLabel for UI
        usernameLabel.title = "Username"
        usernameLabel.tintColor = self.appDelegate.orange
        usernameLabel.selectedLineColor = self.appDelegate.orange
        usernameLabel.selectedLineHeight = 2.0
        usernameLabel.lineHeight = 1.0
        usernameLabel.selectedTitleColor = self.appDelegate.orange
        // Do any additional setup after loading the view.
        // Authorization status control
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus{
        case .authorizedWhenInUse:
            print("Location is authorized")
            break
        case .authorizedAlways:
            print("Location is authorized")
            break
        case .denied :
            self.appDelegate.locationManager.requestWhenInUseAuthorization()
            break
        case .notDetermined:
            self.appDelegate.locationManager.requestWhenInUseAuthorization()
            break
        case .restricted :
            self.appDelegate.locationManager.requestWhenInUseAuthorization()
            break
        }
        // AlpsSDK
        onLocationUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: AlpsSDK functions
    
    // Calls Matchmore to create the user and device
    func createDevice(username : String, completion: @escaping (_ device: MobileDevice?) -> Void) {
        var deviceCompletion = completion
        alps.createUser(username) {
            (_ user) in
            if let u = user {
                print("Created user: id = \(String(describing: u.id!)), name = \(String(describing: u.name!))")
                
                guard let userId = u.id else{
                    print("ERROR : No userId found")
                    return
                }
                self.appDelegate.userId = userId
                
                guard let username = u.name else{
                    print("ERROR : No name found")
                    return
                }
                self.appDelegate.username = username
                
                if self.latitude != nil, self.longitude != nil, self.altitude != nil, self.horizontalAccuracy != nil, self.verticalAccuracy != nil {
                        self.alps.createMobileDevice(name: "\(username)'s device", platform: "iOS 10.2",
                                                     deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb662",
                                                     latitude: self.latitude!, longitude: self.longitude!, altitude: self.altitude!,
                                                     horizontalAccuracy: self.horizontalAccuracy!, verticalAccuracy: self.verticalAccuracy!) {
                                                        (_ device) in
                                                        if let d = device {
                                                            guard let deviceId = d.id else{
                                                                print("ERROR : No deviceId found.")
                                                                return
                                                            }
                                                            guard let name = d.name else{
                                                                print("ERROR : No device name found.")
                                                                return
                                                            }
                                                            
                                                            print("Created device: id = \(String(describing: deviceId)), name = \(String(describing: name))")
                                                            self.appDelegate.device = d
                                                            self.appDelegate.deviceId = deviceId
                                                            deviceCompletion(device)
                                                        }
                    }
                } else {
                    self.alps.createMobileDevice(name: "\(username)'s device", platform: "iOS 10.2",
                                                 deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb662",
                                                 latitude: 0.0, longitude: 0.0, altitude: 0.0,
                                                 horizontalAccuracy: 0.0, verticalAccuracy: 0.0) {
                                                    (_ device) in
                                                    if let d = device {
                                                        guard let deviceId = d.id else{
                                                            print("ERROR : No deviceId found.")
                                                            return
                                                        }
                                                        guard let name = d.name else{
                                                            print("ERROR : No device name found.")
                                                            return
                                                        }
                                                        
                                                        print("Created device: id = \(String(describing: deviceId)), name = \(String(describing: name))")
                                                        self.appDelegate.device = d
                                                        self.appDelegate.deviceId = deviceId
                                                        deviceCompletion(device)
                                                    }
                    }
                }
            }
        }
    }
    
    // Calls The AlpsSDK to create a subscription
    func createSubscription(){
        if self.appDelegate.device != nil {
            let topic = "ticketstosale"
            let selector = "concert='Montreux Jaz'"
            let range = 100.0
            let duration = 300.0
            self.appDelegate.alps.createSubscription(topic: topic,
                                                     selector: selector, range: range, duration: duration) {
                                                        (_ subscription) in
                                                        if let s = subscription {
                                                            print("Created subscription: id = \(String(describing: s.id!)), topic = \(String(describing: s.topic!)), selector = \(String(describing: s.selector!))")
                                                           
                                                        }
            }
        }
    }
    
    private func onLocationUpdate() {
        // Get location with the AlpsSDK
        self.alps.onLocationUpdate(){
            (_ location) in
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            self.altitude = location.altitude
            self.horizontalAccuracy = location.horizontalAccuracy
            self.verticalAccuracy = location.verticalAccuracy
        }
    }
    
    // MARK: - Action
    
    @IBAction func login(_ sender: UIButton) {
        if let username = usernameLabel.text {
            createDevice(username: username){
                (_ device) in
                if device != nil {
                    self.createSubscription()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                    vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    self.present(vc, animated: true, completion: nil)
                } else {
                    print("ERROR IN API CALL, check MatchMore service is working.")
                }
            }
        } else {
            print("ERROR username text is not allowed.")
        }
    }
}
