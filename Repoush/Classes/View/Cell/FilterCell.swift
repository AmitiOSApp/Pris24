//
//  FilterCell.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/4/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblDistanceRange: UILabel!
    @IBOutlet weak var viewSelect: UIView!
    @IBOutlet weak var viewDevider: UIView!

    var selectRangeHandler: (() -> Void)?

    // MARK: Action Methods
    @IBAction func btnSelectRange_Action(_ sender: UIButton) {
        if selectRangeHandler != nil {
            selectRangeHandler!()
        }
    }
    
}
