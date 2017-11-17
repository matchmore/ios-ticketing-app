//
//  AlertHelper.swift
//  alps-ios-TicketingApp
//
//  Created by Maciej Burda on 16/11/2017.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit

final class AlertHelper {
    class func simpleError(title: String?) -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: title ?? "Something went wrong", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertController
    }
}
