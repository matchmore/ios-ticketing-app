//
//  FindTableViewCell.swift
//  alps-ios-TicketingApp
//
//  Created by Maciej Burda on 07/12/2017.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import TagListView

class FindTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var tagsView: TagListView!


    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.image = iconImageView.image!.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = UIColor(red:0.87, green:0.53, blue:0.35, alpha:1.00)
    }
}
