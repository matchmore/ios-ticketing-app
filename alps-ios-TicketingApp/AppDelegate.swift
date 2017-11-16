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
        
        // Basic setup
        MatchMore.apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiMjhiMmUyMDktOTQ4NC00NzE2LTg0YjAtMDc1NDJmYjYxOTg2IiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTA4MjAwMTEsImlhdCI6MTUxMDgyMDAxMSwianRpIjoiMSJ9.4MFCfnsal_ODhFepsD4NuoKsXUt0EXX3MhuWJ2UtNrtFNO9nu3SwuKC2bB2cJhH11HrhCimtsvXvWtvtKJbNQA"
        MatchMore.worldId = "28b2e209-9484-4716-84b0-07542fb61986"
        
        // Manual beacon ranging
        MatchMore.startRanging(forUuid: UUID.init(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Beacon region estimote")
        
        // For getting matches update through APNS
        PermissionsHelper.registerForPushNotifications()
        
        MatchMore.startUpdatingLocation()
        
        MatchMore.startPollingMatches()
        
        return true
    }

    // MARK: - APNS
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        MatchMore.registerDeviceToken(deviceToken: deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("APNs registration failed: \(error)")
    }
}
