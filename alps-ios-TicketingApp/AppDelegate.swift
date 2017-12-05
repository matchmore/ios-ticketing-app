//
//  AppDelegate.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit

import AlpsSDK
import Alps
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // UI Setup
        setupAppearance()
        
        // Basic setup
        MatchMore.apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiZDY1YjIwYTAtMjAwZS00MzE4LWEyZjAtNTdkZGU1ZDE0YTJiIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTExODI3NzMsImlhdCI6MTUxMTE4Mjc3MywianRpIjoiMSJ9.J7PpSnL80VG5G1QmJlzEpTLBgr0cKu0EwZaQnha07YZU135NlEI6yldUSR95md4o8liqeHyQXUqzgjWFgt-VQg"
        MatchMore.worldId = "d65b20a0-200e-4318-a2f0-57dde5d14a2"
        
        // Registers to APNS (remember to have proper project setup)
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (_, _) in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        // Gets known beacons from API and start ranging
        MatchMore.refreshKnownBeacons {
            MatchMore.startRangingKnownBeacons()
        }
        
        // Creates or loads cached main device
        MatchMore.startUsingMainDevice { result in
            switch result {
            case .success(_):
                // Starts getting and sending device location
                MatchMore.startUpdatingLocation()
                // Opens socket for main device matches delivery
                MatchMore.startListeningForNewMatches()
                MatchMore.startPollingMatches()
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
    
    // MARK: - Appearance
    
    func setupAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent
        (self.window?.rootViewController as? UITabBarController)?.selectedIndex = 1
        
        UINavigationBar.appearance().barTintColor = UIColor.myOrange
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        UITabBar.appearance().tintColor = UIColor.myOrange
    }
}
