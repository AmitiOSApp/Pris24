//
//  UserLanguage.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/14/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation

class UserLanguage {
    
    // MARK: - Property
    var languageCode  : String?
    
    // MARK: Shared Instance
    static let shared: UserLanguage = UserLanguage()
    
    fileprivate init() {
        print("Logged sharedUser initialized")
    }
    
}
