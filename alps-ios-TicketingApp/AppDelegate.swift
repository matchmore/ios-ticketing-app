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
        MatchMore.apiKey = "YOUR_API_KEY"
        MatchMore.worldId = "YOUR_WORLD_ID"
        
        // Registers to APNS (remember to have proper project setup)
        UIApplication.shared.registerForRemoteNotifications()
        
        // Creates or loads cached main device
        MatchMore.startUsingMainDevice { result in
            switch result {
            case .success(_):
                // Starts getting and sending device location
                MatchMore.startUpdatingLocation()
                // Polls matches every 5 seconds (other available options: APNS, WebSocket)
                MatchMore.startPollingMatches()
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
