//
//  HTTPService.swift
//  Socket.IO.Demo
//
//  Created by Namit Agrawal on 07/04/20.
//  Copyright © 2020 Pawan Malviya. All rights reserved.
//

import Foundation
//
//  HTTPService.swift
//  Fleet Management
//
//  Created by iMac on 30/10/17.
//  Copyright Â© 2017 iMac. All rights reserved.
//

import UIKit
import Alamofire

class Connectivity {
    
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class HTTPService {

    //Mark: Method for call "Post" type Api's
    
    class func callForPostApi(url: String, parameter: [String: Any],authtoken:String, showHud: Bool,text:String, VC:UIViewController,completionHandler: @escaping (AnyObject) -> Void) {

        
        if showHud {
            
            appDelegate.showLoader(VC, text: text)
        }
        
        let headerDict : [String: String] = ["mobile_auth_token" : authtoken]
        Alamofire.request(url, method: .post, parameters: parameter,encoding: URLEncoding.default, headers: headerDict).responseJSON { response in
            
        switch response.result {
            
        case .success:
                let json = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                if let json = json {
                    print("respons\(json)")
                }
                if let value = response.result.value {
                   completionHandler(value as AnyObject)
                   print(response)
                    if showHud {
                        appDelegate.hideLoader(VC)
                    }
                    break
                }
            case .failure(let error):
                print(error)
                completionHandler(response as AnyObject)
           // HideHud()
                if showHud {
                    appDelegate.hideLoader(VC)
                }
                break
            }
        }
    }
    
    //Mark: Method for call "Get" type Api's with passing perameters
    class func callForGetWithParameterApi(url: String, parameter: [String: Any],authtoken:String, showHud: Bool,text:String,completionHandler: @escaping (AnyObject) -> Void) {
        
        let headerDict : [String: String] = ["mobile_auth_token" : authtoken]
        Alamofire.request(url, method:.get, parameters : parameter,headers: headerDict).responseJSON(completionHandler: { response in
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value {
                        debugPrint(response.result.value!)
                        completionHandler(data as AnyObject)
                    }
                    break
                case .failure(_):

                    //iSSnackbarShow(message: (response.error?.localizedDescription)!)
                    completionHandler(response as AnyObject)
                    break

                }
       })
    }
 
//    class func uploadimage(url: String,imageToUpload: [[String : Any]],authtoken:String,showHud: Bool,VC:UIViewController, parameters: [String: Any], completionHandler: @escaping (AnyObject) -> Void) {
//
//        print(imageToUpload)
//
//            if showHud {
//                   appDelegate.showLoader(VC)
//               }
//
//              // let headerDict : [String: String] = ["Apikey" : AppSecureKey.APIKey]
//            let headerDict : [String: String] = ["mobile_auth_token" : authtoken]
//
//        Alamofire.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
//                   for (key, value) in parameters {
//                       multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                   }
//                if showHud {
//                    appDelegate.hideLoader(VC)
//                }
//                    for i in 0..<imageToUpload.count {
//                      let dict = imageToUpload[i]
//
//                        let type = dict["type"] as! String
//
//                        if dict["isselected"] as! String == "yes"{
//                           if type == "image" {
//                                    let dict = imageToUpload[i]
//                                   let image = dict["png"] as! UIImage
//
//                                let name = dict["uploadfile"] as! String
//                                   let imageData: Data = image.jpegData(compressionQuality: 0.5)!
//                                    multipartFormData.append(imageData, withName: name, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "file")
//
//                            }else if type == "url" {
//                                    let dict = imageToUpload[i]
//                                    print(dict)
//                                    print(dict["url"] ?? "")
//                                    //let file = dict["url"] as! URL
//                                    let file = URL(string: dict["url"] as! String)
//                                    let name = dict["uploadfile"] as? String
//                                    multipartFormData.append(file!, withName: name!)
//                                }else{
//
//                                 }
//                        }
//                    }
//                print(multipartFormData)
//
//               }, to: url,headers:headerDict) { (result) in
//
//                   switch result {
//
//                   case .success(let upload, _ , _):
//
//                       upload.uploadProgress(closure: { (progress) in
//
//                           print("uploding: \(progress.fractionCompleted)")
//                       })
//
//                       upload.responseJSON { response in
//
//                           switch(response.result) {
//
//                           case .success(_):
//
//                               if let data = response.result.value {
//                                   debugPrint(response.result.value!)
//                                   completionHandler(data as AnyObject)
//                               }
//
//                               break
//                           case .failure(_):
//                               completionHandler(response as AnyObject)
//                               break
//                           }
//                       }
//
//                   case .failure(let encodingError):
//                       print("failed")
//                       print(encodingError)
//                   }
//               }
//           }
//    class func uploadimage(url: String,imageToUpload: [[String : Any]],authtoken:String,showHud: Bool,VC:UIViewController, parameters: [String: Any], completionHandler: @escaping (AnyObject) -> Void) {
//
//
//
//            if showHud {
//                   appDelegate.showLoader(VC)
//               }
//
//                for i in 0..<imageToUpload.count {
//                    let dict = imageToUpload[i]
//                    let type = dict["type"] as! String
//                    if dict["isselected"] as! String == "yes"{
//                    if type == "image" {
//                    let dict = imageToUpload[i]
//                    let image = dict["png"] as! UIImage
//                        let name = dict["uploadfile"] as! String
//                        let imgData = image.jpegData(compressionQuality: 0.2)!
//                        Alamofire.upload(multipartFormData: { multipartFormData in
//                                multipartFormData.append(imgData, withName: name,fileName: "file.jpg", mimeType: "image/jpg")
//                                for (key, value) in parameters {
//                                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                              } //Optional for extra parameters
//                      },
//                            to:url,headers:nil)
//
//
//                        { (result) in
//                      switch result {
//                      case .success(let upload, _, _):
//
//                          upload.uploadProgress(closure: { (progress) in
//                              print("Upload Progress: \(progress.fractionCompleted)")
//                          })
//
//                          upload.responseJSON { response in
//
//                            if showHud {
//                                appDelegate.hideLoader(VC)
//                                   }
//                           if let data = response.result.value {
//                            debugPrint(response.result.value!)
//                            completionHandler(data as AnyObject)
//                                                          }
//                            print(response.result.value)
//                          }
//
//                      case .failure(let encodingError):
//                          print(encodingError)
//                      }
//                  }
//        }
//
//
//                        }
//                    }
//
//        }
        
        
    class func uploadimage(url: String,imageToUpload: [[String : Any]],authtoken:String,showHud: Bool,text:String,VC:UIViewController, parameters: [String: Any], completionHandler: @escaping (AnyObject) -> Void) {
            
