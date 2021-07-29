//
//  PlacedBidVCPopUp.swift
//  Repoush
//
//  Created by mac  on 17/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
protocol getPlaceBid {
    func delegatPlacedBid(bidAmmount:String,index:Int)
    func delegatCancelPlacedBid(bidAmmount:String,index:Int)
}
class PlacedBidVCPopUp: UIViewController {
     @IBOutlet weak var lblTimeLeft : UILabel!
     @IBOutlet weak var lblOfferPrice : UILabel!
     @IBOutlet weak var lblLastBid : UILabel!
     @IBOutlet weak var lblTotalBid : UILabel!
     @IBOutlet weak var txtEnterBid : UITextField!
    
    
    @IBOutlet weak var lblTitleNav : UILabel!
    @IBOutlet weak var lblPlaceBidLoc : UILabel!
    @IBOutlet weak var lblOfferPriceLoc : UILabel!
    @IBOutlet weak var lblLastBidAmountLoc : UILabel!
    @IBOutlet weak var lblTotalBidLoc : UILabel!
    @IBOutlet weak var lblEntryYourBidLoc : UILabel!
    @IBOutlet weak var btnPlaceBid : UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    
    var IntLastBidAmount : Int = 0
    var IntOfferBid : Int = 0
   
        var  data = [String:Any]()
        var countdownTimer: Timer!
        var index : Int = 0
        var totalTime = 0
        var delagate: getPlaceBid!
     override func viewDidLoad() {
        super.viewDidLoad()
       
      print(data)
        
//        self.lblLastBid.text = data["last_bid_amount"] as? String
//        print(data["last_bid_amount"] as? String)
//       // print(self.lblLastBid.text!)
//        self.lblOfferPrice.text = data["offer_price"] as? String
//        self.lblTotalBid.text = data["total_bid"] as? String
       // Do any additional setup after loading the view.
        
        let bidAmmount = data["last_bid_amount"] as? String
        if bidAmmount != nil {
            self.lblLastBid.text = "Kr " + bidAmmount!
        }else{
            self.lblLastBid.text = "Kr " + "0"
        }
        self.IntLastBidAmount = Int(data["last_bid_amount"] as? String ?? "") ?? 0
        self.IntOfferBid = Int(data["offer_price"] as? String ?? "") ?? 0
        
        self.lblOfferPrice.text = data["offer_price"] as? String
        totalTime = data["time_left_in_second"] as! Int
        let totalbid = data["total_bid"] as! Int
        self.lblTotalBid.text =  String(totalbid)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
     
     }
    func changeLanguage(strLanguage:String) {
           
            self.lblTitleNav.text = "Place_Bid".LocalizableString(localization: strLanguage)
            self.lblEntryYourBidLoc.text = "Entery_your_bid".LocalizableString(localization: strLanguage)
            self.lblPlaceBidLoc.text = "Place_Bid".LocalizableString(localization: strLanguage)
            self.lblOfferPriceLoc.text = "OfferPrice".LocalizableString(localization: strLanguage)
            self.lblLastBidAmountLoc.text = "LastBidAmount".LocalizableString(localization: strLanguage)
            self.lblTotalBidLoc.text = "Total_bid".LocalizableString(localization: strLanguage)
            self.btnPlaceBid.setTitle("Place_Bid".LocalizableString(localization: strLanguage), for: .normal)
            self.btnCancel.setTitle("cancel_bid".LocalizableString(localization: strLanguage), for: .normal)
            self.txtEnterBid.placeholder = "enter_amount".LocalizableString(localization: strLanguage)
        
    }
    @objc func updateTime() {
        
        self.lblTimeLeft.text = "\(timeFormatted(totalTime))"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    func endTimer() {
        countdownTimer.invalidate()
        self.lblTimeLeft.text = "Time Invalid"
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d",hours, minutes, seconds)
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // Hide the navigation bar on the this view controller
           self.navigationController?.setNavigationBarHidden(true, animated: animated)
           
       }
    @IBAction func actionOnPlacedBid(_ Sender:Any){
        if !checkValidetionAmmount() {
            if self.delagate != nil {
                self.delagate.delegatPlacedBid(bidAmmount: self.txtEnterBid.text!, index: index)
            }
        }
        
    }
    @IBAction func actionOnCancel(_ Sender:Any){
        
        if self.delagate != nil {
            self.delagate.delegatCancelPlacedBid(bidAmmount: "0", index: 0)
        }
    }
    func checkValidetionAmmount() -> Bool {
       
            if (MyDefaults().language ?? "") as String ==  "en"{
                guard let userEmail = txtEnterBid.text , userEmail != "" else {showAlert(title: ALERTMESSAGE, message: "bid_amount_blank_error".LocalizableString(localization: "en"))
                    return true}
            }else{
                guard let userEmail = txtEnterBid.text , userEmail != "" else {showAlert(title: ALERTMESSAGE, message: "bid_amount_blank_error".LocalizableString(localization: "da"))
                    return true}
            }
            
           
        guard self.CompareAmmount() == true  else {
            if (MyDefaults().language ?? "") as String ==  "en"{
            showAlert(title: ALERTMESSAGE, message: "Bid_amount_should_be_greater_than_last_bid".LocalizableString(localization: "en"))
            return true
            } else{
                showAlert(title: ALERTMESSAGE, message: "Bid_amount_should_be_greater_than_last_bid".LocalizableString(localization: "da"))
                return true
            }
            
        }
       return false
    }
    func CompareAmmount() -> Bool {
        print(self.txtEnterBid.text!)
        
        let lastBid = Int(data["last_bid_amount"] as? String ?? "") ?? 0
        print(lastBid)
        let bidAmmount = Int(self.txtEnterBid.text!)
        let offerAmmount = Int(self.lblOfferPrice.text!)!

//        let numberStr: String = self.txtEnterBid.text!
//        let formatter: NumberFormatter = NumberFormatter()
//        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
//        let final = formatter.number(from: numberStr)
//        let doubleNumber = Double(truncating: final!)
//            print("\(doubleNumber)")
        
    
        if bidAmmount == nil {
            self.showAlert(title: "", message: "Keyboard does not support in other language please select english number keybord")
        } else {
        
        
        if bidAmmount ?? 0 >= offerAmmount {
            if bidAmmount ?? 0 > lastBid {
                return true
            } else {
                if (MyDefaults().language ?? "") as String ==  "en"{
                    showAlert(title: ALERTMESSAGE, message: "Bid_amount_should_be_greater_than_last_bid".LocalizableString(localization: "en"))
                    return false
                    } else{
                    showAlert(title: ALERTMESSAGE, message: "Bid_amount_should_be_greater_than_last_bid".LocalizableString(localization: "da"))
                    return false
                }
            }
        } else{
            if lastBid > offerAmmount {
                if bidAmmount ?? 0 > lastBid {
                    return true
                } else{
                    if (MyDefaults().language ?? "") as String ==  "en"{
                        showAlert(title: ALERTMESSAGE, message: "Bid_amount_should_be_greater_than_last_bid".LocalizableString(localization: "en"))
                        return false
                        } else{
                        showAlert(title: ALERTMESSAGE, message: "Bid_amount_should_be_greater_than_last_bid".LocalizableString(localization: "da"))
                        return false
                    }
                }
            // return true
            } else{
               
                if (MyDefaults().language ?? "") as String ==  "en"{
                    showAlert(title: ALERTMESSAGE, message: "original_price_small_error".LocalizableString(localization: "en"))
                    return false
                    } else{
                    showAlert(title: ALERTMESSAGE, message: "original_price_small_error".LocalizableString(localization: "da"))
                    return false
                }
            }
        }
        }
     //  return false
    return false
    }
}
