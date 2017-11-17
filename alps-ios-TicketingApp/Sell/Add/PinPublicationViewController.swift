//
//  PinPublicationViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import MapKit
import AlpsSDK
import Alps
import PKHUD

class PinPublicationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var concertTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longtitudeTextField: UITextField!
    @IBOutlet weak var rangeTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    var deviceNo = 1
    // Using appDelegate as a singleton
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var alps: AlpsManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.concertTextField.delegate = self
        self.priceTextField.delegate = self
        self.imageTextField.delegate = self
        self.durationTextField.delegate = self
        self.latitudeTextField.delegate = self
        self.longtitudeTextField.delegate = self
        self.rangeTextField.delegate = self
        self.priceTextField.keyboardType = .numbersAndPunctuation
        self.durationTextField.keyboardType = .numbersAndPunctuation
        self.rangeTextField.keyboardType = .numbersAndPunctuation
        self.latitudeTextField.keyboardType = .numbersAndPunctuation
        self.longtitudeTextField.keyboardType = .numbersAndPunctuation
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let location = MatchMore.lastLocation?.clLocation {
            centerMapOnLocation(location: location)
        }
        publishButton.isEnabled = true
        if let loc = MatchMore.lastLocation {
            guard let lat = loc.latitude else {return}
            guard let long = loc.longitude else {return}
            latitudeTextField.text = String(describing: lat)
            longtitudeTextField.text = String(describing: long)
        }
    }
    
    @IBAction func tapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func publishAction(_ sender: Any) {
        publishButton.isEnabled = false
        if let price = Double(priceTextField.text!),
            let range = Double(rangeTextField.text!),
            let duration = Double(durationTextField.text!),
            let image = imageTextField.text,
            let concert = concertTextField.text,
            let longitude = Double(longtitudeTextField.text!),
            let latitude = Double(latitudeTextField.text!) {
            createPublication(concert: concert, price: price, image: image, latitude: latitude, longitude: longitude, range: range, duration: duration, completion: {
                self.navigationController?.popToRootViewController(animated: true)
                self.publishButton.isEnabled = true
            })
        } else {
            self.present(AlertHelper.simpleError(title: "Please fill all needed fields."), animated: true, completion: nil)
            self.publishButton.isEnabled = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    // MARK: - AlpsSDK
    
    func createPublication(concert: String, price: Double, image: String, latitude: Double, longitude: Double, range: Double, duration: Double, completion: @escaping () -> Void) {
        let location = Location(latitude: latitude, longitude: longitude, altitude: 0.0, horizontalAccuracy: 0.0, verticalAccuracy: 0.0)
        let pin = PinDevice(name: "pin device \(deviceNo)", location: location)
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        MatchMore.createPinDevice(device: pin) { (result) in
            switch result {
            case .success(let device):
                var properties: [String: String] = [:]
                properties["concert"] = concert
                properties["price"] = "\(price)"
                properties["image"] = image
                properties["deviceType"] = "pin"
                if let deviceId = device.id {
                    let pub = Publication(deviceId: deviceId, topic: "ticketstosale", range: range, duration: duration, properties: properties)
                    MatchMore.createPublication(publication: pub, for: deviceId) { (result) in
                        switch result {
                        case .success(_):
                            PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                            PKHUD.sharedHUD.hide()
                            self.deviceNo += 1
                            completion()
                        case .failure(let error):
                            PKHUD.sharedHUD.contentView = PKHUDErrorView()
                            PKHUD.sharedHUD.show()
                            self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                PKHUD.sharedHUD.contentView = PKHUDErrorView()
                PKHUD.sharedHUD.show()
                self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
        }
    }

}
