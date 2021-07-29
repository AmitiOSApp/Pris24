//
//  SendOfferDicountNotificationPopVC.swift
//  Repoush
//
//  Created by Apple on 09/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

protocol delegateSendOfferNotification {
    func getdelegatSendOfferNotification(index:Int)
    func getdelegatCancelSendOfferNotification(index:Int)
}
class SendOfferDicountNotificationPopVC: UIViewController {
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnSendOffer: UIButton!
    @IBOutlet var btnCancel: UIButton!
   
    var delagate: delegateSendOfferNotification!
    var sendNotifcation = [ModelResponseSendNotificationDatum]()
    var productId = ""
    var name = ""
    var image = ""
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgView.sd_setImage(with: URL(string:image), placeholderImage:#imageLiteral(resourceName: "gallery"))
        self.lblName.text = name
    
        if  isConnectedToInternet() {
           self.callServiceGetAllBidBuyer()
            } else {
        self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    
        if (MyDefaults().language ?? "") as String ==  "en" {
            self.changeLanguage(strLanguage: "en")
        } else {
            self.changeLanguage(strLanguage: "da")
        }
    }
    func changeLanguage(strLanguage:String) {
        self.lblTitle.text = "Discount_Notifications".LocalizableString(localization: strLanguage)
        self.btnSendOffer.setTitle("SEND_OFFER".LocalizableString(localization: strLanguage), for: .normal)
        self.btnCancel.setTitle("cancel_bid".LocalizableString(localization: strLanguage), for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    @IBAction func actionOnCancel(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
        if self.delagate != nil {
            self.delagate.getdelegatCancelSendOfferNotification(index: 0)
        }
    }
    @IBAction func actionOnSendOffer(_ sender:Any){
        if self.delagate != nil {
            self.delagate.getdelegatSendOfferNotification(index: index)
        }
    }
    
    func callServiceGetAllBidBuyer() {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["product_id":productId,
                                    "language": MyDefaults().language ?? AnyObject.self]
 
       
        print(parameter)
        HTTPService.callForPostApi(url:getAllBuyerAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                           let response = ModelSendNotification.init(fromDictionary: response as! [String : Any])
                           
                         if response.responseData.count > 0{
                             self.sendNotifcation = response.responseData
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
    
}
extension SendOfferDicountNotificationPopVC : UITableViewDelegate,UITableViewDataSource{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
    return sendNotifcation.count
   
   }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : SendOfferDicountNotificationTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "SendOfferDicountNotificationTableViewCell", for: indexPath) as? SendOfferDicountNotificationTableViewCell
        cell?.lblTitle.text = self.sendNotifcation[indexPath.row].fullName.capitalizingFirstLetter()
        cell?.lblDistance.text = self.sendNotifcation[indexPath.row].distance + " Km"
        cell?.lblRupee.text = " Kr" + self.sendNotifcation[indexPath.row].bidAmount
        let date = self.convertDateFormater24format(self.sendNotifcation[indexPath.row].createdAt)
        cell?.lblDate.text = date[1] + " - " + date[0]
        cell?.imgView.sd_setImage(with: URL(string:self.sendNotifcation[indexPath.row].userImg), placeholderImage:#imageLiteral(resourceName: "gallery"))
        
        return cell!
   }

}
class SendOfferDicountNotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblDistance : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblRupee : UILabel!
    override func awakeFromNib() {
        
    }
   
}
