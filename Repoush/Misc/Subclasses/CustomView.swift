//
//  CustomView.swift
//  MiniMall
//
//  Created by Apple on 21/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    // MARK: - Life Cycle Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.height / 2.0
        
        self.layer.cornerRadius = radius
    }

}
