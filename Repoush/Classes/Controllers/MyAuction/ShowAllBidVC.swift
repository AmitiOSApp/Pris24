//
//  ShowAllBidVC.swift
//  Repoush
//
//  Created by mac  on 24/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
protocol delegatetShowAllBidAcceptrequest {
    func delegatSelectAllategoryAccept()
}
class ShowAllBidVC: UIViewController {
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblNodataFound:UILabel!
    @IBOutlet weak var lblTitleNav:UILabel!
    @IBOutlet weak var imgProfile:UIImageView!
    var delegate : delegatetShowAllBidAcceptrequest!
    var productId = ""
    var userImage = ""
    var name = ""
    var showBid = [ModelShowAllBidResponseDatum]()
    var userInfo = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imgProfile.sd_setImage(with: URL(string:userImage), placeholderImage:#imageLiteral(resourceName: "dummy_post"))
        self.lblName.text = name.capitalizingFirstLetter()
        print(LoggedInUser.shared.UserRole!)
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
  }
    func changeLanguage(strLanguage:String) {
            self.lblNodataFound.text = "You_have_not_recived_any_bid".LocalizableString(localization: strLanguage)
            self.lblTitleNav.text = "All_Bid".LocalizableString(localization: strLanguage)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if  isConnectedToInternet() {
           self.callServiceGetAllBid()
            } else {
        self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        
    }
    func callServiceGetAllBid() {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
    let parameter: [String: Any] = ["product_id":productId,
                                    "language": MyDefaults().language ?? AnyObject.self]
        
        print(parameter)
        HTTPService.callForPostApi(url:getAllBidAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                           let response = ModelShowAllBid.init(fromDictionary: response as! [String : Any])
                           
                         if response.responseData.count > 0{
                             self.showBid = response.responseData
                             self.tblView.isHidden = false
                             self.tblView.reloadData()
                             
                         }else{
                             self.tblView.isHidden = true
                         }
                         } else if status == 500 {
                               self.tblView.isHidden = true
                               //self.NORECORDFOUND.isHidden = false
                        }
                        }else{
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
                
        }
    }
    @IBAction func actionOnback(_ sender: Any){
        appDelegate.MyAuction == ""
        self.navigationController?.popViewController(animated: true)
     //   self.dismiss(animated: true, completion: nil)
    }
}
extension ShowAllBidVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showBid.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "showAllBidTAbleViewCell", for: indexPath) as! showAllBidTAbleViewCell
         
       let dates =    self.convertDateFormater24format(self.showBid[indexPath.row].lastLogin)
        cell.lblDate.text =  "Last Active on : " + dates[1] + " - " + dates[0]
        cell.lblPrductName.text = self.showBid[indexPath.row].fullName.capitalizingFirstLetter()
        cell.lblDistance.text = self.showBid[indexPath.row].distance + " Km"
        cell.lblPrice.text =  "Kr " + self.showBid[indexPath.row].bidAmount
        //cell.lblDate.text = self.showBid[indexPath.row].createdAt
        cell.imgView.sd_setImage(with: URL(string:self.showBid[indexPath.row].userImg!), placeholderImage:#imageLiteral(resourceName: "gallery"))
        cell.btnAccept.tag = indexPath.row
        cell.btnAccept.addTarget(self, action: #selector(didTapOnAccept(_:)), for: .touchUpInside)
        
        cell.btnReject.tag = indexPath.row + 1000
        cell.btnReject.addTarget(self, action: #selector(didTapOnReject(_:)), for: .touchUpInside)
        
        if (MyDefaults().language ?? "") as String ==  "en" {
            cell.btnAccept.setTitle("Accept".LocalizableString(localization: "en"), for: .normal)
            cell.btnReject.setTitle("Reject".LocalizableString(localization: "en"), for: .normal)
        } else{
            cell.btnAccept.setTitle("Accept".LocalizableString(localization: "da"), for: .normal)
            cell.btnReject.setTitle("Reject".LocalizableString(localization: "da"), for: .normal)
        }
         return cell
    }
    
    
    func callServiceAccept(index:Int,bidStatus: String) {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        print(index)
       let parameter: [String: Any] = ["user_id":self.showBid[index].userId!,
                                       "product_id":productId,
                                       "bid_status":bidStatus,
                                       "bid_id":self.showBid[index].id!,
                                       "language": MyDefaults().language ?? AnyObject.self,
                                       "previous_status":self.showBid[index].bidStatus!,
                                       "device_type":"ios",
                                       "seller_id":self.showBid[index].sellerId!,
                                       "base_price":self.showBid[index].basePrice!,
                                       "offer_price":self.showBid[index].offerPrice!,
                                       "discount":self.showBid[index].discount!,
                                       "deal_price":self.showBid[index].bidAmount!]
    
          print(parameter)
        HTTPService.callForPostApi(url:getUpDateStatusAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                       debugPrint(response)
                     //  HideHud()
                       if response.count != nil {
                           let status = response["responseCode"] as! Int
                           let message = response["message"] as! String
                           if status == 200  {
                            if message == "Bid Awarded" {
                                self.messageShowAccept(index: index, title: "bid_accepted".LocalizableString(localization: "en"), message: "Bid_Awarded_Successfully".LocalizableString(localization: "en"), okay: "Okay".LocalizableString(localization: "en"))
                            } else if message == "Bud tildelt" {
                                self.messageShowAccept(index: index, title: "bid_accepted".LocalizableString(localization: "da"), message: "Bid_Awarded_Successfully".LocalizableString(localization: "da"), okay: "Okay".LocalizableString(localization: "da"))
                                } else if message == "You have declined a bid and are urging the buyer to bid higher" {
                                    self.messageShowrejected(index: index, title: "Bid_rejected".LocalizableString(localization: "en"), message:  message, okay: "Okay".LocalizableString(localization: "en"))
                            
                            } else{
                                self.messageShowrejected(index: index, title: "Bid_rejected".LocalizableString(localization: "da"), message:  message, okay: "Okay".LocalizableString(localization: "da"))
                            }
                                    
                                   
                                
//                                } else{
//                                if (MyDefaults().language ?? "") as String ==  "en"{
//                                    self.messageShowrejected(index: index, title: "Bid_rejected".LocalizableString(localization: "en"), message:  message)
//                                    } else {
//                                    self.messageShowrejected(index: index, title: "Bid_rejected".LocalizableString(localization: "da"), message:  message)
//                                    }
//                                    }
                                    
                        
                           } else if status == 500 {
                                  self.tblView.isHidden = true
                                  //self.NORECORDFOUND.isHidden = false
                           }
                           }else{
                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                       }
                }
          
       }
    func messageShowAccept(index:Int,title:String,message:String,okay:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            // Create the actions
        let okAction = UIAlertAction(title: okay, style: UIAlertAction.Style.default) {
                UIAlertAction in
            
            //self.navigationController?.backToViewController(viewController: MyAuctionVC.self)
           //NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierAcceptBid"), object: nil)
        
            self.moveToProgress()
        
        }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
    }
    func moveToProgress() {
       //  print("MoveToProgress")
        appDelegate.MyAuction = "sellerInprogress"
        self.navigationController?.backToViewController(viewController: MyAuctionVC.self)
       NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierAcceptBid"), object: nil)
        
    }
    
    func messageShowAcceptProfessional(index:Int,title:String,message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
            self.sendNotification(index: index, title: "Send Offer", message: "Do you want to send a notification to everyone interested in this item ?")
        
        }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
    }
    
    func sendNotification(index:Int,title:String,message:String) {
      
        let Alert = UIAlertController(title: title, message:  NSLocalizedString(message, comment: ""), preferredStyle: UIAlertController.Style.alert)
        Alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.sendOfferNotification(index: index)
        }))
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
           
        }))

        self.present(Alert, animated: true, completion: nil)
    }
    func sendOfferNotification(index:Int) {
        
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
        let popup : SendOfferDicountNotificationPopVC = pop.instantiateViewController(withIdentifier: "SendOfferDicountNotificationPopVC") as! SendOfferDicountNotificationPopVC
        popup.productId = self.showBid[index].productId
        popup.name = self.showBid[index].fullName
        popup.image = self.showBid[index].userImg
        popup.index = index
        popup.delagate = self
        self.presentOnRoot(with: popup, isAnimated: true)
      
    }
    func messageShowrejected(index:Int,title:String,message:String,okay:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: okay, style: UIAlertAction.Style.default) {
                UIAlertAction in
//            self.showBid.remove(at: index)
//            if self.showBid.count == 0 {
//                    self.tblView.isHidden = true
//            }else{
//                    self.showMessage(index: index, Message: message)
//                    self.tblView.reloadData()
//            }
            self.showBid = [ModelShowAllBidResponseDatum]()
            self.callServiceGetAllBid()
        }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
    }
}
extension ShowAllBidVC:alertDelegate,delegateSendOfferNotification {
    func getdelegatSendOfferNotification(index:Int){
        
        self.dismiss(animated: true, completion: nil)
        let vc = Util.loadViewController(fromStoryboard: "DiscountNotificationDetailVC", storyboardName: "Home") as? DiscountNotificationDetailVC
        vc?.sellerid = self.showBid[index].sellerId
        vc?.product_id = self.showBid[index].productId
        vc?.sellerid = self.showBid[index].sellerId
        vc?.seller_name = self.showBid[index].fullName
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func getdelegatCancelSendOfferNotification(index:Int){
//        if  isConnectedToInternet() {
//            self.showBid = [ModelShowAllBidResponseDatum]()
//            self.callServiceGetAllBid()
//            } else {
//        self.showErrorPopup(message: internetConnetionError, title: alert)
//        }
    }
    @objc func didTapOnAccept(_ sender: UIButton) {
        print(sender.tag)
        self.callServiceAccept(index: sender.tag, bidStatus: "2")
    }
    @objc func didTapOnReject(_ sender: UIButton) {
        self.callServiceAccept(index: sender.tag - 1000, bidStatus: "3")
    }
    func showMessage(index:Int,Message: String) {
        let commonAlert = CommonAlertViewController()
        commonAlert.delegate = self
        commonAlert.index = index
        commonAlert.showActionAlertView(title: "Bid Awarded", message: Message, vc: self)
    }
    func okAction(controller: UIViewController, index: Int) {
       
    // self.CallServiceUnJoinMeetingAPI(index:index)
    }
    func cancelAction(controller: UIViewController) {
       //  self.dismiss(animated: true, completion: nil)
    }
}
class showAllBidTAbleViewCell: UITableViewCell {
     @IBOutlet weak var lblPrductName :UILabel!
     @IBOutlet weak var lblDistance :UILabel!
     @IBOutlet weak var lblDate :UILabel!
     @IBOutlet weak var btnAccept :UIButton!
     @IBOutlet weak var btnReject :UIButton!
     @IBOutlet weak var lblPrice :UILabel!
     @IBOutlet weak var imgView :UIImageView!
}
