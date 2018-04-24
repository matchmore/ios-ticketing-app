//
//  AppDelegate.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2017 Matchmore. All rights reserved.
//

import CoreLocation
import Crashlytics
import Fabric
import Matchmore
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.activityType = .fitness
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.allowsBackgroundLocationUpdates = true
        return locationManager
    }()

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        // UI Setup
        setupAppearance()
        AppDelegate.setBadgeIndicator(0)

        // Basic setup
        let config = MatchMoreConfig(apiKey: "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiZWVkYTU3MjctNTVjNy00NDYwLTg0MmUtNTI1ZTc5NDk2ZWVjIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MjIxNTI1NTEsImlhdCI6MTUyMjE1MjU1MSwianRpIjoiMSJ9.iXoO95et3cv3zsBL6yT6z0G76Lsr7iSebASj-DOEsNxwAgr7LHTE3pXULRSSgiMnkVclJB-ipOHVa9B3zLS1Sg", customLocationManager: locationManager) // create your own app at https://www.matchmore.io
        Matchmore.configure(config)

        // Creates or loads cached main device
        Matchmore.startUsingMainDevice { [weak self] in
            self?.startWatchingMatches()
            guard let error = $0.errorMessage else { return }
            self?.window?.rootViewController?.present(AlertHelper.simpleError(title: error), animated: true, completion: nil)
        }

        // Custom Location Manager
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()

        // Registers to APNS (remember to have proper project setup)
        registerForPushNotifications()
        return true
    }

    func startWatchingMatches() {
        Matchmore.refreshMatches()
        Matchmore.startRangingBeacons(updateTimeInterval: 60)
        Matchmore.startPollingMatches(pollingTimeInterval: 500)
        locationManager.requestLocation()
    }

    func applicationWillEnterForeground(_: UIApplication) {
        startWatchingMatches()
    }

    func applicationDidEnterBackground(_: UIApplication) {
        Matchmore.stopPollingMatches()
    }

    // MARK: - APNS

    func application(_: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        // Saves APNS device token using key chain
        print(deviceTokenString)
        Matchmore.registerDeviceToken(deviceToken: deviceTokenString)
    }

    func application(_: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler _: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        Matchmore.processPushNotification(pushNotification: userInfo)
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("APNs registration failed: \(error)")
    }

    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                granted, _ in
                print("Permission granted: \(granted)")
                guard granted else {
                    self.showPermissionAlert()
                    return
                }
                self.getNotificationSettings()
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    @available(iOS 10.0, *)
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func showPermissionAlert() {
        let alert = UIAlertController(title: "Error", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            self.gotoAppSettings()
            alert.dismiss(animated: false, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)

        window?.rootViewController?.show(alert, sender: nil)
    }

    private func gotoAppSettings() {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }

    class func setBadgeIndicator(_ badgeCount: Int) {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = badgeCount
    }
}
