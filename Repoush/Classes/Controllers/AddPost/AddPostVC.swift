


//
//  AddPostEditVC.swift
//  Repoush
//
//  Created by mac  on 29/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class AddPostVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var collectionProductImage:UICollectionView!
    @IBOutlet weak var collectionCategory:UICollectionView!
    @IBOutlet weak var collectionCategoryTraling:NSLayoutConstraint!
    @IBOutlet weak var collectionCategoryLeading:NSLayoutConstraint!
    @IBOutlet weak var txtSubCategory:UITextField!
    @IBOutlet weak var txtWhatareYouSelling:UITextField!
   // @IBOutlet weak var txtCondition:UITextField!
    @IBOutlet weak var txtOfferPrice:UITextField!
    @IBOutlet weak var txtDiscount:UITextField!
    @IBOutlet weak var txtSearch:UITextField!
    @IBOutlet weak var txtOriginalPrice:UITextField!
    //@IBOutlet weak var btnSameAsregistered:UIButton!
    @IBOutlet weak var btnSameragistered:UIButton!
    @IBOutlet weak var btnAddnewAddress:UIButton!
    @IBOutlet weak var txtView:UITextView!
    @IBOutlet weak var txfSearch : UITextField!
    @IBOutlet weak var lblAddress:UILabel!
    @IBOutlet weak var btnBg:UIButton!
    @IBOutlet weak var btnSellNow:UIButton!
    @IBOutlet weak var btnGreaterThan:UIButton!
    @IBOutlet weak var btnLessThan:UIButton!
    
    
    @IBOutlet weak var lblSubCategoryLoc:UILabel!
    @IBOutlet weak var lblWhatareyousellingPriceLoc:UILabel!
    @IBOutlet weak var lblPickUpLoc:UILabel!
  //  @IBOutlet weak var lblConditionLoc:UILabel!
    @IBOutlet weak var lblOriginalPriceLoc:UILabel!
    @IBOutlet weak var lblOfferPriceLoc:UILabel!
    @IBOutlet weak var lblPostProductLoc:UILabel!
    @IBOutlet weak var lblDiscountLoc:UILabel!
    @IBOutlet weak var lblSameAsRagisteredAddress:UILabel!
    @IBOutlet weak var lblNewAddress:UILabel!
    @IBOutlet weak var imgSameAsRagisteredAddress:UIImageView!
    @IBOutlet weak var imgNewAddress:UIImageView!
    
  //  @IBOutlet weak var lblDiscountLoc:UILabel!
    
    
    var productData : ModelProductDatum!
    
    @IBOutlet weak var viewTopConstrant:NSLayoutConstraint!
    var subcategoryData = [ModelSubcategoryDatum]()
    var propertyData : ModelPropertyObjDatum!
    var objActiveAuction : ModelSellerActiveAuctionResponseDatum!
    var categoryData = [ModelCategoryDatum]()
    var arraypropertry = [[String:Any]]()
    var arraypropertryValue = [[String:Any]]()
    
    var propertyName = ""
    var propertyValue = ""
    var addressFull = ""
    var addressType = "0"
    var titleName = ""
    var propertyId = ""
    var categoryId = ""
    var subCategoryId = ""
    var PLACEHOLDER = "Descriptions( Optional )"
    
    var isCategorySelected = true
    var isPropertySet = true
    var isAddressSelected = false
    var isImageCollectionSelected = false
    var imageArray = [["png":UIImage(),"type":"image","uploadfile":"product_image[]","isselected":"no","url":"","productId":"0"]]
    var productId = ""
    
    private var latitude = 00.0000000
    private var longitude = 00.0000000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtOriginalPrice.delegate = self
        self.txtView.delegate = self
        self.txtDiscount.delegate = self
        // Do any additional setup after loading the view.
        self.txtOfferPrice.addTarget(self, action: #selector(setOfferPrice), for: .editingChanged)
       // self.txtCondition.addTarget(self, action: #selector(setCondition), for: .editingChanged)
        self.txtOriginalPrice.addTarget(self, action: #selector(tapOnOriginalPrice), for: .editingChanged)
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.hexStringToUIColor(hex: "#02BBCA"), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:tabBar.frame.height), lineHeight: 2.0)
        self.txtSearch.addTarget(self, action: #selector(search), for: .editingChanged)
       // self.txtView.delegate = self
        self.tabBarController?.delegate = self
//        NotificationCenter.default.addObserver(self,
//               selector: #selector(methodOfReceivedNotificationSwitchUser),
//               name: Notification.Name("NotificationIdentifierSwitchUser"),
//               object: nil)
        self.btnLessThan.isHidden = true
        self.btnGreaterThan.isHidden = true
      //  self.collectionProductImage.transform = CGAffineTransform(scaleX: -1, y: 1)
        self.collectionProductImage.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
        if  isConnectedToInternet() {
             callServiceGetCategory()
         } else {
         self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        self.collectionCategory.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.isCategorySelected = true
       // self.setUI()
//        if (MyDefaults().language ?? "") as String ==  "en"{
//            self.changeLanguage(strLanguage: "en")
//        } else{
//            self.changeLanguage(strLanguage: "da")
//        }
      //  self.refreshController()
        self.addressType = "0"
        self.imgSameAsRagisteredAddress.image = UIImage.init(named: "radio_active")
        self.imgNewAddress.image = UIImage.init(named: "radio")
        
        self.clearAllDataViewController()
    }
  @objc func methodOfReceivedNotificationSwitchUser(notification: Notification) {
    
    self.clearAllDataViewController()
    if  isConnectedToInternet() {
     callServiceGetCategory()
     } else {
     self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    // self.setUI()
     if (MyDefaults().language ?? "") as String ==  "en"{
         self.changeLanguage(strLanguage: "en")
     } else{
         self.changeLanguage(strLanguage: "da")
     }

    //self.collectionCategoryTraling.constant = 8
    //self.tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
  }
    
    @objc func setOfferPrice(textField: UITextField) {
     
        if textField.text == "0" {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.EnterCanNotZero(title: "", message: "price_is_not_start_with_zero".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "en"))
            } else{
                self.EnterCanNotZero(title: "", message: "price_is_not_start_with_zero".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "en"))
            }
        } else{
            if self.txtOfferPrice.text!.count > 0 {
           //  self.calculateDiscount()
            }else{
            self.txtOfferPrice.text = ""
            }
        }
    }
    @objc func search(textField: UITextField) {
        self.tabBarController?.selectedIndex = 0
    }
        @objc func tapOnOriginalPrice(textField: UITextField) {
            
            if textField.text == "0" {
                if (MyDefaults().language ?? "") as String ==  "en"{
                    self.EnterCanNotZero(title: "", message: "price_is_not_start_with_zero".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "en"))
                } else{
                    self.EnterCanNotZero(title: "", message: "price_is_not_start_with_zero".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "en"))
                }
            } else{
                if self.txtOfferPrice.text!.isEmpty {
                    self.txtDiscount.text = ""
                    self.txtOfferPrice.text = ""
                    //self.txtOriginalPrice.text = ""
                } else{

                }
                    
            }
        }
    func EnterCanNotZero(title:String, message:String,Okay:String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Okay, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.txtOriginalPrice.text = ""
            self.txtOfferPrice.text = ""
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
}
    func changeLanguage(strLanguage:String) {
       // self.txtView.text = ""
       
        self.txfSearch.placeholder = "Search".LocalizableString(localization: strLanguage)
            self.lblPostProductLoc.text = "Post_Product".LocalizableString(localization: strLanguage)
            self.lblSubCategoryLoc.text = "Subcategory".LocalizableString(localization: strLanguage)
            self.lblWhatareyousellingPriceLoc.text = "WhatareYouSelling".LocalizableString(localization: strLanguage)
           // self.lblConditionLoc.text = "add_Condition".LocalizableString(localization: strLanguage)
            self.lblPickUpLoc.text = "post_Location".LocalizableString(localization: strLanguage)
            self.lblOriginalPriceLoc.text = "OriginalPrice".LocalizableString(localization: strLanguage)
            self.lblDiscountLoc.text = "Discount".LocalizableString(localization: strLanguage)
            self.lblOfferPriceLoc.text = "OfferPrice".LocalizableString(localization: strLanguage)
           
           // self.btnAddnewAddress.setTitle("AddNewAddress".LocalizableString(localization: strLanguage), for: .normal)
            self.btnSellNow.setTitle("SellNow".LocalizableString(localization: strLanguage), for: .normal)
            self.lblSameAsRagisteredAddress.text = "Same_as_the_ragistered".LocalizableString(localization: strLanguage)
            self.lblNewAddress.text = "AddNewAddress".LocalizableString(localization: strLanguage)
           //self.txtView.placeholder = "Descriptions".LocalizableString(localization: strLanguage)
           self.txtSubCategory.placeholder = "Choose".LocalizableString(localization: strLanguage)
           self.txtWhatareYouSelling.placeholder = "Enter".LocalizableString(localization: strLanguage)
         //  self.txtCondition.placeholder = "Enter".LocalizableString(localization: strLanguage)
           self.txtOriginalPrice.placeholder = "Enter".LocalizableString(localization: strLanguage)
           self.txtDiscount.placeholder = "Calculate_Discount".LocalizableString(localization: strLanguage)
         //  self.txtView.textColor = UIColor.hexStringToUIColor(hex: "#C0C8DE")
        
      //  print(self.txtView.placeholder )
        
        }
    @IBAction func btnLeftArrowAction(_ sender: Any) {
     // self.btnGreaterThan.isHidden = true
        // let collectionBounds = self.collectionCategory.bounds
        let contentOffset = CGFloat(floor(self.collectionCategory.contentOffset.x - collectionCategory.frame.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)

    }
    @IBAction func btnRightArrowAction(_ sender: Any) {

        //self.btnLessThan.isHidden = true
       // let collectionBounds = self.collectionCategory.bounds
        let contentOffset = CGFloat(floor(self.collectionCategory.contentOffset.x + collectionCategory.frame.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
        self.collectionCategory.reloadData()

    }
    func moveCollectionToFrame(contentOffset : CGFloat) {
        
        let frame: CGRect = CGRect(x : contentOffset ,y : self.collectionCategory.contentOffset.y ,width : self.collectionCategory.frame.width,height : self.collectionCategory.frame.height)
        self.collectionCategory.scrollRectToVisible(frame, animated: true)
        self.collectionCategory.reloadData()
    }
    @objc func someMethod(_ notification: Notification) {
        self.showGuestUser(index: 0, Message: "Please Login Or Register To Continue".LocalizableString(localization: "en"), title: "Pris24", okay: "Okay".LocalizableString(localization: "en"), cancel: "Report_Cancel".LocalizableString(localization: "en"), isPlaceBid: true)
    }
    func showGuestUser(index:Int,Message: String,title:String,okay:String,cancel:String,isPlaceBid:Bool) {
        let commonAlert = GuestUserAlertViewController()
       // commonAlert.delegate = self
        //commonAlert.index = index
       // commonAlert.isLoginByPlaceBid = isPlaceBid
        commonAlert.ShowAlertWhenUserNotExist(title: title, message: Message, vc: self, Okay: okay, Cancel: cancel)
    }
    @IBAction func btnFilter_Action(_ sender: UIButton) {
        self.popUpFilter(isAnimated: true)
    }
    func popUpFilter(isAnimated:Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
         let popup : FilterVC = pop.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        popup.delagate = self
        self.presentOnRoot(with: popup, isAnimated: isAnimated)
    }
    func clearAllDataViewController()  {
       
        
        if appDelegate.IntCameraTag == 0  {
            self.imageArray = [["png":UIImage(),"type":"image","uploadfile":"product_image[]","isselected":"no","url":"","productId":"0"]]
        } else{
            
        }
        
        
        print(self.txtView.text)
        self.isCategorySelected = true
       
        self.txtSubCategory.text = ""
        self.txtWhatareYouSelling.text = ""
        //self.txtCondition.text = ""
        self.txtOriginalPrice.text = ""
        self.txtOfferPrice.text = ""
        self.txtDiscount.text = ""
        self.txtView.text = ""
        self.txtSearch.text = ""
        self.lblAddress.text = ""
       // self.txtView.placeholder = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
          //  self.txtView.placeholder = "Descriptions".LocalizableString(localization: "en")
           
            PLACEHOLDER = "Descriptions".LocalizableString(localization: "en")
            self.txtView.textColor = UIColor.hexStringToUIColor(hex: "C0C8DE")
            
            self.changeLanguage(strLanguage: "en")
        } else{
            PLACEHOLDER = "Descriptions".LocalizableString(localization: "da")
            self.txtView.textColor = UIColor.hexStringToUIColor(hex: "C0C8DE")
            self.changeLanguage(strLanguage: "da")
        }
        
        self.txtView.text = PLACEHOLDER
        self.arraypropertry.removeAll()
        self.arraypropertryValue.removeAll()
        self.arraypropertry = [[String:Any]]()
        self.arraypropertryValue = [[String:Any]]()
        self.txtView.resignFirstResponder()
        self.tblView.reloadData()
        self.collectionProductImage.reloadData()
    }
    
    func callServiceGetCategory() {
                    var loading = ""
                    if (MyDefaults().language ?? "") as String ==  "en"{
                        loading = "Loading".LocalizableString(localization: "en")
                    } else{
                            loading = "Loading".LocalizableString(localization: "da")
                        }
         let parameter: [String: Any] = ["language": MyDefaults().language ?? AnyObject.self]
            print(parameter)
        HTTPService.callForPostApi(url:getCategoryAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                                 let response = ModelCategory.init(fromDictionary: response as! [String : Any])
                                 self.categoryData = response.categoryData
                            for n in 0...self.categoryData.count {
                                if n == 0 {
                                    self.categoryId = self.categoryData[0].id
                                }
                            }
                            
                                 self.collectionCategory.reloadData()
                        } else if status == 500 {
                                self.showErrorPopup(message: message, title: ALERTMESSAGE)
                        }
                        }else{
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
                
        }
    }
    func callServiceGetgetSubCategory() {
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
        print(MyDefaults().language ?? AnyObject.self)
        
        let parameter: [String: Any] = ["language": MyDefaults().language ?? AnyObject.self,
                                         "category_id":self.categoryId]
        print(parameter)
        HTTPService.callForPostApi(url:getSubCategory , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                                 let response = ModelSubCategory.init(fromDictionary: response as! [String : Any])
                            self.subcategoryData = response.subcategoryData
                            self.popUpPlaceBid()
                        } else if status == 500 {
                                
                                self.showErrorPopup(message: message, title: ALERTMESSAGE)
                        }
                        }else{
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
                
        }
    }
    func callServiceSubmitAPI() {
      
        //self.imageArray = [["png":UIImage(),"type":"image","uploadfile":"product_image[]","isselected":"no","url":"","productId":"0"]]
       // print(self.txtView.text)
        
        var decriptiontxtView = ""
           if self.txtView.textColor == UIColor.hexStringToUIColor(hex: "#C0C8DE") {
               decriptiontxtView = ""
           } else{
               decriptiontxtView = self.txtView.text
           }
        
        
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Your_Auction_is_being_Created".LocalizableString(localization: "en")
                  } else{
                      loading = "Your_Auction_is_being_Created".LocalizableString(localization: "da")
                  }
        
            let array = self.txtDiscount.text?.components(separatedBy: " %")
            print(self.arraypropertry)
            
        var propertyId = [String]()
        var propertyname = [String]()
        var propertyValue = [String]()
        
        
        for dict in self.arraypropertry {
            print(dict)
            let strId = dict["id"]
            let strPropertyname = dict["propertyname"]
            let strPropertyValue = dict["propertyValue"]
            
            propertyId.append(strId as! String)
            propertyname.append(strPropertyname as! String)
            propertyValue.append(strPropertyValue as! String)
        }
        
        print(LoggedInUser.shared.latitude)
        print(LoggedInUser.shared.longitude)
        
            let discount = array?[0]
                var latitudeLocal = ""
                var longitudeLocal = ""
                   
               if self.isAddressSelected == true {
                            
                latitudeLocal = "\(self.latitude)"
                longitudeLocal = "\(self.longitude)"
               }else{
                latitudeLocal = LoggedInUser.shared.latitude!
                longitudeLocal = LoggedInUser.shared.longitude!
               }
