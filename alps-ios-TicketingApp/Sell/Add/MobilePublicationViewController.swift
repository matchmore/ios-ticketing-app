//
//  MobilePublicationViewController.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import MapKit
import Matchmore
import PKHUD
import UIKit

class MobilePublicationViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    @IBOutlet var concertTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var imageTextField: UITextField!
    @IBOutlet var rangeTextField: UITextField!
    @IBOutlet var durationTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var publishButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: all these can be setup from storyboard
        concertTextField.delegate = self
        priceTextField.delegate = self
        imageTextField.delegate = self
        durationTextField.delegate = self
        rangeTextField.delegate = self
        priceTextField.keyboardType = .numbersAndPunctuation
        durationTextField.keyboardType = .numbersAndPunctuation
        rangeTextField.keyboardType = .numbersAndPunctuation
    }

    override func viewDidAppear(_: Bool) {
        if let location = Matchmore.lastLocation?.clLocation {
            centerMapOnLocation(location: location)
        }
        publishButton.isEnabled = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    @IBAction func tapped(_: Any) {
        view.endEditing(true)
    }

    @IBAction func publishAction(_: Any) {
        publishButton.isEnabled = false
        if let price = Double(priceTextField.text!),
            let range = Double(rangeTextField.text!),
            let duration = Double(durationTextField.text!),
            let image = imageTextField.text,
            let concert = concertTextField.text,
            let phoneNumber = phoneTextField.text {
            var properties: [String: Any] = [:]
            properties["concert"] = concert
            properties["price"] = price
            properties["image"] = image
            properties["phone"] = phoneNumber
            properties["deviceType"] = "mobile"
            let publication = Publication(
                topic: "ticketstosale",
                range: range,
                duration: duration,
                properties: properties
            )
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            Matchmore.createPublicationForMainDevice(publication: publication) { result in
                switch result {
                case .success:
                    PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                    PKHUD.sharedHUD.hide()
                    self.navigationController?.popToRootViewController(animated: true)
                    self.publishButton.isEnabled = true
                case let .failure(error):
                    PKHUD.sharedHUD.contentView = PKHUDErrorView()
                    PKHUD.sharedHUD.hide()
                    self.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
                }
            }
        } else {
            present(AlertHelper.simpleError(title: "Please fill all needed fields."), animated: true, completion: nil)
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
