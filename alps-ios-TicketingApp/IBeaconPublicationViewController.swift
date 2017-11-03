//
//  IBeaconPublicationViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import AlpsSDK
import Alps

class IBeaconPublicationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var concertTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var publishButton: UIButton!
    var i = 1
    var pickerData : [IBeaconTriple] = []
    var selectedValue : IBeaconTriple?
    
    // Using appDelegate as a singleton
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var alps : AlpsManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        alps = self.appDelegate.alps
        self.concertTextField.delegate = self
        self.priceTextField.delegate = self
        self.imageTextField.delegate = self
        self.durationTextField.delegate = self
        self.priceTextField.keyboardType = .numbersAndPunctuation
        self.durationTextField.keyboardType = .numbersAndPunctuation
        self.pickerData = self.appDelegate.alps.beaconDevices.items
        if !pickerData.isEmpty {
            self.selectedValue = pickerData[0]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        publishButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].deviceId
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectedValue = pickerData[row]
    }
    
    @IBAction func publishAction(_ sender: Any) {
        publishButton.isEnabled = false
        
        if let price = Double(priceTextField.text!), let image = imageTextField.text, let concert = concertTextField.text, let duration = Double(durationTextField.text!), let deviceId = self.selectedValue?.deviceId {
            createPublication(concert: concert, price: price, image: image, duration: duration, deviceId: deviceId, completion: {
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
    func createPublication(concert: String, price: Double, image: String, duration: Double, deviceId : String, completion: @escaping () -> Void) {
            print("IBeacon DEVICE Created")
            // XXX: the property syntax is tricky at the moment: mood is a variable and 'happy' is a string value
            var properties : [String:String] = [:]
            properties["concert"] = concert
            properties["price"] = "\(price)"
            properties["image"] = image
            properties["deviceType"] = "iBeacon"
        let pub = Publication.init(deviceId: self.appDelegate.deviceId, topic: "ticketstosale", range: 0.0, duration: duration, properties: properties)
        self.appDelegate.alps.createPublication(publication: pub) {
                    (_ publication) in
                    if let p = publication {
                        print("DEVICE ID : ")
                        print(deviceId)
                        print("Created publication: id = \(String(describing: p.id)), topic = \(String(describing: p.topic)), properties = \(String(describing: p.properties))")
                        self.i += 1
//                        self.appDelegate.alps.addBeacon(beacon: device!)
                        completion()
                    }
                }
    }
}
