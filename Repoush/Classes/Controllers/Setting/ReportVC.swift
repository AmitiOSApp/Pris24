//
//  ReportVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/1/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class ReportVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var txfTitle: UITextField!
    @IBOutlet weak var txvDescription: UITextView!
    
    // MARK: - Property initialization
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReport_Action(_ sender: UIButton) {
        // Check required field validation
        if isRequiredFieldValid() {
            // Perform Report a problem API
            repotAPI_Call()
        }
    }
    
    // MARK: - Private Methods
    private func isRequiredFieldValid() -> Bool {
        if !Util.isValidString(txfTitle.text!) {
            Util.showAlertWithMessage("Please enter title", title: Key_Alert); return false
        }
        else if !Util.isValidString(txvDescription.text!) {
            Util.showAlertWithMessage("Please enter description", title: Key_Alert); return false
        }
        return true
    }
    
    private func resignAllActiveResponder() {
        if txfTitle.isFirstResponder {
            txfTitle.resignFirstResponder()
        }
        else if txvDescription.isFirstResponder {
            txvDescription.resignFirstResponder()
        }
    }
    
    // MARK: - API Methods
    private func repotAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId      : LoggedInUser.shared.id as AnyObject,
                kAPI_Description : txvDescription.text as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.userLogin(postParams), callerObj: self, showHud:true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                Util.showAlertWithMessage(jsonObj[Key_Message].stringValue, title: Key_Alert)
                return
            }
            
            let alertController = UIAlertController(title: Key_Alert, message: jsonObj[Key_Message].stringValue , preferredStyle:UIAlertController.Style.alert)
            self?.present(alertController, animated: true, completion: nil)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self?.navigationController?.popViewController(animated: true)
            }))
        }
    }
    
}
