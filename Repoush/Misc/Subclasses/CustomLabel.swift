//
//  CustomLabel.swift
//  kluly
//
//  Created by Apple on 17/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    // MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        adjustsFontSizeToFitDevice()
    }

}

@IBDesignable class TIFAttributedLabel: UILabel {
    
    @IBInspectable var fontSize: CGFloat = 13.0
    
    @IBInspectable var fontFamily: String = "Montserrat-Regular"
    
    override func awakeFromNib() {
        let attrString = NSMutableAttributedString(attributedString: self.attributedText!)
        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: self.fontFamily, size: self.fontSize)!, range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}
