//
//  CommonPopupAlert.swift
//  Repoush
//
//  Created by mac  on 29/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//


import UIKit
protocol alertpopUpDelegate: NSObject {
   // Protocol method
    func okActionPopUp(controller: UIViewController,index:Int,VC : String)
    func cancelActionPopUp(controller: UIViewController)
}
class CommonPopupAlert: NSObject {
    var index:Int = 0
    var indexSelection : Int = 0
    var delegate: alertpopUpDelegate?
    var viewContolls = ""
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
            self.delegate?.okActionPopUp(controller: vc, index: self.indexSelection, VC: self.viewContolls)

        }))
        vc.present(Alert, animated: true, completion: nil)
    }
    func showAlertPopUp(title:String,message:String,vc:UIViewController)  {
        let Alert = UIAlertController(title: title, message:  NSLocalizedString(message, comment: ""), preferredStyle: UIAlertController.Style.alert)

        if (MyDefaults().language ?? "") as String ==  "en"{
           Alert.addAction(UIAlertAction(title: "showAllbidYes".LocalizableString(localization: "en"), style: .default, handler: { (action: UIAlertAction!) in
           //self.delegate?.okActionPopUp(controller: vc, index: self.indexSelection)

            self.delegate?.okActionPopUp(controller: vc, index: self.indexSelection, VC: self.viewContolls)
        }))
        } else{
            Alert.addAction(UIAlertAction(title: "showAllbidYes".LocalizableString(localization: "da"), style: .default, handler: { (action: UIAlertAction!) in
            //self.delegate?.okActionPopUp(controller: vc, index: self.indexSelection)

             self.delegate?.okActionPopUp(controller: vc, index: self.indexSelection, VC: self.viewContolls)
         }))
        }
        if (MyDefaults().language ?? "") as String ==  "en"{
            Alert.addAction(UIAlertAction(title: "cancel_bid".LocalizableString(localization: "en"), style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                self.delegate?.cancelActionPopUp(controller: vc)
            }))
        } else{
            Alert.addAction(UIAlertAction(title: "cancel_bid".LocalizableString(localization: "da"), style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                self.delegate?.cancelActionPopUp(controller: vc)
            }))
        }
        
            

        vc.present(Alert, animated: true, completion: nil)
    }
    
}
