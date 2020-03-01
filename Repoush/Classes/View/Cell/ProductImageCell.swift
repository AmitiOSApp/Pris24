//
//  ProductImageCell.swift
//  Repoush
//
//  Created by Ravi Sendhav on 2/26/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class ProductImageCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgviewProduct: UIImageView!
    @IBOutlet weak var btnCross: UIButton!

    var crossHandler: (() -> Void)?

    // MARK: Action Methods
    @IBAction func btnCross_Action(_ sender: UIButton) {
        if (crossHandler != nil) {
            crossHandler!()
        }
    }

}