//
        latitudeLocal = "\(self.latitude)"
        longitudeLocal = "\(self.longitude)"
         let parameter: [String: Any] = ["language": MyDefaults().language ?? AnyObject.self,
                                         "user_id": LoggedInUser.shared.id as AnyObject,
                                         "category_id":self.categoryId,
                                         "subcategory_id":self.subCategoryId,
                                         "selling":self.txtWhatareYouSelling.text!,
                                         "base_price":self.txtOriginalPrice.text!,
                                         "offer_price":self.txtOfferPrice.text!,
                                         "discount": discount ?? AnyObject.self,
                                         "brand":self.txtOfferPrice.text!,
                                         "description":decriptiontxtView,
                                         "address":MyDefaults().myDefaultAddress ?? "",
                                         "latitude":latitudeLocal,
                                         "lognitute":longitudeLocal,
                                         "property_id":propertyId.joined(separator: ","),
                                         "property_name":propertyname.joined(separator: ","),
                                         "property_value":propertyValue.joined(separator: ","),
                                         "address_type":addressType,
                                         ]
        print(parameter)
        HTTPService.uploadimage(url: getPosProductAPI, imageToUpload: self.imageArray, authtoken: "", showHud: true, text: loading, VC: self, parameters: parameter) { (response) in
            debugPrint(response)
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                            let response = ModelAddpost.init(fromDictionary: response as! [String : Any])
                            //self.navigationController?.backToViewController(viewController: AddPostVC.self)
                           // self.txtView.text = ""
                            self.productData = response.productData
                            print(shareAuction + self.productData.id)
                            self.popUpShare(url:shareAuction + self.productData.id)
                            
                            //self.showErrorPopup(message: message, title: ALERTMESSAGE)
                        } else if status == 500 {
                                
                                self.showErrorPopup(message: message, title: ALERTMESSAGE)
                        }
                        }else{
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
            }
       
    
    
    }
    
    func popUpPlaceBid()  {
        let obj = self.subcategoryData
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
        let popup : AddPostEditPopVC = pop.instantiateViewController(withIdentifier: "AddPostEditPopVC") as! AddPostEditPopVC
        popup.subcategoryData = self.subcategoryData.reversed()
        popup.delegate = self
        self.presentOnRoot(with: popup, isAnimated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    func popUpShare(url:String)  {
     print(url)
        self.tabBarController?.tabBar.isHidden = true
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
        let popup : SharePopUpVC = pop.instantiateViewController(withIdentifier: "SharePopUpVC") as! SharePopUpVC
         popup.shareLink = url
        popup.delagate = self
        self.presentOnRoot(with: popup, isAnimated: true)
    }
    @IBAction func actionOnOffrPrice(_ Sender:Any){
         
        if (MyDefaults().language ?? "") as String ==  "en"{
            Util.showAlertWithMessage("What_did_the_item_cost_from_new?_For_used_item.Enter_estimated_price.".LocalizableString(localization: "en"), title: "Alert".LocalizableString(localization: "en"));return
            } else{
            Util.showAlertWithMessage("What_did_the_item_cost_from_new?_For_used_item.Enter_estimated_price.".LocalizableString(localization: "da"), title: "Alert".LocalizableString(localization: "en"));return
        }
    }
    @IBAction func actionOnOriginalprice(_ Sender:Any){
       
        if (MyDefaults().language ?? "") as String ==  "en"{
            Util.showAlertWithMessage("Your_minimum_price_to_start_your_auction._You_are_not_obligated_to_sell_regardless_of_bid".LocalizableString(localization: "en"), title: "Alert".LocalizableString(localization: "en"));return
        } else{
            Util.showAlertWithMessage("Your_minimum_price_to_start_your_auction._You_are_not_obligated_to_sell_regardless_of_bid".LocalizableString(localization: "da"), title: "Alert".LocalizableString(localization: "en"));return
        }
    }
    
    @IBAction func actionOnSameRegisterAddress(_ Sender:Any){
        self.imgSameAsRagisteredAddress.image = UIImage.init(named: "radio_active")
        self.imgNewAddress.image = UIImage.init(named: "radio")
        self.btnAddnewAddress.isSelected = false
        addressType = "0"
        self.lblAddress.text = ""
    }
    @IBAction func actionOnValidationImagArreyImpty(_ Sender:Any){
      
        if imageArray.count >= 1 {
            self.collectionProductImage.reloadData()
            self.isImageCollectionSelected = true
        }else{
           self.isImageCollectionSelected = false
        }
    }
    @IBAction func actionOnAddNewAddress(_ Sender:Any){
        
        self.isAddressSelected = true
        addressType = "1"
        self.imgSameAsRagisteredAddress.image = UIImage.init(named: "radio")
        self.imgNewAddress.image = UIImage.init(named: "radio_active") 
      
        self.btnAddnewAddress.isSelected = true
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    @IBAction func actionOnSubmit(_ Sender:Any){
        if  isConnectedToInternet() {
             if isRequiredFieldValid(){
                 self.callServiceSubmitAPI()
               
                }
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    @IBAction func actionOnSubCategory(_ Sender:Any){
        if imageArray.count == 1 {
            self.collectionProductImage.reloadData()
            self.isImageCollectionSelected = true
        } else{
            self.callServiceGetgetSubCategory()
        }
    }
    
    @IBAction func actionOnDiscount(_ Sender:Any){
        self.calculateDiscount()
        
    }
    
//   @IBAction func actionOnBack(_ Sender:Any){
//          self.navigationController?.popViewController(animated: true)
//      }
      
}
// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension AddPostVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.collectionProductImage == collectionView {
            return self.imageArray.count
        }else{
            return self.categoryData.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        //Where elements_count is the count of all your items in that
        //Collection view...
       
        if collectionView == self.collectionProductImage {
            let cellCount = CGFloat(self.imageArray.count)

        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing

            //20.00 was just extra spacing I wanted to add to my cell.
            let totalCellWidth = cellWidth*cellCount + 8.00 * (cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.

                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
            }
        }
        return UIEdgeInsets.zero
        } else{
            return UIEdgeInsets.zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.collectionProductImage == collectionView {
            let cell: AddPostProductImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostProductImageCollectionViewCell", for: indexPath) as! AddPostProductImageCollectionViewCell
           
            if isImageCollectionSelected == false {
            
                let dict = self.imageArray[indexPath.row]
                if dict["type"] as! String == "url" {
                if dict["isselected"] as? String == "yes"{
                     cell.imgView.image = dict["png"] as? UIImage
                    cell.configureCellImageCategory(cell: cell, image: dict["url"] as! String)
                   // cell.imgView.transform = CGAffineTransform(scaleX: -1, y: 1)
                    cell.btnCross.isHidden = false
                    cell.imgView.contentMode = .scaleAspectFill
                }else{
                     cell.imgView.image = dict["png"] as? UIImage
                     cell.imgView.image = UIImage.init(named: "camerablack")
                     cell.btnCross.isHidden = true
                    cell.imgView.contentMode = .scaleToFill
                }
            }else{
                if dict["isselected"] as? String == "yes"{
                     cell.imgView.image = dict["png"] as? UIImage
                    //cell.imgView.transform = CGAffineTransform(scaleX: -1, y: 1)
                    cell.btnCross.isHidden = false
                    cell.imgView.contentMode = .scaleAspectFill
                    
                }else{
                     cell.imgView.image = dict["png"] as? UIImage
                     cell.imgView.image = UIImage.init(named: "camerablack")
                     cell.btnCross.isHidden = true
                    cell.imgView.contentMode = .scaleToFill
                }
            }
            cell.btnUpload.tag = indexPath.item
            cell.btnUpload.addTarget(self, action: #selector(didTapOnCamare(_:)), for: .touchUpInside)
            cell.btnCross.tag = indexPath.item
            cell.btnCross.addTarget(self, action: #selector(didTapOnCross(_:)), for: .touchUpInside)
            }else{
           
                let animation = CABasicAnimation(keyPath: "transform")
                var tr = CATransform3DIdentity
                tr = CATransform3DScale(tr, 0.01, 0.01, 1);
                animation.toValue = NSValue(caTransform3D: tr)
                cell.viewBG.layer.add(animation, forKey: "transform")
           
//                let xPosition = cell.viewBG.frame.origin.x
//                    let yPosition = cell.viewBG.frame.origin.y - 80 // Slide Up - 20px
//
//                    let width = cell.viewBG.frame.size.width
//                    let height = cell.viewBG.frame.size.height
//
//                UIView.animate(withDuration: 0.3, animations: {
//                        cell.viewBG.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
//                    })
            
            
            
            
            }
                return cell
                
            
        }else{
            let cell: EditPostCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditPostCollectionViewCell", for: indexPath) as! EditPostCollectionViewCell
            cell.lblCategoryName.text = self.categoryData[indexPath.row].categoryName.uppercased()
           
//                if self.categoryData[indexPath.row].isSeleted == true {
//                    self.categoryData[indexPath.row].isSeleted = false
//                    cell.imgView.layer.borderWidth = 4.0
//                    cell.imgView.layer.borderColor = UIColor.hexStringToUIColor(hex: "#143649").cgColor
//                    cell.lblCategoryName.textColor = UIColor.hexStringToUIColor(hex: "#143649")
//                    cell.reloadCategoryData(categoryImage: self.categoryData[indexPath.row].categoryImage, isSelected: true)
//                }else{
//
//               if isCategorySelected == true && indexPath.item == 0 {
//                self.categoryId = self.categoryData[indexPath.row].id
//                    cell.reloadCategoryData(categoryImage: self.categoryData[indexPath.row].categoryImage, isSelected: true)
//                    cell.imgView.layer.borderWidth = 4.0
//                    cell.imgView.layer.borderColor = UIColor.hexStringToUIColor(hex: "#143649").cgColor
//                    cell.lblCategoryName.textColor = UIColor.hexStringToUIColor(hex: "#143649")
//
//               } else{
//
//                    self.categoryData[indexPath.row].isSeleted = false
//                    cell.reloadCategoryData(categoryImage: self.categoryData[indexPath.row].categoryImage, isSelected: true)
//                    cell.imgView.layer.borderWidth = 4.0
//                    cell.imgView.layer.borderColor = UIColor.hexStringToUIColor(hex: "FFFFFF").cgColor
//                    cell.lblCategoryName.textColor = UIColor.hexStringToUIColor(hex: "FFFFFF")
//
//               }
//            }
               
            if self.categoryId == self.categoryData[indexPath.row].id {
                cell.reloadCategoryData(categoryImage: self.categoryData[indexPath.row].categoryImage, isSelected: true)
                cell.imgView.layer.borderWidth = 4.0
                cell.imgView.layer.borderColor = UIColor.hexStringToUIColor(hex: "#143649").cgColor
                cell.lblCategoryName.textColor = UIColor.hexStringToUIColor(hex: "#143649")
            }else {
                self.categoryData[indexPath.row].isSeleted = false
                cell.reloadCategoryData(categoryImage: self.categoryData[indexPath.row].categoryImage, isSelected: true)
                cell.imgView.layer.borderWidth = 4.0
                cell.imgView.layer.borderColor = UIColor.hexStringToUIColor(hex: "FFFFFF").cgColor
                cell.lblCategoryName.textColor = UIColor.hexStringToUIColor(hex: "FFFFFF")
            }
            
            
            
            cell.btnCategory.tag = indexPath.item
                cell.btnCategory.addTarget(self, action: #selector(didTapOnCategory(_:)), for: .touchUpInside)
           
            return cell
       }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
     
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.categoryData.count - 1 {
            // Last cell is visible
            self.btnLessThan.isHidden = false
            self.btnGreaterThan.isHidden = true
        } else{
            self.btnLessThan.isHidden = true
            self.btnGreaterThan.isHidden = false
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.collectionProductImage == collectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
       
            let size:CGFloat = (collectionView.frame.size.width - space) / 4.0
            return CGSize(width: size, height: 72.0)
            
            
        }else{
             let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
             let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
             let size:CGFloat = (collectionView.frame.size.width - space) / 5
            return CGSize(width: size, height: 112.0)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 6.0
//    }
    private func isRequiredFieldValid() -> Bool {
           
               let originalPrice = Int(txtOriginalPrice.text ?? "") ?? 0
               let offerPrice = Int(txtOfferPrice.text ?? "") ?? 0
             
              if !Util.isValidString(txtOriginalPrice.text!) {
                   
                
                if (MyDefaults().language ?? "") as String ==  "en"{
                    Util.showAlertWithMessage("Please_enter_original_price".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en"))
                }else{
                    Util.showAlertWithMessage("Please_enter_original_price".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da"))
                }
                
               return false
               } else if originalPrice <= 100 {
                if (MyDefaults().language ?? "") as String ==  "en"{
                    Util.showAlertWithMessage("Original_price_should_be_greater_than_100".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en"));
                } else{
                    Util.showAlertWithMessage("Original_price_should_be_greater_than_100".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da"));
                }
                
                
               return false
               }
              else if !Util.isValidString(txtOfferPrice.text!) {
                   
                if (MyDefaults().language ?? "") as String ==  "en"{
                    Util.showAlertWithMessage("Please_enter_offer_price".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en"));
                } else{
                    Util.showAlertWithMessage("Please_enter_offer_price".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da"));
                }
               return false
               }
              
//              else if offerPrice >= originalPrice {
//                   if (MyDefaults().language ?? "") as String ==  "en"{
//                    Util.showAlertWithMessage("Offer_Price_less_than_original_price".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en"));
//                } else{
//                    Util.showAlertWithMessage("Offer_Price_less_than_original_price".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da"));
//                }
//                return false
//               }
              else if !Util.isValidString(txtWhatareYouSelling.text!) {
                  
                if (MyDefaults().language ?? "") as String ==  "en"{
                    Util.showAlertWithMessage("Please_enter_what_are_you_selling".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en"));
                } else{
                    Util.showAlertWithMessage("Please_enter_what_are_you_selling".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da"));
                }
               return false
               } else if !Util.isValidString(txtSubCategory.text!) {
                  
                if (MyDefaults().language ?? "") as String ==  "en"{
                    Util.showAlertWithMessage("Please_enter_sub_category".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en"));
                } else{
                    Util.showAlertWithMessage("Please_enter_sub_category".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da"));
                }
               return false
               }
//              else if !Util.isValidString(txtCondition.text!) {
//
//                if (MyDefaults().language ?? "") as String ==  "en"{
//                    Util.showAlertWithMessage("Please_enter_condiotion".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en"));
//                } else{
//                    Util.showAlertWithMessage("Please_enter_condiotion".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da"));
//                }
//           return false
//   //           } else if !Util.isValidString(txtView.text!) {
//   //                Util.showAlertWithMessage("Please enter condiotion".localiz(), title: Key_Alert)
//   //            return false
//                  }
           self.calculateDiscount()
           return true
       }
    private func calculateDiscount() {
               
            var originalPrice = 0.0
            var offerPrice = 0.0

        if Util.isValidString(txtOriginalPrice.text!) && Util.isValidString(txtOfferPrice.text!) {
                    
            originalPrice = Double(txtOriginalPrice.text ?? "") ?? 0.0
            offerPrice = Double(txtOfferPrice.text ?? "") ?? 0.0

                print("offerPrice",offerPrice)
                print("originalPrice",originalPrice)
                
            if originalPrice >= 100 {
           
                if offerPrice >= 100 {
                    
                    if originalPrice >= offerPrice {
                            let value = calculatePercentage(value: originalPrice,percentageVal: offerPrice)
                            let final = String(value)
                            let words = final.components(separatedBy: ".")
                            //   let totalDiscount  =   String(format: " %.2f", words)
                            self.txtDiscount.text = words[0] + " % "
                        
                        }
                    else{
                            self.txtOfferPrice.text = ""
                            self.txtOriginalPrice.text = ""
                            self.txtDiscount.text = ""
                            self.txtOriginalPrice.becomeFirstResponder()
                          if (MyDefaults().language ?? "") as String ==  "en"{
                                self.EnterCanNotZero(title: "", message: "original_price_small_error".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "en"))
                            } else{
                                self.EnterCanNotZero(title: "", message: "original_price_small_error".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "da"))
                            }
                            
                            
                }
                }  else{
                    
                    if (MyDefaults().language ?? "") as String ==  "en"{
                        self.lessThanhundrard(title: "", message: "Offer_price_should_be_greater_than_100".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "en"))
                    } else{
                        self.lessThanhundrard(title: "", message: "Offer_price_should_be_greater_than_100".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "da"))
                    }
            }
                
         
                
            } else{
                
                if (MyDefaults().language ?? "") as String ==  "en"{
                    self.lessThanhundrard(title: "", message: "Original_price_should_be_greater_than_100".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "en"))
                } else{
                    self.lessThanhundrard(title: "", message: "Original_price_should_be_greater_than_100".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "da"))
                }
        }
        
        }
            }
    func lessThanhundrard(title:String, message:String,Okay:String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Okay, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.txtOriginalPrice.text = ""
            self.txtOfferPrice.text = ""
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
}
   
    
}
extension AddPostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate,getSelectAddtPostPopUpSubCategory,getSelectAddPostEditProperty,getShare,alertpopUpDelegate,alertDelegate,getSelectMapCoordinate {
    
    
    func delegatSelectCodinateofMap(latitude: String, longitude: String, distance: String, isMapSelected: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    func okAction(controller: UIViewController, index: Int) {
        self.dismiss(animated: true, completion: nil)
    }
    func cancelAction(controller: UIViewController) {
        
    }
    func okActionPopUp(controller: UIViewController, index: Int, VC: String) {
       // self.showMessage(index: index, Message: "You Can change every fields that needed", title: "Duplicate Auction")
        
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.actionRefreshViewController(title: "Duplicate_Auction".LocalizableString(localization: "en"), message: "You_can_change_every_fields_that_needed".LocalizableString(localization: "en"), cancel: "Report_Cancel".LocalizableString(localization: "en"), ok: "Okay".LocalizableString(localization: "en"))
        } else{
            self.actionRefreshViewController(title: "Duplicate_Auction".LocalizableString(localization: "da"), message: "You_can_change_every_fields_that_needed".LocalizableString(localization: "da"), cancel: "Report_Cancel".LocalizableString(localization: "da"), ok: "Okay".LocalizableString(localization: "da"))
        }
        
    }
    func actionRefreshViewController(title:String,message:String, cancel:String, ok:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            // Create the actions
        let okAction = UIAlertAction(title: ok, style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
//        let cancelAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel) {
//                UIAlertAction in
//                NSLog("Cancel Pressed")
//            }

            // Add the actions
            alertController.addAction(okAction)
          //  alertController.addAction(cancelAction)

            // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func cancelActionPopUp(controller: UIViewController) {
        
       // self.tabBarController?.delegate = self
//            guard let vc = self.navigationController?.viewControllers else {return }
//              for controller in vc {
//                  if controller.isKind(of: HomeVC.self) {
//                      let tabVC = controller as! TabBarVC
//                      tabVC.selectedIndex = 0
//                self.navigationController?.popToViewController(tabVC, animated: true)
//                }
//        }
//       let mainTabBarController = storyBoard.ZoomTab.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//
//        let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
//        if let aVc = vc {
//                self?.present(aVc, animated: true, completion: nil)
//                }
//        })
//        let viewControllers = (self.navigationController?.viewControllers)! as NSArray // app crashes here
//        let rootViewController = viewControllers.object(at: 0) as! TabBarVC
//              
//        rootViewController.selectedIndex = 0
  
        self.tabBarController?.selectedIndex = 0
    }
    func showMessage(index:Int,Message: String,title:String) {
        let commonAlert = CommonAlertViewController()
        commonAlert.delegate = self
        commonAlert.index = 0
        commonAlert.showActionAlertView(title: title, message: Message, vc: self)
    }
    
    func delegatShare(shareLink:String){
        self.tabBarController?.tabBar.isHidden = false
        
        let message = "Message goes here."
        //Set the link to share.
        if let link = NSURL(string: shareLink)
        {
            let objectsToShare = [link]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            
            activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                if !completed {
                    // User canceled
                    return
                }
                // User completed activity
            
                self.tabBarController?.selectedIndex = 0
            }
            self.present(activityVC, animated: true, completion: nil)
        }
       
    }
    func delegatShareCancel(){
        self.tabBarController?.tabBar.isHidden = false
        let commonAlert = CommonPopupAlert()
        commonAlert.delegate = self
        // commonAlert.index = index
        commonAlert.indexSelection = 900
        commonAlert.viewContolls = "duplicate"
        
        if (MyDefaults().language ?? "") as String ==  "en"{
            commonAlert.showAlertPopUp(title: "Duplicate_Auction".LocalizableString(localization: "en"), message: "Do_you_want_to_create_another_auction_now?".LocalizableString(localization: "en"), vc: self)
        } else{
            commonAlert.showAlertPopUp(title: "Duplicate_Auction".LocalizableString(localization: "da"), message: "Do_you_want_to_create_another_auction_now?".LocalizableString(localization: "da"), vc: self)
        }
       
    }
    
    func delegatSelectAddPostSubCategory(Model:ModelSubcategoryDatum,index:Int) {
        self.tabBarController?.tabBar.isHidden = false
        self.isCategorySelected = false
        
        self.subcategoryData = [ModelSubcategoryDatum]()
        self.subcategoryData.append(Model)
        self.tblView.reloadData()
        self.subCategoryId = Model.id

        self.txtSubCategory.text = Model.subcategoryName as String
        self.arraypropertryValue = [[String:Any]]()

        self.arraypropertry = [[String:Any]]()
       
        for items in Model.propertyName {
           
            var dict = [String:Any]()

            dict["category"] = items.category
            dict["createdat"] = items.createdAt
            dict["id"] = items.id
            self.propertyId = items.id
            dict["propertyname"] = items.propertyName
            dict["propertyValue"] = "Select"
            dict["status"] = items.status
            dict["subcategory"] = items.subcategory
            self.arraypropertry.append(dict)
        }
        for items in Model.propertyName {
           
            var dict = [String:Any]()

            dict["category"] = items.category
            dict["createdat"] = items.createdAt
            dict["id"] = items.id
            self.propertyId = items.id
            dict["propertyname"] = items.propertyName
            dict["propertyValue"] = items.propertyValue
            dict["status"] = items.status
            dict["subcategory"] = items.subcategory
            self.arraypropertryValue.append(dict)
        }
//    if self.arraypropertry.count > 0 {
//            self.viewTopConstrant.constant = 0
//        }else{
//             self.viewTopConstrant.constant = 12
//        }
         self.tblView.reloadData()
    }
    func delegatSelectAddPostEditProperty(dict: [String : Any], index: Int) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        print(dict)
        self.isPropertySet = false
       // self.arraypropertry = [[String:Any]]()
        
        var dictValue = [String:Any]()
//            dictValue["subcategory"] = dict["subcategory"] as! String
//            dictValue["category"] = dict["category"] as! String
//            dictValue["id"] = dict["id"] as! String
//            dictValue["propertyname"] = dict["propertyname"] as! String
//            dictValue["createdat"] = dict["createdat"] as! String
           // dictValue[index]["propertyValue"] = dict["propertyValue"] as! String
       // dictValue.updateValue("propertyValue", forKey: dict["propertyValue"] as! String)
       // self.arraypropertry.append(dictValue)
      //  self.arraypropertry[index] = dictValue
        self.arraypropertry[index]["propertyValue"] = dict["propertyValue"] as! String
        print(self.arraypropertry)
        self.tblView.reloadData()
       
    }
    func delegatcancelAddPostEditProperty(){
        self.dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
    }
    func delegatcancelAddPostSubCategory(){
        self.dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func didTapOnCamare(_ sender: UIButton) {
        if self.imageArray.count < 4 {
            self.showSimpleActionSheet(controller: self, tagValue: 0)
        }else{
            
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("you_can_upload_3_photo".LocalizableString(localization: "en"), title: ""); return
            } else {
                Util.showAlertWithMessage("you_can_upload_3_photo".LocalizableString(localization: "da"), title: ""); return
            }
        }
    }
    @objc func didTapOnCross(_ sender: UIButton) {

//        let indexPath = IndexPath(item: sender.tag, section: 0)
//                     self.collectionProductImage.reloadItems(at: [indexPath])
        
            let dict = self.imageArray[sender.tag]
            if dict["isselected"] as! String == "yes" {
                if self.imageArray.count == 2 {
                    self.isImageCollectionSelected = false
                    self.btnBg.isHidden = false
                 //   self.collectionCategoryTraling.constant = 8
                }
                
                self.imageArray.remove(at: sender.tag)
            }else{
                self.isImageCollectionSelected = false
                self.btnBg.isHidden = false
            }
        
        self.collectionProductImage.reloadData()
              
    }
    @objc func didTapOnCategory(_ sender: UIButton) {
        self.arraypropertry = [[String:Any]]()
        if self.categoryData[sender.tag].isSeleted == false {
               self.categoryData[sender.tag].isSeleted = true
               isCategorySelected = false
                self.txtSubCategory.text = ""
               self.categoryId = self.categoryData[sender.tag].id
           }else{
               self.categoryData[sender.tag].isSeleted = false
            }
        self.tblView.reloadData()
        self.collectionCategory.reloadData()
    
//        let indexPath = IndexPath(item: sender.tag, section: 0)
//        self.collectionCategory.reloadItems(at: [indexPath])
    }
    
    func showSimpleActionSheet(controller: UIViewController,tagValue:Int) {
      
        
        if (MyDefaults().language ?? "") as String ==  "en"{
            let alert = UIAlertController(title: "Pris24", message: "Please_Select_an_Option".LocalizableString(localization: "en"), preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera".LocalizableString(localization: "en"), style: .default, handler: { (_) in
                self.getImage(fromSourceType: .camera)
            }))
            alert.addAction(UIAlertAction(title: "Gallery".LocalizableString(localization: "en"), style: .default, handler: { (_) in
                self.getImage(fromSourceType: .photoLibrary)
            }))
            alert.addAction(UIAlertAction(title: "Dismiss".LocalizableString(localization: "en"), style: .destructive, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        } else{
            let alert = UIAlertController(title: "Pris24", message: "Please_Select_an_Option".LocalizableString(localization: "da"), preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera".LocalizableString(localization: "da"), style: .default, handler: { (_) in
                self.getImage(fromSourceType: .camera)
            }))
            alert.addAction(UIAlertAction(title: "Gallery".LocalizableString(localization: "da"), style: .default, handler: { (_) in
                self.getImage(fromSourceType: .photoLibrary)
            }))
            alert.addAction(UIAlertAction(title: "cancel_bid".LocalizableString(localization: "da").capitalizingFirstLetter(), style: .destructive, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        
        }
    }
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            // isUploadPhoto = true
            self.present(imagePickerController, animated: true, completion: nil)
            
        }}
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenImage = info[.originalImage] as? UIImage{
            //self.imgViewMeeting.image = chosenImage
          //  self.imageArray = [[String:Any]]()
            var dict = [String:Any]()
            dict ["uploadfile"] = "product_image[]"
            dict ["type"] = "image"
            dict ["png"] = chosenImage
            dict["isselected"] = "yes"
            
            
            self.imageArray.append(dict)
            //self.imageArray.reverse()
            self.isImageCollectionSelected = false
            self.btnBg.isHidden = true
            appDelegate.IntCameraTag = 100
            print(imageArray.count)

            
            picker.dismiss(animated: true, completion: nil)
        }
        self.collectionProductImage.reloadData()
    }
}
extension AddPostVC: UITextViewDelegate,UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.hexStringToUIColor(hex: "#C0C8DE") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = PLACEHOLDER
            textView.textColor = UIColor.hexStringToUIColor(hex: "#C0C8DE")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("did")
//        if self.nextButton.isEnabled {
//            print("did")
//          //  self.performSegue(withIdentifier: "nextStep", sender: nil)
//        }

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let previousText:NSString = textField.text! as NSString
        let updatedText = previousText.replacingCharacters(in: range, with: string)
        print("updatedText > ", updatedText)
        if textField == self.txtOriginalPrice {
        
            if updatedText >= "" {
                self.txtDiscount.text = ""
                self.txtOfferPrice.text = ""
            }
        }
      return true
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == self.txtDiscount {
//            self.calculateDiscount()
//        }
//    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == self.txtMobileNumber {
//            if self.txtMobileNumber.text == "EX.12345678" {
//                textField.text = ""
//            } else{
//                textField.text = "EX.12345678"
//            }
//
//        }
        if textField == self.txtDiscount {
                   self.calculateDiscount()
               }
    }
    
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//
//        if textField == self.txtOriginalPrice {
//            textField.text = ""
//            self.txtDiscount.text = ""
//            self.txtOfferPrice.text = ""
//            textField.resignFirstResponder()
//        }
//            return false
//    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == self.txtOriginalPrice {
//            self.txtDiscount.text = ""
//            self.txtOfferPrice.text = ""
//        } else {
//            //Do Nothing
//        }
//    }
    
    func textFieldShouldClear (_ textField: UITextField) -> Bool {
       
        
        if textField == self.txtOriginalPrice {
            textField.text = ""
            self.txtDiscount.text = ""
            self.txtOfferPrice.text = ""
            textField.resignFirstResponder()
        }
            return false
    }
    
}
extension  AddPostVC:UITableViewDelegate,UITableViewDataSource{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
//    if isPropertySet == true {
//        return 0
//     }else{
//        return 0
//    }
      
    if arraypropertry.count > 0 {
        return arraypropertry.count
    } else{
        return 0
    }
    
}
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : AddPostTableViewCell?
       cell = tableView.dequeueReusableCell(withIdentifier: "AddPostTableViewCell", for: indexPath) as? AddPostTableViewCell
        
        if arraypropertry.count > 0 {
        let dict = arraypropertry[indexPath.row]
        if dict["propertyValue"] as? String == "Select" {
        
            if (MyDefaults().language ?? "") as String ==  "en"{
                cell?.lblValue.text = "Select".LocalizableString(localization: "en")
            } else{
                cell?.lblValue.text = "Select".LocalizableString(localization: "da")
            }
            cell?.lblName.text = dict["propertyname"] as? String
        
        }else{
            
            cell?.lblValue.text = dict["propertyValue"] as? String
            cell?.lblName.text = dict["propertyname"] as? String
        }
    
        cell?.btnSubCategory.tag = indexPath.row
        cell?.btnSubCategory.addTarget(self, action: #selector(clickOnproperty(sender:)), for: .touchUpInside)
        
    }
    return cell!
}
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
   }
    @objc func clickOnproperty(sender: UIButton){
            
        self.popUpGetProperty(index:sender.tag)
       // self.callServiceProerty(index: sender.tag)
        
      //  print(arraypropertry)
    }
    func popUpGetProperty(index:Int)  {
       
        var arrayProperty = [[String:Any]]()
        
        let dict = self.arraypropertryValue[index]
        
        print(dict)
        
        let Property = dict["propertyValue"] as! String
              
        let getArray = Property.components(separatedBy: ",")
                for items in getArray {
                    var dict = [String:Any]()
                    dict["propertyValue"] = items
                    arrayProperty.append(dict)
                }
        
        
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
        let popup : AddpostEditPropertyPopUp = pop.instantiateViewController(withIdentifier: "AddpostEditPropertyPopUp") as! AddpostEditPropertyPopUp
        popup.arraypropertryValue = arrayProperty.reversed()
        popup.delegate = self
        popup.isCategorySelected = true
        popup.index = index
        self.presentOnRoot(with: popup, isAnimated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func callServiceProerty(index:Int) {
        var loading = ""
          if (MyDefaults().language ?? "") as String ==  "en"{
              loading = "Loading".LocalizableString(localization: "en")
          } else{
              loading = "Loading".LocalizableString(localization: "da")
          }
        let parameter: [String: Any] = ["language": MyDefaults().language ?? AnyObject.self,
                                        "property_id":self.objActiveAuction.productProperty[index]]
           print(parameter)
        HTTPService.callForPostApi(url:getPropertyAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                       debugPrint(response)
                     //  HideHud()
                       if response.count != nil {
                           let status = response["responseCode"] as! Int
                           let message = response["message"] as! String
                           if status == 200  {
                            let response = ModelPropertyObjList.init(fromDictionary: response as! [String : Any])
                            if response.propertyData != nil {
                                self.propertyData = response.propertyData
                             //self.setUI()
                                self.popUpGetProperty(index:index)
                                
                            }
                            } else if status == 500 {
                                   
                                   self.showErrorPopup(message: message, title: ALERTMESSAGE)
                           }
                           }else{
                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                       }
                   
           }
       }

}
    extension AddPostVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
        self.isAddressSelected = true
        forwardGeocoding(address: place.formattedAddress!)
        self.lblAddress.isHidden = false
        self.lblAddress.text = place.formattedAddress!
        addressFull = place.formattedAddress!
        MyDefaults().myDefaultAddress = place.name
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.btnAddnewAddress.setTitle("AddNewAddress".LocalizableString(localization: "en"), for: .normal)
        } else{
            self.btnAddnewAddress.setTitle("AddNewAddress".LocalizableString(localization: "da"), for: .normal)
        }
    }
    
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!)
                return
            }
            let placemarkCount = placemarks?.count
            
            if placemarkCount! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                
                self.latitude = coordinate!.latitude
                self.longitude = coordinate!.longitude
            }
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
      
        self.addressType = "0"
        self.imgSameAsRagisteredAddress.image = UIImage.init(named: "radio_active")
        self.imgNewAddress.image = UIImage.init(named: "radio")
        dismiss(animated: true, completion: nil)
    }
    
}
    class AddPostTableViewCell: UITableViewCell {
        @IBOutlet weak var lblValue : UILabel!
        @IBOutlet weak var lblName : UILabel!
        @IBOutlet weak var btnSubCategory : UIButton!
        
        override func awakeFromNib() {
                super.awakeFromNib()
                // Initialization code
            
        }
        override func setSelected(_ selected: Bool, animated: Bool) {
                super.setSelected(selected, animated: animated)

                // Configure the view for the selected state
            }
        }
class AddPostProductImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btnCross : UIButton!
    @IBOutlet weak var btnUpload : UIButton!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var viewBG : UIView!
    
    func configureCellImageCategory(cell:AddPostProductImageCollectionViewCell,image:String)  {
                   
           if Util.isValidString(image) {
                      let imageUrl = image
                      let url = URL.init(string: imageUrl)
                       cell.imgView.kf.indicatorType = .activity
                       cell.imgView.kf.indicator?.startAnimatingView()
                      let resource = ImageResource(downloadURL: url!)
                      KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                          switch result {
                          case .success(let value):
                              cell.imgView.image = value.image
                          case .failure( _):
                              cell.imgView.image = UIImage(named: "dummy_post")
                          }
                          cell.imgView.kf.indicator?.stopAnimatingView()
                      }
                  }
                  else {
                      cell.imgView.image = UIImage(named: "dummy_post")
                  }
       }
    private func clearFormData() {
            
        
    }
}
extension AddPostVC: UITabBarControllerDelegate,CustomTabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            let tabBarIndex = tabBarController.selectedIndex
            if tabBarIndex == 0 {
                //do your stuff
            }
       }
    func onTabSelected(isTheSame: Bool) {
        print("Tab1ViewController onTabSelected")
        //do something
    }
    
}

