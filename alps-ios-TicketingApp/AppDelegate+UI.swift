//
//  AppDelegate+UI.swift
//  alps-ios-TicketingApp
//
//  Created by Maciej Burda on 07/12/2017.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import UIKit

extension AppDelegate {
    func setupAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent
        if let tabBarController = self.window?.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 0
        }
        
        UINavigationBar.appearance().barTintColor = UIColor.myOrange
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        UITabBar.appearance().tintColor = UIColor.myOrange
    }
}
