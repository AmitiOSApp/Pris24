//
//  GuestUserAlertViewController.swift
//  Repoush
//
//  Created by Apple on 16/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit


protocol getUserAppear: NSObject {
   // Protocol method
    func GetgusetUserAppear(controller: UIViewController,index:Int,isLoginByPlaceBid:Bool)
    func cancelGuestUser(controller: UIViewController)
}
class GuestUserAlertViewController: NSObject {
    var index:Int = 0
    var delegate: getUserAppear?
    var isLoginByPlaceBid = false
    func ShowAlertWhenUserNotExist(title:String,message:String,vc:UIViewController,Okay:String,Cancel:String) -> Void {
       
        self.showAlertPopUp(title: title, message: message, vc: vc,Okay:Okay,Cancel:Cancel)
    }
    
    
    func showAlertPopUp(title:String,message:String,vc:UIViewController,Okay:String,Cancel:String)  {
        let Alert = UIAlertController(title: title, message:  NSLocalizedString(message, comment: ""), preferredStyle: UIAlertController.Style.alert)

        Alert.addAction(UIAlertAction(title: Okay, style: .default, handler: { (action: UIAlertAction!) in
            self.delegate?.GetgusetUserAppear(controller: vc, index: self.index, isLoginByPlaceBid: self.isLoginByPlaceBid)

        }))

        Alert.addAction(UIAlertAction(title: Cancel, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            self.delegate?.cancelGuestUser(controller: vc)
        }))

        vc.present(Alert, animated: true, completion: nil)
    }
    
}
