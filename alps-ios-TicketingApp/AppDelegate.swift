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
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // MARK: TO DO
    let APIKEY = "ea0df90a-db0a-11e5-bd35-3bd106df139b" // <- Please provide a valid Matchmore Application Api-key, obtain it for free on dev.matchmore.io, see the README.md file for more informations
    
    // MARK: Properties
    // AlpsManager is the SDK core class that will communicate with the API Alps, which will then communicate with Matchmore services
    var alps: AlpsManager!
    // In short, it will manage all the related calls with the device location. To learn more about CLLocationManager please refers to CoreLocation Documentation
    var locationManager = CLLocationManager()
    // UUID identifier given by Matchmore to identify users
    var username : String?
    var userId : String?
    // UUID identifier given by Matchmore to identify devices
    var deviceId : String?
    var device : MobileDevice?
    var publications : [Publication] = []
    
    // MARK: UI Interface
    let orange = UIColor(red:0.93, green:0.51, blue:0.31, alpha:1.0)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if APIKEY.isEmpty {
            fatalError("To run this project, please provide a valid Matchmore Application Api-key. Obtain it for free on dev.matchmore.io, see the README.md file for more informations")
        }else{
            alps = AlpsManager(apiKey: APIKEY, clLocationManager : locationManager)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

