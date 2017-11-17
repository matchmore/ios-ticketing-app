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
import PKHUD

class IBeaconPublicationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var concertTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var publishButton: UIButton!
    
    var pickerData: [IBeaconTriple] = []
    var selectedValue: IBeaconTriple?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        self.concertTextField.delegate = self
        self.priceTextField.delegate = self
        self.imageTextField.delegate = self
        self.durationTextField.delegate = self
        self.priceTextField.keyboardType = .numbersAndPunctuation
        self.durationTextField.keyboardType = .numbersAndPunctuation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MatchMore.refreshKnownBeacons { beacons in
            self.pickerData = beacons ?? []
            self.picker.reloadAllComponents()
        }

        if !pickerData.isEmpty {
            self.selectedValue = pickerData[0]
        }
        publishButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Picker Data Source / Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].deviceId
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedValue = pickerData[row]
    }
    
    // MARK: - Actions
    
    @IBAction func publishAction(_ sender: Any) {
        publishButton.isEnabled = false
        if let price = Double(priceTextField.text!),
            let image = imageTextField.text,
            let concert = concertTextField.text,
            let duration = Double(durationTextField.text!),
            let deviceId = self.selectedValue?.deviceId {
            createPublication(concert: concert, price: price, image: image, duration: duration, deviceId: deviceId, completion: {
                self.navigationController?.popToRootViewController(animated: true)
                self.publishButton.isEnabled = true
            })
        } else {
            self.present(AlertHelper.simpleError(title: "Please provide all fields."), animated: true, completion: nil)
            publishButton.isEnabled = true
        }
    }

    func createPublication(concert: String, price: Double, image: String, duration: Double, deviceId : String, completion: @escaping () -> Void) {
            NSLog("IBeacon DEVICE Created")
            // XXX: the property syntax is tricky at the moment: mood is a variable and 'happy' is a string value
            var properties: [String: String] = [:]
            properties["concert"] = concert
            properties["price"] = "\(price)"
            properties["image"] = image
            properties["deviceType"] = "iBeacon"
        let pub = Publication(topic: "ticketstosale", range: 0, duration: duration, properties: properties)
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        MatchMore.createPublication(publication: pub) { (result) in
            switch result {
            case .success(_):
                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                PKHUD.sharedHUD.show()
                completion()
            case .failure(let error):
                PKHUD.sharedHUD.contentView = PKHUDErrorView()
                PKHUD.sharedHUD.show()
                NSLog(error.debugDescription)
            }
        }
    }
}
