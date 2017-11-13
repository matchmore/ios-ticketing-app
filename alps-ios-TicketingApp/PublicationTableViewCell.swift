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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
