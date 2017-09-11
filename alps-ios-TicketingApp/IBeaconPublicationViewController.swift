//
//  IBeaconPublicationViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import AlpsSDK

class IBeaconPublicationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var concertTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var proximityUUIDTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var minorTextField: UITextField!
    @IBOutlet weak var publishButton: UIButton!
    var i = 1
    
    // Using appDelegate as a singleton
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var alps : AlpsManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alps = self.appDelegate.alps
        self.concertTextField.delegate = self
        self.priceTextField.delegate = self
        self.imageTextField.delegate = self
        self.durationTextField.delegate = self
        self.proximityUUIDTextField.delegate = self
        self.majorTextField.delegate = self
        self.minorTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        publishButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func publishAction(_ sender: Any) {
        publishButton.isEnabled = false
        
        if let price = Double(priceTextField.text!), let image = imageTextField.text, let concert = concertTextField.text, let duration = Double(durationTextField.text!), let proximityUUID = proximityUUIDTextField.text, let major = Double(majorTextField.text!), let minor = Double(minorTextField.text!){
            createPublication(concert: concert, price: price, image: image, duration: duration, proximityUUID: proximityUUID, major: major, minor: minor, completion: {
                () in
                self.navigationController?.popToRootViewController(animated: true)
            })
        } else {
            print("Issue with price.")
            print("Issue with duration.")
            print("Issue with range.")
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - AlpsSDK
    func createPublication(concert: String, price: Double, image: String, duration: Double, proximityUUID: String, major: Double, minor: Double, completion: @escaping () -> Void) {
        let realMajor = NSNumber.init(value: major)
        let realMinor = NSNumber.init(value: minor)
        self.appDelegate.alps.createIBeaconDevice(name: "beacon device \(i)", proximityUUID: proximityUUID, major: realMajor, minor: realMinor, completion: {
            (_ device) in
            print("IBeacon DEVICE Created")
            // XXX: the property syntax is tricky at the moment: mood is a variable and 'happy' is a string value
            var properties : [String:String] = [:]
            properties["concert"] = concert
            properties["price"] = "\(price)"
            properties["image"] = image
            properties["deviceType"] = "iBeacon"
            if let deviceId = device?.id{
                self.alps.createPublication(userId: self.appDelegate.userId!, deviceId: deviceId, topic: "ticketstosale", range: 0.0, duration: duration, properties: properties, completion: {
                    (_ publication) in
                    if let p = publication {
                        print("DEVICE ID : ")
                        print(device?.id)
                        print("Created publication: id = \(String(describing: p.id)), topic = \(String(describing: p.topic)), properties = \(String(describing: p.properties))")
                        self.i += 1
                        self.appDelegate.alps.addBeacon(beacon: device!)
                        completion()
                    }
                })
            }
        })
    }
}
