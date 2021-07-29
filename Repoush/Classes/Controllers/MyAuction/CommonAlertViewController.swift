//
//  CommonAlertViewController.swift
//  Cale
//
//  Created by Amit on 20/03/20.
//  Copyright © 2020 Amit. All rights reserved.
//

import UIKit
protocol alertDelegate: NSObject {
   // Protocol method
    func okAction(controller: UIViewController,index:Int)
    func cancelAction(controller: UIViewController)
}
class CommonAlertViewController: NSObject {
    var index:Int = 0
    var delegate: alertDelegate?
    func showActionAlertView(title:String,message:String,vc:UIViewController) -> Void {
       
        if index == 0 {
            self.showOnlyYesButton(title: title, message: message, vc: vc)
        }else{
            self.showAlertPopUp(title: title, message: message, vc: vc)
        }
        }
    
    func showOnlyYesButton(title:String,message:String,vc:UIViewController)  {
        let Alert = UIAlertController(title: title, message:  NSLocalizedString(message, comment: ""), preferredStyle: UIAlertController.Style.alert)

        Alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.delegate?.okAction(controller: vc, index: self.index)

        }))
        vc.present(Alert, animated: true, completion: nil)
    }
    func showAlertPopUp(title:String,message:String,vc:UIViewController)  {
        let Alert = UIAlertController(title: title, message:  NSLocalizedString(message, comment: ""), preferredStyle: UIAlertController.Style.alert)

        Alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.delegate?.okAction(controller: vc, index: self.index)

        }))

        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            self.delegate?.cancelAction(controller: vc)
        }))

        vc.present(Alert, animated: true, completion: nil)
    }
    
}
