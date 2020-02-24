//
//  LoggedInUser.swift
//  Moodery
//
//  Created by Ravi Sendhav on 1/1/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation

class LoggedInUser {
    
    // MARK: - Property
    var id          : String?
    var firstName   : String?
    var lastName    : String?
    var email       : String?
    var address     : String?
    var userImage   : String?
    var latitude    : String?
    var longitude   : String?
    var mobileNo    : String?

    var isUserLoggedIn  :Bool = false
    
    // MARK: Shared Instance
    static let shared: LoggedInUser = LoggedInUser()
    
    fileprivate init() {
        print("Logged sharedUser initialized")
    }
    
    // MARK: - Public Methods
    public func initLoggedInUserFromResponse(_ response: AnyObject) {
        
        //** Json Parsing using SwiftyJSON library
        let json = JSON(response)
        
        LoggedInUser.shared.id              = json[kAPI_Id].string ?? ""
        LoggedInUser.shared.firstName       = json[kAPI_FirstName].string ?? ""
        LoggedInUser.shared.lastName        = json[kAPI_LastName].string ?? ""
        LoggedInUser.shared.email           = json[kAPI_Email].string ?? ""
        LoggedInUser.shared.userImage       = json[kAPI_UserImage].string ?? ""
        LoggedInUser.shared.address         = json[kAPI_Address].string ?? ""
        LoggedInUser.shared.latitude        = json[kAPI_Latitude].string ?? ""
        LoggedInUser.shared.longitude       = json[kAPI_Longitude].string ?? ""
        LoggedInUser.shared.mobileNo        = json[kAPI_MobileNumber].string ?? ""

        LoggedInUser.shared.isUserLoggedIn  = true
        UserDefaults.standard.set(true, forKey: Key_UD_IsUserLoggedIn)
        
        saveValuesInUserDefaultFromSharedInstance()
    }
    
    func initializeFromUserDefault() {
        LoggedInUser.shared.isUserLoggedIn  = true
        
        LoggedInUser.shared.id              = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_Id))
        LoggedInUser.shared.firstName       = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_FirstName))
        LoggedInUser.shared.lastName        = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_LastName))
        LoggedInUser.shared.email           = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_Email))
        LoggedInUser.shared.userImage       = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_UserImage))
        LoggedInUser.shared.address         = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_Address))
        LoggedInUser.shared.latitude        = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_Latitude))
        LoggedInUser.shared.longitude       = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_Longitude))
        LoggedInUser.shared.mobileNo        = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_MobileNumber))
    }
    
    func saveValuesInUserDefaultFromSharedInstance() {
        UserDefaults.standard.set(LoggedInUser.shared.id, forKey: kAPI_Id)
        UserDefaults.standard.set(LoggedInUser.shared.firstName, forKey: kAPI_FirstName)
        UserDefaults.standard.set(LoggedInUser.shared.lastName, forKey: kAPI_LastName)
        UserDefaults.standard.set(LoggedInUser.shared.email, forKey: kAPI_Email)
        UserDefaults.standard.set(LoggedInUser.shared.userImage, forKey: kAPI_UserImage)
        UserDefaults.standard.set(LoggedInUser.shared.address, forKey: kAPI_Address)
        UserDefaults.standard.set(LoggedInUser.shared.latitude, forKey: kAPI_Latitude)
        UserDefaults.standard.set(LoggedInUser.shared.longitude, forKey: kAPI_Longitude)
        UserDefaults.standard.set(LoggedInUser.shared.mobileNo, forKey: kAPI_MobileNumber)
    }
    
    func clearUserData() {
        UserDefaults.standard.set(false, forKey: Key_UD_IsUserLoggedIn)
        
        LoggedInUser.shared.isUserLoggedIn   = false
    }
    
}
