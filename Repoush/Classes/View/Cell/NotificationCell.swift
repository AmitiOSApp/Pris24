//
//  NotificationCell.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/1/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lblNotificationStatus: UILabel!
    @IBOutlet weak var lblNotificationMsg: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