        if showHud {
            appDelegate.showLoader(VC, text: text)
                    }
        Alamofire.upload(multipartFormData: { multipartFormData in
                
            for i in 0..<imageToUpload.count {
                let dict = imageToUpload[i]
                let type = dict["type"] as! String
                if dict["isselected"] as! String == "yes"{
                if type == "image" {
                    let dict = imageToUpload[i]
                    let image = dict["png"] as! UIImage
                    let name = dict["uploadfile"] as! String
                    let imgData = image.jpegData(compressionQuality: 0.5)!
                    multipartFormData.append(imgData, withName:name,fileName: "ab.jpg", mimeType: "image/jpg")
                   }
                }
            
            }
            
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        } //Optional for extra parameters
                
        
        },
            to:url,headers:nil)
            { (result) in
                switch result {
                case .success(let upload, _, _):

                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })

                      upload.responseJSON { response in
                   if let data = response.result.value {
                                                debugPrint(response.result.value!)
                                                completionHandler(data as AnyObject)
                    if showHud {
                        appDelegate.hideLoader(VC)
                    }
                    
                   }
                                                print(response.result.value)
                                              }

                case .failure(let encodingError):
                    if showHud {
                                                    appDelegate.hideLoader(VC)
                                                       }
                    print(encodingError)
                }
            }
            
            
    }




}
