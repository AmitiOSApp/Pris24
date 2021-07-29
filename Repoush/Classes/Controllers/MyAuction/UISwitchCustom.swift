//
//  UISwitchCustom.swift
//  MyCar
//
//  Created by mac  on 13/08/19.
//  Copyright © 2019 Rudiment webtech Solutions. All rights reserved.
//

import UIKit
@IBDesignable

class UISwitchCustom: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}
