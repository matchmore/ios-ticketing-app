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

class MobilePublicationViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var concertTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var rangeTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var publishButton: UIButton!
    // Using appDelegate as a singleton
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var alps : AlpsManager!
    
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alps = self.appDelegate.alps
        centerMapOnLocation(location: initialLocation)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        publishButton.isEnabled = true
    }
    
    @IBAction func publishAction(_ sender: Any) {
    }
    
    // Triggers when publishButton is pressed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        publishButton.isEnabled = false
        // Configure the destination view controller only when the publish button is pressed.
        guard let button = sender as? UIButton, button === publishButton else {
            return
        }
        if let price = Double(priceTextField.text!), let range = Double(rangeTextField.text!), let duration = Double(durationTextField.text!), let image = imageTextField.text, let concert = concertTextField.text {
            createPublication(concert: concert, price: price, image: image, range: range, duration: duration, completion: {
                () in
                print("FINI")
            })
        } else {
            print("Issue with price.")
            print("Issue with duration.")
            print("Issue with range.")
        }
        print("apresfini")
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - AlpsSDK
    func createPublication(concert: String, price: Double, image: String, range: Double, duration: Double, completion: @escaping () -> Void) {
        if self.appDelegate.device != nil {
            // XXX: the property syntax is tricky at the moment: mood is a variable and 'happy' is a string value
            var properties : [String:String] = [:]
            properties["concert"] = concert
            properties["price"] = "\(price)"
            properties["image"] = image
            self.alps.createPublication(topic: "ticketstosale",
                                        range: range, duration: duration,
                                        properties: properties, completion: {(_ publication) in
                                            if let p = publication {
                                                print("Created publication: id = \(String(describing: p.id)), topic = \(String(describing: p.topic)), properties = \(String(describing: p.properties))")
                                                completion()
                                            }
                                            
            })
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
