//
//  AppDelegate.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2017 Matchmore. All rights reserved.
//

import UIKit

import AlpsSDK
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // UI Setup
        setupAppearance()
        
        // Custom Location Manager
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        // Basic setup
        let config = MatchMoreConfig(apiKey: "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiMTc3NjdhN2UtNzU0OC00ZTk5LWEwMGMtYTFkYTM2NmIwNGFmIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MjA0MjQyMDQsImlhdCI6MTUyMDQyNDIwNCwianRpIjoiMSJ9.ayQMcG6jPmVX4eVfqRwcdrwAAOblZPXHVV8WuZSG7m8dWCr65lgvwnIxwqOBg3Oco2aUiKuNaBWllmfpKawaug", customLocationManager: locationManager) // create your own app at https://www.matchmore.io
        MatchMore.configure(config)
        
        // Registers to APNS (remember to have proper project setup)
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (_, _) in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        // Gets known beacons from API and start ranging
        MatchMore.refreshKnownBeacons()
        
        // Creates or loads cached main device
        MatchMore.startUsingMainDevice { result in
            switch result {
            case .success(_):
                // Starts getting and sending device location
                MatchMore.startUpdatingLocation()
                // Opens socket for main device matches delivery
                MatchMore.startListeningForNewMatches()
                // Starts polling matches every 5 seconds
                MatchMore.startPollingMatches(pollingTimeInterval: 5)
            case .failure(let error):
                self.window?.rootViewController?.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
        }
        
        return true
    }

    // MARK: - APNS
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        // Saves APNS device token using key chain
        MatchMore.registerDeviceToken(deviceToken: deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("APNs registration failed: \(error)")
    }
}
