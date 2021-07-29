//
//  ViewRecipientsListVC.swift
//  Repoush
//
//  Created by Apple on 11/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
class ViewRecipientsListVC: UIViewController {
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblNodataFound:UILabel!
    var productId = ""
    var isSelectedSent = true
    var offerList = [ModelRecipintOfferList]()
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if  isConnectedToInternet() {
           self.callServiceGetNotification()
            } else {
        self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
    }
    func changeLanguage(strLanguage:String) {
            self.lblNodataFound.text = "No_Record_Found".LocalizableString(localization: strLanguage)
            self.lblTitle.text = "Recipients_List".LocalizableString(localization: strLanguage)
        
    }
   
   func callServiceGetNotification() {
    var loading = ""
    if (MyDefaults().language ?? "") as String ==  "en"{
        loading = "Loading".LocalizableString(localization: "en")
    } else{
      loading = "Loading".LocalizableString(localization: "da")
    }
let parameter: [String: Any] = ["product_id":productId,
                                    "language":MyDefaults().language ?? AnyObject.self]
 
    print(parameter)
    HTTPService.callForPostApi(url:getOfferListDetail , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                           let response = ModelViewReceipintList.init(fromDictionary: response as! [String : Any])
                            if response.offerList.count > 0{
                                self.offerList = response.offerList
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
     self.navigationController?.popViewController(animated: true)
 }
}
extension ViewRecipientsListVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.offerList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipientsTableViewCell", for: indexPath) as! RecipientsTableViewCell
        cell.lblFullName.text = self.offerList[indexPath.row].name
        cell.imgView.sd_setImage(with: URL(string:self.offerList[indexPath.row].userImage), placeholderImage:#imageLiteral(resourceName: "dummy_post"))
        
        return cell
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    
    }
    @objc func recepientsList(_ sender: UIButton) {
        let vc = Util.loadViewController(fromStoryboard: "PriviewPageVC", storyboardName: "Home") as? PriviewPageVC
        if let aVc = vc {
            aVc.hidesBottomBarWhenPushed = true
        show(aVc, sender: nil)
                       }
    }
}

class RecipientsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFullName :UILabel!
    
    @IBOutlet weak var imgView :UIImageView!
}
