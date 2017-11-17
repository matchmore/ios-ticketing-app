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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // UI Setup
        setupAppearance()
        
        // Basic setup
        MatchMore.apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiYjk3MDFjNzQtMzkyMi00MjY1LTg2Y2ItNzQ0MTE4YWI4NWU0IiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTA4NDY5NTgsImlhdCI6MTUxMDg0Njk1OCwianRpIjoiMSJ9.IDnqpc3Oco3QthoCwf-sYx_3zXFaJ_h9nFzNi5hAHzUSkVlCOHavxdBzQYeBnak744O4nr7dZHr1hb_P3YzoPQ"
        MatchMore.worldId = "b9701c74-3922-4265-86cb-744118ab85e4"
        
        // Registers to APNS (remember to have proper project setup)
        PermissionsHelper.registerForPushNotifications()
        
        // Creates or loads cached main device
        MatchMore.startUsingMainDevice { result in
            switch result {
            case .success(_):
                // Starts getting and sending device location
                MatchMore.startUpdatingLocation()
                
                // Manual beacon ranging
                MatchMore.startRanging(forUuid: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Beacon region estimote")
                
                // Polls matches every 5 seconds (other available options: APNS, WebSocket)
                // MatchMore.startPollingMatches()
                
                // Opens socket for main device matches delivery
                MatchMore.startListeningForNewMatches()
            case .failure(let error):
                self.window?.rootViewController?.present(AlertHelper.simpleError(title: error?.message), animated: true, completion: nil)
            }
        }
        
        return true
    }

    // MARK: - APNS
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        // Remembers APNS device token
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
        UITabBar.appearance().tintColor = UIColor.myOrange
    }
}
