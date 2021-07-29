//
//  Constant.swift
//  Kluly
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

func DLog(message: String, function: String = #function) {
    #if DEBUG
        print("\(function): \(message)")
    #endif
}

//************************** Notification name constant **************************//
extension Notification.Name {
    static let fetchNewsDataPerHour = Notification.Name("fetchNewsDataPerHour")
    static let updateNotificationListData = Notification.Name("updateNotificationListData")
    static let updateUserListData = Notification.Name("updateUserListData")
    static let updateCommentListData = Notification.Name("updateCommentListData")
    static let updateFriendFeedData = Notification.Name("updateFriendFeedData")
    static let updateLikeCommentCount = Notification.Name("updateLikeCommentCount")
}

//************************** Screen size and Device type macros **************************//
struct ScreenSize {
    static let width         = UIScreen.main.bounds.size.width
    static let height        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.width, ScreenSize.height)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.width, ScreenSize.height)
    
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
}

//************************** Constants for Device type **************************//
struct Device {
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XR         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

//************************** Constants for iOS version **************************//
struct iOSVersion {
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS9  = (iOSVersion.SYS_VERSION_FLOAT >= 9.0 && iOSVersion.SYS_VERSION_FLOAT < 10.0)
    static let iOS10 = (iOSVersion.SYS_VERSION_FLOAT >= 10.0 && iOSVersion.SYS_VERSION_FLOAT < 11.0)
    static let iOS11 = (iOSVersion.SYS_VERSION_FLOAT >= 11.0 && iOSVersion.SYS_VERSION_FLOAT < 12.0)
    static let iOS12 = (iOSVersion.SYS_VERSION_FLOAT >= 12.0 && iOSVersion.SYS_VERSION_FLOAT < 13.0)
}

//************************** Constants for color **************************//
let colorYellow         = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)
let colorPurple         = UIColor(red: 101/255, green: 41/255, blue: 118/255, alpha: 1.0)
let colorBlue           = UIColor(red: 2/255, green: 138/255, blue: 196/255, alpha: 1.0)
let colorPlaceHolder    = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1.0)
let colorViewBG         = UIColor(red: 237/255, green: 238/255, blue: 238/255, alpha: 1.0)
let colorFaqBg          = UIColor(red: 242/255, green: 181/255, blue: 52/255, alpha: 1.0)
let colorRed            = UIColor(red: 195/255, green: 60/255, blue: 24/255, alpha: 1.0)
let colorGroupBG        = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
let colorDarkGray       = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
let colorAppTheme       = UIColor(red: 246/255, green: 114/255, blue: 128/255, alpha: 1.0)
let colorLight          = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)
let colorGreen          = UIColor(red: 0/255, green: 178/255, blue: 89/255, alpha: 1.0)
//let colorHeader          = UIColor(red: 2/255, green: 187/255, blue: 202/255, alpha: 1.0)
let colorHeader          = "02BBCA"


//let colorRed         = "#F67280"
//let colorGreen         = "#00B259"
//let colorGray         = "#AAAAAA"
//let colorDarkGray         = "#858585"
//let colorDarkGrayBold         = "#6C6C6C"
//let colorLightBlue         = "#DDF7FF"
//let colorYelow         = "#FFc61A"
//let colorLightWhite         = "#f1f1f1"
//let colorBlueLightGray         = "#E4E4E4"
//let colorForgotPassword         = "#355C7D"
//let colorDarkBlue         = "#003E4F"
//let colorLightGreen         = "#E4E4E4"
//let colorLightRed         = "#E4E4E4"
//let colorBidButton         = "#cc0033"
//let colorTopHeader         = "#02bbca"
//
//let colorOffLine = "cc0033"
//let colorOriginalPrice = "828282"
//let colorDiscount = "00d936"


//let colorYellow         = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)
//let colorPurple         = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)
//let colorBlue           = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)
//let colorPlaceHolder    = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)
//let colorViewBG         = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)
//let colorFaqBg          = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)
//let colorRed            = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)
//let colorGroupBG        = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)
//let colorDarkGray       = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)
//let colorAppTheme       = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)
//let colorLight          = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)
//let colorGreen          = UIColor(red: 238/255, green: 124/255, blue: 28/255, alpha: 1.0)


let textColor = "313D4F"

let colorClear          = UIColor.clear
let colorWhite          = UIColor.white
let colorBlack          = UIColor.black
let colorLightGray      = UIColor.lightGray

//************************** Constants for Font **************************//
let AppFontRegular   = "Montserrat-Regular"
let AppFontMedium    = "Montserrat-Medium"
let AppFontBold      = "Montserrat-Bold"
let AppFontLight     = "Montserrat-Light"
let AppFontSemiBold  = "Montserrat-SemiBold"

//************************** Constants for User default **************************//
let Key_UD_IsUserLoggedIn           = "isUserLoggedIn"
let Key_UD_IsLogoutAPIPending       = "isLogoutAPIPending"

//************************** Constants for Alert messages **************************//
let msgSorry                         = "Sorry something went wrong."
let msgTimeOut                       = "Request timed out."
let msgCheckConnection               = "Please check your connection and try again."
let msgConnectionLost                = "Network connection lost."
let Key_Alert                        = "Alert"
let Key_Message                      = "message"
let Key_ResponseCode                 = "responseCode"
let Key_ResponseMessage              = "responseMessage"

let ALERTMESSAGE = "Pris24"
let serverNotFound =  "Oops ! - server not responding, please try after some time."
//let loaderText =  "Loading...."

//************************** Constants for APNS **************************//
let Key_APNS                         = "aps"
let Key_APNSAlert                    = "alert"
let Key_APNSBadge                    = "badge"
let Key_APNSAction                   = "action"
let Key_APNSMetadata                 = "Metadata"
let Key_APNSType                     = "type"

//************************** Other Constants **************************//
let TWITTER_CONSUMRE_KEY        = "NRAz19xajgSpu0c0ooNWDnNiP"
let TWITTER_CONSUMRE_SECRET     = "uiqN0OdQglc6k4MOdNfLGL7n3HssmOttTrdXQe0Z239dcxQcoH"

//************************** The order of pragma marks methods in every class **************************//

// MARK: - Properties
// MARK: - Initialization
// MARK: - Lifecycle Methods
// MARK: - Notification Methods (Observer Listener methods)
// MARK: - Action Methods
// MARK: - Private Methods
// MARK: - Public Methods
// MARK: - API Methods
// MARK: - Protocol conformance
// MARK: - UITextFieldDelegate
// MARK: - UITextViewDelegate
// MARK: - UITableViewDataSource
// MARK: - UITableViewDelegate
