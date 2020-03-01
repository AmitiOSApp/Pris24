//
//  AllBidCell.swift
//  Repoush
//
//  Created by Ravi's MacBook Pro on 28/02/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class AllBidCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblLastActiveOn: UILabel!
    @IBOutlet weak var btnDistance: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
