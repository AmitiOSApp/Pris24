
import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct Networking {
    
    enum Router: URLRequestConvertible {
        
        // MARK: - API name
        case sendOTP([String: Any])
        case verifyOTP([String: Any])
        case userRegistration([String: Any])
        case userLogin([String: Any])
        case getSubCategory([String: Any])
        case postProduct([String: Any])
        case getAllProduct([String: Any])
        case placeBid([String: Any])
        case getAllUserProducts([String: Any])
        case getAllBid([String: Any])
        case getUserHistoryProduct([String: Any])

        // MARK: - Methods
        var method: Alamofire.HTTPMethod {
            
            switch self {
            //** Post Api
            case .sendOTP:
                return .post
            case .verifyOTP:
                return .post
            case .userRegistration:
                return .post
            case .userLogin:
                return .post
            case .getSubCategory:
                return .post
            case .postProduct:
                return .post
            case .getAllProduct:
                return .post
            case .placeBid:
                return .post
            case .getAllUserProducts:
                return .post
            case .getAllBid:
                return .post
            case .getUserHistoryProduct:
                return .post
            }
        }
        
        //** Intialize api path in |path|
        var path: String {
            
            switch self {
            case .sendOTP:
                return "send_otp"
            case .verifyOTP:
                return "verify_otp"
            case .userRegistration:
                return "userRegistration"
            case .userLogin:
                return "userLogin"
            case .getSubCategory:
                return "getSubCategory"
            case .postProduct:
                return "postProduct"
            case .getAllProduct:
                return "getAllProducts"
            case .placeBid:
                return "place_bid"
            case .getAllUserProducts:
                return "getAllUserProducts"
            case .getAllBid:
                return "get_AllBid"
            case .getUserHistoryProduct:
                return "getUserHistoryProducts"
            }
        }
        
        //** MARK: URLRequestConvertible
        func asURLRequest() throws -> URLRequest {
            
            var strUrl = kAPI_BaseURL + path
            strUrl = Util.encodedURL(strUrl)
            
            let URL = Foundation.URL(string:strUrl)!
            var urlRequest = URLRequest(url: URL as URL)
            urlRequest.httpMethod = method.rawValue
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content")
            urlRequest.setValue("keep-alive", forHTTPHeaderField: "Connection")
            
            switch self {
            case .sendOTP(let parameters):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            case .verifyOTP(let parameters):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            case .userRegistration(let parameters):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            case .userLogin(let parameters):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            case .getSubCategory(let parameters):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            case .postProduct(let parameters):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            case .getAllProduct(let parameters):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            case .placeBid(let parameters):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            case .getAllUserProducts(let parameters):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            case .getAllBid(let parameters):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            case .getUserHistoryProduct(let parameters):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            }
            return urlRequest
        }
    }
    
    /**
     * Genric method use for performing web api request and after getting response callback to caller class.
     *
     * - parameter requestName: A perticular request that define in Router Enum. It may contain request parameter or may not be.
     * - parameter callerObj: Object of class which make api call
     * - parameter showHud: A boolean value that represent is need to display hud for the api or not
     * - parameter completionHandler: A closure that provide callback to caller after getting response
     */
    static func performApiCall(_ requestName: Networking.Router, callerObj: AnyObject, showHud: Bool, completionHandler:@escaping ( (DataResponse<Any>) -> Void)) {
        
        if showHud {
            appDelegate.showLoader(callerObj as! UIViewController)
        }
        
        let request = Alamofire.request(requestName).validate().responseJSON { response in
            
            DLog(message: "Parsed JSON:=========== \(String(describing: response.result.value))")
            
            if showHud {
                appDelegate.hideLoader(callerObj as! UIViewController)
            }
                        
            switch response.result {
                
            case .success:
                DLog(message: "Get Success response from server with status code:\(String(describing: response.response?.statusCode)), for api request:\(String(describing: response.request?.url))")
                
            //** Handle failure response
            case .failure:
                DLog(message: "Get response from server for api request:\(String(describing: response.request?.url)) in failure section")
                Networking.handleApiResponse(response)
            }
            completionHandler(response)
        }
        DLog(message: "Request Added to Queue for exection. Request URL:\(request)")
    }
    
    static func handleApiResponse(_ response: DataResponse<Any>) {
        
        let errorCode = response.response?.statusCode
        if errorCode == nil {
            //errorCode = response.result.error?.code
        }
        print("Get response from server with status code:\(String(describing: errorCode)), for api request:\(String(describing: response.request?.url))")
        
        let dataString = String(data: response.data!, encoding: String.Encoding.utf8)
        
        let result = Util.convertStringToDictionary(dataString!)
        
        var errorDescription = ""
        
        if let errorDes = result?["message"] {
            errorDescription = errorDes as! String
        }
        
        if errorDescription == "" && dataString != nil {
            errorDescription = dataString!
        }
        
        var strError = errorDescription as String
        
        if let contentType = response.response?.allHeaderFields["Content-Type"] as? String {
            if contentType == "text/html" {
                strError = "Server error"
            }
        }
        
        print(strError)
        
        if let httpStatusCode = errorCode {
            switch httpStatusCode {
                
            case 401:
                print("Session Expired")
                let uiAlert = UIAlertController(title: "Session expire", message: "Your last session has expired, please log in again" , preferredStyle:UIAlertController.Style.alert)
                appDelegate.window?.rootViewController!.present(uiAlert, animated: true, completion: nil)
                
                uiAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

                }))
                
            //** Almofire libarary error code
            case -999:
                print("\(String(describing: response.request?.url)) request was cancelled")
            case -1001:
                Util.showAlertWithMessage(msgTimeOut, title:"Error")
            case -1003, -1004, -1009:
                Util.showAlertWithMessage(msgCheckConnection, title:"Error")
            case -1005:
                Util.showAlertWithMessage(msgConnectionLost, title:"Error")
            case -1200, -1201, -1202, -1203, -1204, -1205, -1206:
                Util.showAlertWithMessage("The secure connection failed for an unknown reason.", title:"SSL Server Error")
                
            default:
                if Util.isValidString(strError) {
                    Util.showAlertWithMessage(Util.deleteHTMLTag(tag: strError), title:"Error")
                }
                else {
                    Util.showAlertWithMessage(msgSorry, title:"Error")
                }
            }
        }
        else {
            Util.showAlertWithMessage(msgSorry, title:"Error")
        }
    }
    
    /**
     *   This method upload image(s) as a multipart data format
     * - parameter requestName: A perticular request that define in Router Enum. It may contain request parameter or may not be.
     * - parameter imageArray: Array of images it must not be nil
     * - parameter callerObj: Object of class which make api call
     * - parameter showHud: A boolean value that represent is need to display hud for the api or not
     * - parameter completionHandler: A closure that provide callback to caller after getting response
     */
    static func uploadImages(_ requestName: Networking.Router, imageArray: [UIImage], strImageKey : String, callerObj: AnyObject, showHud: Bool, completionHandler: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) {
        
        if imageArray.count < 1 {
            return
        }
        
        if showHud {
            // appDelegate.showLoader(callerObj as! UIViewController)
        }

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var index = 1
            for image in imageArray {
                let imageData: NSData? = image.jpegData(compressionQuality: 1.0) as NSData?
                if imageData != nil {
                    multipartFormData.append(imageData! as Data, withName: strImageKey, fileName: "image.jpeg", mimeType: "image/jpeg")
                }
                index += 1
            }
        }, with: requestName,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    DLog(message: "Image(s) Uploaded successfully:\(response)")
                }
            case .failure(let encodingError):
                DLog(message: "encodingError:\(encodingError)")
                
                Util.showAlertWithMessage(msgSorry, title:"Error")
            }
            
            if showHud {
                // appDelegate.hideLoader(callerObj as! UIViewController)
            }
            completionHandler!(encodingResult)
        })
    }

    /**
     *   This method upload image(s) as a multipart data format
     * - parameter requestName: A perticular request that define in Router Enum. It may contain request parameter or may not be.
     * - parameter imageArray: Array of images it must not be nil
     * - parameter callerObj: Object of class which make api call
     * - parameter showHud: A boolean value that represent is need to display hud for the api or not
     * - parameter completionHandler: A closure that provide callback to caller after getting response
     */
    static func uploadImagesWithParams(_ requestName: Networking.Router, imageArray: [UIImage?]?, strImageKey : String, dictParams: [String: AnyObject], callerObj: AnyObject, showHud: Bool, completionHandler: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) {
        
        if showHud {
            appDelegate.showLoader(callerObj as! UIViewController)
        }

        Alamofire.upload(multipartFormData: { (multipartFormData) in

            if imageArray != nil && (imageArray?.count)! > 0 {
                for image in imageArray! {
                    if image != nil {
                        let imageData: NSData? = image!.jpegData(compressionQuality: 0.5) as NSData?
                        if imageData != nil {
                            
                            multipartFormData.append(imageData! as Data, withName: strImageKey, fileName: "image.jpeg", mimeType: "image/jpeg")
                            
                            for (key, value) in dictParams {
                                let data = "\(value)".data(using: .utf8)
                                multipartFormData.append(data! as Data, withName: key)
                            }
                        }
                    }
                    else {
                        for (key, value) in dictParams {
                            let data = "\(value)".data(using: .utf8)
                            multipartFormData.append(data! as Data, withName: key)
                        }
                    }
                }
            }
            else {
                for (key, value) in dictParams {
                    let data = "\(value)".data(using: .utf8)
                    multipartFormData.append(data! as Data, withName: key)
                }
            }
        },
        with: requestName,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    DLog(message: "Image(s) Uploaded successfully:\(response)")
                    
                    let dataString = String(data: response.data!, encoding: String.Encoding.utf8)
                    let resultTest = Util.convertStringToDictionary(dataString!)
                    var errorDescription = ""
                    
                    if let errorDes = resultTest?["message"] {
                        errorDescription = errorDes as! String
                    }
                    if errorDescription == "" && dataString != nil {
                        errorDescription = dataString!
                    }
                    var strError = errorDescription as String
                    
                    if let contentType = response.response?.allHeaderFields["Content-Type"] as? String {
                        if contentType == "text/html" {
                            strError = "Server error"
                        }
                    }
                    print(strError)
                    
                    if showHud {
                        appDelegate.hideLoader(callerObj as! UIViewController)
                    }
                    guard let result = response.result.value else {
                        Util.showAlertWithMessage(msgSorry, title: "Error")
                        return
                    }
                    DLog(message: "\(result)")
                }
            case .failure(let encodingError):
                DLog(message: "encodingError:\(encodingError)")
                
                if showHud {
                    appDelegate.hideLoader(callerObj as! UIViewController)
                }
                Util.showAlertWithMessage(msgSorry, title:"Error")
            }
            completionHandler!(encodingResult)
        })
    }

    /**
     * Method use for Image downloading from URL using KingFisher library.
     * - parameter fromUrl: Downloading image URL string
     * - parameter completionHandler: A closure that provide callback to caller after getting response
     */
    static func downloadImage(fromUrl url: String, completionHandler:@escaping (_ image: UIImage?) -> Void) {
        
        if url.isEmpty {
            completionHandler(nil)
            return
        }
        
        let imageViewTest = UIImageView()
        
        imageViewTest.kf.setImage(with: URL(string: url), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, imageURL) -> () in
            
            completionHandler(image)
        }
    }
    
    /**
     * Genric method use for Image downloading from URL.
     * - parameter fromUrl: Downloading image URL string
     * - parameter paceholder: paceholder image name. If we not get image from server then return placehodel image.
     * - parameter completionHandler: A closure that provide callback to caller after getting response
     */
    
    static func downloadImage(fromUrl url: String, withPlaceHolder paceholder: String, completionHandler:@escaping (_ image: UIImage?) -> Void) {
        
        if url.isEmpty && paceholder.isEmpty {
            completionHandler(nil)
            return
        }
        
        if url.isEmpty && !paceholder.isEmpty {
            completionHandler(UIImage(named:paceholder))
            return
        }
        
        let imageViewTest   = UIImageView()
        var defaultImage    = UIImage()
        
        if !paceholder.isEmpty {
            defaultImage = UIImage(named:paceholder)!
        }
        
        imageViewTest.kf.setImage(with: URL(string: url), placeholder: defaultImage, options: nil, progressBlock: nil) { (image, error, cacheType, imageURL) -> () in
            
            if image == nil {
                completionHandler(defaultImage)
            }
            else {
                completionHandler(image)
            }
        }
    }
    
}


/**
 * Response Object Serialization Extension
 */
public protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: AnyObject)
}


