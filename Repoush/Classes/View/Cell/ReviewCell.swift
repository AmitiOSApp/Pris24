//
//  ReviewCell.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/2/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var ratingBar: AARatingBar!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configRatingBar() {
        ratingBar.ratingDidChange = { ratingValue in
            print("Rating Is Empty: ", self.ratingBar.isEmpty)
        }
    }

}
