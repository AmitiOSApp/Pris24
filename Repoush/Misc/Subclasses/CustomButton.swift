//
//  CustomButton.swift
//  kluly
//
//  Created by Apple on 18/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

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

        // adjustsFontSizeToFitDevice()
    }

}

@IBDesignable class TIFAttributedButton: UIButton {
    
    @IBInspectable var fontSize: CGFloat = 13.0
    
    @IBInspectable var fontFamily: String = "Montserrat-Regular"
    
    override func awakeFromNib() {
        let attrString = NSMutableAttributedString(attributedString: (self.titleLabel?.attributedText!)!)
        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: self.fontFamily, size: self.fontSize)!, range: NSMakeRange(0, attrString.length))
        self.titleLabel?.attributedText = attrString
    }
}
