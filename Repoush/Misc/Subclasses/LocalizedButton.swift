//
//  LocalizedButton.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/14/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class LocalizedButton: UIButton {

    // MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UserDefaults.standard.string(forKey: "language_code") == "fa" {

            let leftInsetTitle = self.titleEdgeInsets.left
            let rightInsetTitle = self.titleEdgeInsets.right
            let leftInsetImage = self.imageEdgeInsets.left
            let rightInsetImage = self.imageEdgeInsets.right
            
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: rightInsetTitle, bottom: 0, right: leftInsetTitle)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: rightInsetImage, bottom: 0, right: leftInsetImage)
        }
    }

}
