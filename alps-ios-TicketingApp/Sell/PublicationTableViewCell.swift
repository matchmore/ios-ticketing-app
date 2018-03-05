//
//  PublicationTableViewCell.swift
//  alps-ios-TicketingApp
//
//  Created by Wen on 07.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit

class PublicationTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var concertLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var deviceTypeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.image = iconImageView.image!.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = UIColor(red:0.87, green:0.53, blue:0.35, alpha:1.00)
    }
}
