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
        (self.window?.rootViewController as? UITabBarController)?.selectedIndex = 1
        
        UINavigationBar.appearance().barTintColor = UIColor.myOrange
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        UITabBar.appearance().tintColor = UIColor.myOrange
    }
}
