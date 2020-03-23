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
    var gender      : String?
    var dob         : String?
    var accountStatus : String?
    var rating      : String?
    var reviewCount : String?

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
        LoggedInUser.shared.latitude        = json[kAPI_PermanentLatitude].string ?? ""
        LoggedInUser.shared.longitude       = json[kAPI_PermanentLognitude].string ?? ""
        LoggedInUser.shared.mobileNo        = json[kAPI_MobileNumber].string ?? ""
        if json[kAPI_Gender].string == "0" {
            LoggedInUser.shared.gender      = ""
        }
        else {
            LoggedInUser.shared.gender      = json[kAPI_Gender].string == "1" ? "Male" : "Female"
        }
        LoggedInUser.shared.dob             = json[kAPI_Dob].string ?? ""
        LoggedInUser.shared.accountStatus   = json[kAPI_AccountStatus].string ?? ""
        LoggedInUser.shared.rating          = json[kAPI_Rating].string ?? ""
        LoggedInUser.shared.reviewCount     = "\(json[kAPI_Review].int ?? 0)"

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
        LoggedInUser.shared.latitude        = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_PermanentLatitude))
        LoggedInUser.shared.longitude       = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_PermanentLognitude))
        LoggedInUser.shared.mobileNo        = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_MobileNumber))
        LoggedInUser.shared.gender          = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_Gender))
        LoggedInUser.shared.dob             = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_Dob))
        LoggedInUser.shared.accountStatus   = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_AccountStatus))
        LoggedInUser.shared.rating          = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_Rating))
        LoggedInUser.shared.reviewCount     = Util.getValidString(UserDefaults.standard.string(forKey: kAPI_Review))
    }
    
    func saveValuesInUserDefaultFromSharedInstance() {
        UserDefaults.standard.set(LoggedInUser.shared.id, forKey: kAPI_Id)
        UserDefaults.standard.set(LoggedInUser.shared.firstName, forKey: kAPI_FirstName)
        UserDefaults.standard.set(LoggedInUser.shared.lastName, forKey: kAPI_LastName)
        UserDefaults.standard.set(LoggedInUser.shared.email, forKey: kAPI_Email)
        UserDefaults.standard.set(LoggedInUser.shared.userImage, forKey: kAPI_UserImage)
        UserDefaults.standard.set(LoggedInUser.shared.address, forKey: kAPI_Address)
        UserDefaults.standard.set(LoggedInUser.shared.latitude, forKey: kAPI_PermanentLatitude)
        UserDefaults.standard.set(LoggedInUser.shared.longitude, forKey: kAPI_PermanentLognitude)
        UserDefaults.standard.set(LoggedInUser.shared.mobileNo, forKey: kAPI_MobileNumber)
        UserDefaults.standard.set(LoggedInUser.shared.gender, forKey: kAPI_Gender)
        UserDefaults.standard.set(LoggedInUser.shared.dob, forKey: kAPI_Dob)
        UserDefaults.standard.set(LoggedInUser.shared.accountStatus, forKey: kAPI_AccountStatus)
        UserDefaults.standard.set(LoggedInUser.shared.rating, forKey: kAPI_Rating)
        UserDefaults.standard.set(LoggedInUser.shared.reviewCount, forKey: kAPI_Review)
    }
    
    func clearUserData() {
        UserDefaults.standard.set(false, forKey: Key_UD_IsUserLoggedIn)
        
        LoggedInUser.shared.isUserLoggedIn   = false
    }
    
}
