//
//  LocalizedTextField.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/13/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class LocalizedTextField: UITextField {
    
    // MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.placeholder = self.placeholder?.localiz()
        
        if UserDefaults.standard.string(forKey: "language_code") == "fa" {
//            if self.textAlignment == .left {
//                self.textAlignment = .right
//            }
        }
        else {
//            if self.textAlignment == .right {
//                self.textAlignment = .left
//            }
        }
    }
    
}
