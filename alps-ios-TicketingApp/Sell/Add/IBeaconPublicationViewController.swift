//
//  IBeaconPublicationViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import Matchmore
import PKHUD
import UIKit

class IBeaconPublicationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var concertTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var imageTextField: UITextField!
    @IBOutlet var durationTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var publishButton: UIButton!

    var pickerData: [IBeaconTriple] = []
    var selectedValue: IBeaconTriple?

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self
        concertTextField.delegate = self
        priceTextField.delegate = self
        imageTextField.delegate = self
        durationTextField.delegate = self
        priceTextField.keyboardType = .numbersAndPunctuation
        durationTextField.keyboardType = .numbersAndPunctuation
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Matchmore.knownBeacons.findAll(completion: { beacons in
            self.pickerData = beacons
            self.picker.reloadAllComponents()
            self.picker.isHidden = beacons.isEmpty
            if self.picker.isHidden == false {
                self.picker.selectRow(0, inComponent: 0, animated: true)
                self.selectedValue = self.pickerData[0]
            }
        })
        publishButton.isEnabled = true
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    // MARK: - Picker Data Source / Delegate

    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return pickerData[row].proximityUUID
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        selectedValue = pickerData[row]
    }

    // MARK: - Actions

    @IBAction func tapped(_: Any) {
        view.endEditing(true)
    }

    @IBAction func publishAction(_: Any) {
        if picker.isHidden {
            let alert = UIAlertController(title: "No iBeacons", message: "Please add a few beacons to your world first.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        publishButton.isEnabled = false
        if let price = Double(priceTextField.text!),
            let image = imageTextField.text,
            let concert = concertTextField.text,
            let duration = Double(durationTextField.text!),
            let beacon = self.selectedValue,
            let phoneNumber = phoneTextField.text {
            createPublication(concert: concert, price: price, image: image, duration: duration, beacon: beacon, phoneNumber: phoneNumber, completion: {
                self.navigationController?.popToRootViewController(animated: true)
                self.publishButton.isEnabled = true
            })
        } else {
            present(AlertHelper.simpleError(title: "Please provide all fields."), animated: true, completion: nil)
            publishButton.isEnabled = true
        }
    }

    func createPublication(concert: String, price: Double, image: String, duration: Double, beacon: IBeaconTriple, phoneNumber: String, completion: @escaping () -> Void) {
        NSLog("IBeacon DEVICE Created")
        // XXX: the property syntax is tricky at the moment: mood is a variable and 'happy' is a string value
        var properties: [String: Any] = [:]
        properties["concert"] = concert
        properties["price"] = price
        properties["image"] = image
        properties["phone"] = phoneNumber
        properties["deviceType"] = "iBeacon"
        let pub = Publication(topic: "ticketstosale", range: 0, duration: duration, properties: properties)
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        Matchmore.createPublication(publication: pub, forBeacon: beacon) { result in
            switch result {
            case .success:
                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                PKHUD.sharedHUD.hide()
                completion()
            case let .failure(error):
                PKHUD.sharedHUD.contentView = PKHUDErrorView()
                PKHUD.sharedHUD.hide()
                NSLog(error.debugDescription)
            }
        }
    }
}
