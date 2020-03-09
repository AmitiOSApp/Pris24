//
//  SettingCell.swift
//  Repoush
//
//  Created by Ravi Sendhav on 2/8/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var imgviewSetting: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var imgviewLanguage: UIImageView!

    var statusHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func switchStatus_Action(_ sender: UISwitch) {
        if statusHandler != nil {
            statusHandler!()
        }
    }
    
}
