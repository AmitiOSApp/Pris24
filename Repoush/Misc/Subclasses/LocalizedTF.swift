//
//  LocalizedTF.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/15/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class LocalizedTF: UITextField {

    // MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.placeholder = self.placeholder?.localiz()
        
        if UserDefaults.standard.string(forKey: "language_code") == "fa" {
            self.textAlignment = .left
        }
        else {
            self.textAlignment = .right
        }
    }

}
