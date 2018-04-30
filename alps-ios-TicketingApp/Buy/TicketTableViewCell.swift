//
//  TicketTableViewCell.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 05.09.17.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {

    // MARK: Properties

    @IBOutlet var concertLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var deviceTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.image = iconImageView.image!.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = UIColor(red: 0.87, green: 0.53, blue: 0.35, alpha: 1.00)
    }
}
