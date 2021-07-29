//
//  MyDefaults.swift
//  SwiftDefaults
//
//  Created by 杉本裕樹 on 2016/01/12.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import SwiftDefaults
class MyDefaults: SwiftDefaults {
    @objc dynamic var value: String? = "10"
    @objc dynamic var isLogin:Bool=false
    @objc dynamic var isUserlogin:Bool=false
    @objc dynamic var isClickOnHome:Bool=false
    @objc dynamic var UserId: String!
    @objc dynamic var language: String?
    @objc dynamic var selectlanguage: String!
    @objc dynamic var UserEmail: String!
    @objc dynamic var UserPassword: String!
    @objc dynamic var notificationStatus: String!
    @objc dynamic var userNotificationStatus: String!
    @objc dynamic var myDefaultAddress: String? = ""
    
    @objc dynamic var certificatestype: String = "development"
    @objc dynamic var deviceType: String  = "ios"
    @objc dynamic var deviceToken: String = "jklflksdjlkfdljfkjfkdsjfklsf"
    @objc dynamic var userType: String!
    @objc dynamic var mobileNumber: String!
    @objc dynamic var userLoginData = [String:Any]()
    
  //   @objc dynamic var meetingData = [ModelMeetingDatum]()
 
}

class Utility: NSObject {
    
    // MARK: - keyConstent
    struct keyConstent {
        static let saveFilter = "saveFilter"
        static let filterKm = "kilometer"
        
    }
    
    // MARK: - Get language Array
    class func getFilterArray() -> [[String: Any]]{
        return UserDefaults.standard.object(forKey: keyConstent.saveFilter) as? [[String: Any]] ?? [[String: Any]]()
    }
    
    // MARK: - Set language Array
    class func setFilterArray(data:[[String: Any]]){
        UserDefaults.standard.set(data, forKey: keyConstent.saveFilter)
        UserDefaults.standard.synchronize()
    }
    class func getFilterKilometer() -> [String: Any]{
        return UserDefaults.standard.object(forKey: keyConstent.filterKm) as? [String : Any] ?? [String : Any]()
    }
    class func setFilterkilometer(data:[String: Any]){
        UserDefaults.standard.set(data, forKey: keyConstent.filterKm)
        UserDefaults.standard.synchronize()
    }
    class func isClickOnHome() -> Bool {
        return false
    }
    
}
