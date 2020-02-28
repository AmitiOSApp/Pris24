
import UIKit

//** Base url of web service
//TODO: Build Changes
//For Live
//let kAPI_BaseURL                       = "http://18.222.1.10/project_klu/index.php/"

//For Development
let kAPI_BaseURL                        = "http://24x7webtesting.com/repoush/service/"
let kAPI_ImageBaseURL                   = "http://24x7webtesting.com/moodery/post/"

//************************** Constant for API Keys **************************//

//** Common Api Constant
let kAPI_Data                           = "data"
let kAPI_ResponseMessage                = "message"
let kAPI_Items                          = "items"
let kAPI_ServerDateFormat               = "yyyy-MM-dd HH:mm:ss.SSS"
let kAPI_AppDateFormat                  = "yyyy-MM-dd HH:mm:ss.SSS"
let kAPI_Success                        = "success"
let kAPI_Error                          = "error"
let kAPI_MessageAlert                   = "Message"
let kAPI_Message                        = "message"
let kAPI_Alert                          = "Moodery"
let kAPI_Id                             = "id"
let kAPI_UserType                       = "user_type"
let kAPI_DeviceToken                    = "device_token"
let kAPI_DeviceType                     = "device_type"
let kAPI_CertificateType                = "certificate_type"
let kAPI_LoginType                      = "login_type"
let kAPI_Latitude                       = "latitude"
let kAPI_Longitude                      = "lognitude"
let kAPI_Address                        = "address"

let kAPI_ServerNotificationDateFormat   = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
let kAPI_24HourTimeFormat               = "HH:mm:ss"
let kAPI_12HourTimeFormat               = "hh:mm a"

// MARK: - Api Constant for Login, Signup
let kAPI_UserData                       = "user_data"
let kAPI_UserId                         = "user_id"
let kAPI_FirstName                      = "first_name"
let kAPI_LastName                       = "last_name"
let kAPI_Username                       = "username"
let kAPI_Email                          = "email"
let kAPI_Password                       = "password"
let kAPI_Dob                            = "dob"
let kAPI_Gender                         = "gender"
let kAPI_UserImage                      = "user_img"
let kAPI_OTP                            = "otp"
let kAPI_NewPassword                    = "new_password"
let kAPI_MobileNumber                   = "mobile_number"
let kAPI_Language                       = "language"

// MARK: - Api Constant for Product
let kAPI_CategoryId                     = "category_id"
let kAPI_SubcategoryId                  = "subcategory_id"
let kAPI_Selling                        = "selling"
let kAPI_Size                           = "size"
let kAPI_Condition                      = "condition"
let kAPI_BasePrice                      = "base_price"
let kAPI_OfferPrice                     = "offer_price"
let kAPI_Discount                       = "discount"
let kAPI_Brand                          = "brand"
let kAPI_Description                    = "description"
let kAPI_ProductImage                   = "product_image[]"
let kAPI_Type                           = "type"
let kAPI_BidAmount                      = "bid_amount"
let kAPI_ProductId                      = "product_id"

//**    Result Success |"1"| / Failure |"0"|
let kAPI_Result_Success      = "1"
let kAPI_Result_Failure      = "0"

//** Certificate Type
let kCertificateDevelopment  = "development"
let kCertificateProduction   = "production"
let kCertificateAppStore     = "live"

//** Other Api Constants
let kDevicePlatform          = "ios"

//*> Server response code

//    200 – OK – Eyerything is working
//    201 – OK – New resource has been created
//    204 – OK – The resource was successfully deleted
//
//    304 – Not Modified – The client can use cached data
//
//    400 – Bad Request – The request was invalid or cannot be served. The exact error should be explained in the error payload. E.g. „The JSON is not valid“
//    401 – Unauthorized – The request requires an user authentication
//    403 – Forbidden – The server understood the request, but is refusing it or the access is not allowed.
//    404 – Not found – There is no resource behind the URI.
//    422 – Unprocessable Entity – Should be used if the server cannot process the enitity, e.g. if an image cannot be formatted or mandatory fields are missing in the payload.
//
//    500 – Internal Server Error – API developers should avoid this error. If an error occurs in the global catch blog, the stracktrace should be logged and not returned as response.
