//
//  MobilePublicationViewController.swift
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

class MobilePublicationViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    @IBOutlet weak var concertTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var rangeTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var publishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: all these can be setup from storyboard
        self.concertTextField.delegate = self
        self.priceTextField.delegate = self
        self.imageTextField.delegate = self
        self.durationTextField.delegate = self
        self.rangeTextField.delegate = self
        self.priceTextField.keyboardType = .numbersAndPunctuation
        self.durationTextField.keyboardType = .numbersAndPunctuation
        self.rangeTextField.keyboardType = .numbersAndPunctuation
    }

    override func viewDidAppear(_ animated: Bool) {
        if let location = MatchMore.lastLocation?.clLocation {
            centerMapOnLocation(location: location)
        }
        publishButton.isEnabled = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
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
            let concert = concertTextField.text {
            var properties: [String: String] = [:]
            properties["concert"] = concert
            properties["price"] = "\(price)"
            properties["image"] = image
            properties["deviceType"] = "mobile"
            let publication = Publication(
                topic: "ticketstosale",
                range: range,
                duration: duration,
                properties: properties
            )
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            MatchMore.createPublication(publication: publication) { (result) in
                switch result {
                case .success(_):
                    PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                    PKHUD.sharedHUD.hide()
                    self.navigationController?.popToRootViewController(animated: true)
                    self.publishButton.isEnabled = true
                case .failure(let error):
                    PKHUD.sharedHUD.contentView = PKHUDErrorView()
                    PKHUD.sharedHUD.hide()
                    self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
                }
            }
        } else {
            self.present(AlertHelper.simpleError(title: "Please fill all needed fields."), animated: true, completion: nil)
            publishButton.isEnabled = true
        }
    }
    
    // Triggers when publishButton is pressed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        publishButton.isEnabled = false
        // Configure the destination view controller only when the publish button is pressed.
        guard let button = sender as? UIButton, button === publishButton else {
            return
        }
    }

    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
