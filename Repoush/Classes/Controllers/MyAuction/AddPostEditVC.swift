//
//  AddPostEditVC.swift
//  Repoush
//
//  Created by mac  on 29/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class AddPostEditVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var collectionProductImage:UICollectionView!
    @IBOutlet weak var collectionCategory:UICollectionView!
    @IBOutlet weak var txtSubCategory:UITextField!
    @IBOutlet weak var txtWhatareYouSelling:UITextField!
   // @IBOutlet weak var txtCondition:UITextField!
    @IBOutlet weak var txtOfferPrice:UITextField!
    @IBOutlet weak var txtDiscount:UITextField!
    @IBOutlet weak var txtOriginalPrice:UITextField!
    @IBOutlet weak var btnSameAsregistered:UIButton!
    @IBOutlet weak var btnAddnewAddress:UIButton!
    @IBOutlet weak var txtView:UITextView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblTitleNav:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    @IBOutlet weak var viewTopConstrant:NSLayoutConstraint!
    
    
    @IBOutlet weak var lblSameAsRagisteredAddress:UILabel!
    @IBOutlet weak var lblNewAddress:UILabel!
    @IBOutlet weak var imgSameAsRagisteredAddress:UIImageView!
    @IBOutlet weak var imgNewAddress:UIImageView!
    var subcategoryData = [ModelSubcategoryDatum]()
    var propertyData : ModelPropertyObjDatum!
    var objActiveAuction : ModelSellerActiveAuctionResponseDatum!
    var categoryData = [ModelCategoryDatum]()
    var arraypropertry = [[String:Any]]()
    
    var arrayProductProperty = [[String:Any]]()
    
    var propertyName = ""
    var propertyValue = ""
    var addressFull = ""
    var addressType = ""
    var titleName = ""
    var propertyId = ""
    var categoryId = ""
    var subCategoryId = ""
    var PLACEHOLDER = "Descriptions( Optional )"
    var isImageVisible = false
    
    var isPropertySet = true
    var isAddressSelected = false
    var imageArray = [["png":UIImage(),"type":"image","uploadfile":"product_image[]","isselected":"no","url":"","imageId":"0"]]
    var productId = ""
    
    private var latitude = 0.0
    private var longitude = 0.0
    
    @IBOutlet weak var lblSubCategoryLoc:UILabel!
    @IBOutlet weak var lblWhatareyousellingPriceLoc:UILabel!
    @IBOutlet weak var lblPickUpLoc:UILabel!
   // @IBOutlet weak var lblConditionLoc:UILabel!
    @IBOutlet weak var lblOriginalPriceLoc:UILabel!
    @IBOutlet weak var lblOfferPriceLoc:UILabel!
    @IBOutlet weak var btnSubMit:UIButton!
    @IBOutlet weak var lblDiscountLoc:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        var objAuction = objActiveAuction
//        print(objAuction)
        
        self.tblView.isHidden = true
        self.txtOfferPrice.addTarget(self, action: #selector(setDiscount), for: .editingChanged)
        self.txtOriginalPrice.addTarget(self, action: #selector(tapOnOriginalPrice), for: .editingChanged)
        self.collectionProductImage.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    @objc func setDiscount(textField: UITextField) {
     
   
        if textField.text == "0" {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.EnterCanNotZero(title: "", message: "price_is_not_start_with_zero".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "en"))
            } else{
                self.EnterCanNotZero(title: "", message: "price_is_not_start_with_zero".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "en"))
            }
        } else {
            if self.txtOfferPrice.text!.count > 0 {
           //  self.calculateDiscount()
        }else{
            self.txtOfferPrice.text = ""
        }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.addressType = "0"
        self.imgSameAsRagisteredAddress.image = UIImage.init(named: "radio_active")
        if  isConnectedToInternet() {
        callServiceGetCategory()
        } else {
        self.showErrorPopup(message: internetConnetionError, title: alert)
           }
        self.setUI()
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
    func setUI() {
        
        let obj = objActiveAuction
        print(obj)
        
        self.txtWhatareYouSelling.text = objActiveAuction.selling.capitalizingFirstLetter()
        //self.txtCondition.text = objActiveAuction.productCondition.capitalizingFirstLetter()
        self.txtOriginalPrice.text = objActiveAuction.basePrice.capitalizingFirstLetter()
        self.txtOfferPrice.text = objActiveAuction.offerPrice
        self.txtDiscount.text = objActiveAuction.discount + " %"
        
        self.lblTitle.text = titleName
        self.txtSubCategory.text = objActiveAuction.subcategoryName.capitalizingFirstLetter()
        self.categoryId = objActiveAuction.categoryId
        self.subCategoryId = objActiveAuction.subcategoryId
        self.latitude = objActiveAuction.latitude.toDouble() ?? 0.0
        self.longitude = objActiveAuction.lognitute.toDouble() ?? 0.0
        if objActiveAuction.descriptionField.isEmpty {
           // self.txtView.text = PLACEHOLDER
           // self.txtView.textColor = UIColor.hexStringToUIColor(hex: "#E4E4E4")
            if (MyDefaults().language ?? "") as String ==  "en"{
               // self.txtView.textColor = UIColor.hexStringToUIColor(hex: "#C0C8DE")
                self.txtView.placeholder = "Descriptions".LocalizableString(localization: "en")
            } else{
                //self.txtView.textColor = UIColor.hexStringToUIColor(hex: "#C0C8DE")
                self.txtView.placeholder = "Descriptions".LocalizableString(localization: "da")
            }
        }else{
            self.txtView.text = objActiveAuction.descriptionField.capitalizingFirstLetter()
            self.txtView.textColor = UIColor.black
            
        }
        
//        for items in objActiveAuction.productProperty {
//            var dict = [String:Any]()
//                dict["createdat"] = items.createdAt
//                dict["id"] = items.id
//                dict["productId"] = items.productId
//                dict["propertyId"] = items.propertyId
//                dict["propertyname"] = items.propertyName
//                dict["propertyValue"] = items.propertyValue
//                self.arrayProductProperty.append(dict)
//            }
        
        
//        if objActiveAuction.productImage.count > 2  {
//            self.imageArray = [[String:Any]]()
//            for items in objActiveAuction.productImage {
//            var dict = [String:String]()
//            dict["png"] = ""
//            dict["url"] = items.productImage
//            dict["imageId"] = items.id
//            dict["type"] = "url"
//            dict["uploadfile"] = "product_image[]"
//            dict["isselected"] = "yes"
//            self.imageArray.append(dict)
//        }
//        } else{
//            for items in objActiveAuction.productImage {
//            var dict = [String:String]()
//            dict["png"] = ""
//            dict["url"] = items.productImage
//            dict["imageId"] = items.id
//            dict["type"] = "url"
//            dict["uploadfile"] = "product_image[]"
//            dict["isselected"] = "yes"
//            self.imageArray.append(dict)
//        }
//        }
        for items in objActiveAuction.productImage {
        var dict = [String:String]()
        dict["png"] = ""
        dict["url"] = items.productImage
        dict["imageId"] = items.id
        dict["type"] = "url"
        dict["uploadfile"] = "product_image[]"
        dict["isselected"] = "yes"
        self.imageArray.append(dict)
        }
        self.arraypropertry = [[String:Any]]()
        for items in objActiveAuction.productProperty {
//            self.propertyValue = items.propertyValue
//            self.propertyName = items.propertyName
//            self.propertyId = items.propertyId
            var dict = [String:Any]()

           // dict["category"] = items.category
            dict["createdat"] = items.createdAt
            dict["id"] = items.id
            dict["propertyid"] = items.propertyId
            dict["productid"] = items.productId
            dict["propertyname"] = items.propertyName
            dict["propertyValue"] = items.propertyValue
            dict["status"] = ""
            dict["subcategory"] = ""
           
            self.arraypropertry.append(dict)
        
        }
        if objActiveAuction.addressType == "0" {
            self.btnSameAsregistered.isSelected = true
            addressType = "0"
            self.imgSameAsRagisteredAddress.image = UIImage.init(named: "radio_active")
            self.imgNewAddress.image = UIImage.init(named: "radio")
        }else{
            self.btnAddnewAddress.isSelected = true
            addressType = "1"
            self.imgNewAddress.image = UIImage.init(named: "radio_active")
            self.imgSameAsRagisteredAddress.image = UIImage.init(named: "radio")
        }
        self.lblAddress.text = objActiveAuction.address
//        if objActiveAuction.productProperty.count > 0 {
//            self.viewTopConstrant.constant = 0
//        }else{
//            self.viewTopConstrant.constant = 12
//        }
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
        self.collectionCategory.reloadData()
    }
    func changeLanguage(strLanguage:String) {
           // self.txfSearch.placeholder = "Search".LocalizableString(localization: strLanguage)
           // self.lblPostProductLoc.text = "PostProduct".LocalizableString(localization: strLanguage)
        
        self.lblTitleNav.text = "Edit_Auction".LocalizableString(localization: strLanguage)
        self.lblSubCategoryLoc.text = "Subcategory".LocalizableString(localization: strLanguage)
        self.lblWhatareyousellingPriceLoc.text = "WhatareYouSelling".LocalizableString(localization: strLanguage)
       // self.lblConditionLoc.text = "Condtion".LocalizableString(localization: strLanguage)
        self.lblOriginalPriceLoc.text = "OriginalPrice".LocalizableString(localization: strLanguage)
        self.lblDiscountLoc.text = "Discount".LocalizableString(localization: strLanguage)
        self.lblOfferPriceLoc.text = "OfferPrice".LocalizableString(localization: strLanguage)
        //self.btnSameAsregistered.setTitle("Sameastheegistered".LocalizableString(localization: strLanguage), for: .normal)
       // self.btnAddnewAddress.setTitle("AddNewAddress".LocalizableString(localization: strLanguage), for: .normal)
        self.btnSubMit.setTitle("SUBMIT".LocalizableString(localization: strLanguage), for: .normal)
    
        self.txtSubCategory.placeholder = "Choose".LocalizableString(localization: strLanguage)
        self.txtWhatareYouSelling.placeholder = "Enter".LocalizableString(localization: strLanguage)
       // self.txtCondition.placeholder = "Choose".LocalizableString(localization: strLanguage)
        self.txtOriginalPrice.placeholder = "Enter".LocalizableString(localization: strLanguage)
        self.txtDiscount.placeholder = "Calculate_Discount".LocalizableString(localization: strLanguage)
        self.lblPickUpLoc.text = "post_Location".LocalizableString(localization: strLanguage)
        self.lblSameAsRagisteredAddress.text = "Same_as_the_ragistered".LocalizableString(localization: strLanguage)
        self.lblNewAddress.text = "AddNewAddress".LocalizableString(localization: strLanguage)
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
        HTTPService.callForPostApi(url:getCategoryAPI , parameter: parameter, authtoken: "", showHud: true, text:loading , VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                            let response = ModelCategory.init(fromDictionary: response as! [String : Any])
                            self.tblView.isHidden = false
                            self.categoryData = response.categoryData
                                 self.collectionCategory.reloadData()
                        } else if status == 500 {
                                
                                self.showErrorPopup(message: message, title: ALERTMESSAGE)
                        }
                        }else{
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
            }
    }
    @IBAction func actionOnDiscount(_ Sender:Any){
        self.calculateDiscount()
        
    }
    
    func callServiceGetgetSubCategory() {
      
        var loading = ""
          if (MyDefaults().language ?? "") as String ==  "en"{
              loading = "Loading".LocalizableString(localization: "en")
          } else{
              loading = "Loading".LocalizableString(localization: "da")
          }
         let parameter: [String: Any] = ["language": MyDefaults().language as AnyObject,
                                         "category_id":self.categoryId]
     //   print(parameter)Decrsiptions( Option )
       
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
     
        var loading = ""
          if (MyDefaults().language ?? "") as String ==  "en"{
              loading = "Loading".LocalizableString(localization: "en")
          } else{
              loading = "Loading".LocalizableString(localization: "da")
          }
        
        let array = self.txtDiscount.text?.components(separatedBy: " %")
        let discount = array?[0]
                var latitudeLocal = ""
                var longitudeLocal = ""
                   
               if self.isAddressSelected == true {
                            latitudeLocal = objActiveAuction.latitude!
                            longitudeLocal = objActiveAuction.lognitute!
               }else{
                            latitudeLocal = "\(self.latitude)"
                            longitudeLocal = "\(self.longitude)"
               }
        
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
        
        print(propertyId)
        print(propertyname)
        print(propertyValue)
        
        let parameter: [String: Any] = ["language": MyDefaults().language ?? AnyObject.self,
                                         "user_id": LoggedInUser.shared.id as AnyObject,
                                         "category_id":self.categoryId,
                                         "subcategory_id":self.subCategoryId,
                                         "selling":self.txtWhatareYouSelling.text!,
                                         
                                         "base_price":self.txtOriginalPrice.text!,
                                         "offer_price":self.txtOfferPrice.text!,
                                         "discount": discount ?? AnyObject.self,
                                         "brand":self.txtOfferPrice.text!,
                                         "description":self.txtView.text!,
                                         "address":MyDefaults().myDefaultAddress ?? "",
                                         "latitude":latitudeLocal,
                                         "lognitute":longitudeLocal,
                                         "property_id":propertyId.joined(separator: ","),
                                         "property_name":propertyname.joined(separator: ","),
                                         "property_value":propertyValue.joined(separator: ","),
                                         "address_type":addressType,
                                         "product_id":objActiveAuction.productId!]
        print(parameter)
        HTTPService.uploadimage(url: getEditProductAPI, imageToUpload: imageArray, authtoken: "", showHud: true, text: loading, VC: self, parameters: parameter) { (response) in
        debugPrint(response)
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                           
                          //  self.navigationController?.backToViewController(viewController: AddPostEditVC.self)
                            // self.showErrorPopup(message: message, title: ALERTMESSAGE)
                            self.alertAfterResponse(title: ALERTMESSAGE, message: message)
                        } else if status == 500 {
                                self.showErrorPopup(message: message, title: ALERTMESSAGE)
                        }
                        }else{
                         self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
            }
        }
    
    func alertAfterResponse(title: String, message:String)  {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

           // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
               UIAlertAction in
               NSLog("OK Pressed")
            self.navigationController?.popViewController(animated: true)
           }
           
          
           alertController.addAction(okAction)
          

           // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }

    func popUpPlaceBid()  {
        self.tabBarController?.tabBar.isHidden = true
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
        let popup : AddPostEditPopVC = pop.instantiateViewController(withIdentifier: "AddPostEditPopVC") as! AddPostEditPopVC
        popup.subcategoryData = self.subcategoryData.reversed()
        popup.delegate = self
        self.presentOnRoot(with: popup, isAnimated: true)
    }
//    @IBAction func actionOnSameRegisterAddress(_ Sender:Any){
//
////        if self.btnSameAsregistered.isSelected == false {
////            self.btnSameAsregistered.isSelected = true
////        }else{
////            self.btnSameAsregistered.isSelected = false
////        }
////        if (MyDefaults().language ?? "") as String ==  "en"{
////            self.btnSameAsregistered.setTitle("Sameastheegistered".LocalizableString(localization: "en"), for: .normal)
////        } else{
////            self.btnSameAsregistered.setTitle("Sameastheegistered".LocalizableString(localization: "da"), for: .normal)
////        }
//
//        addressType = "0"
//        self.isAddressSelected = true
//        self.btnAddnewAddress.isSelected = false
//
//    }
    @IBAction func actionOnSameRegisterAddress(_ Sender:Any){
        
        self.imgSameAsRagisteredAddress.image = UIImage.init(named: "radio_active")
        self.imgNewAddress.image = UIImage.init(named: "radio")
        self.btnAddnewAddress.isSelected = false
        addressType = "0"
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
    
    
//    @IBAction func actionOnAddNewAddress(_ Sender:Any){
//        
//        self.isAddressSelected = true
////        if self.btnAddnewAddress.isSelected == false {
////            self.btnAddnewAddress.isSelected = true
////        }else{
////            self.btnAddnewAddress.isSelected = false
////        }
////        
////        if (MyDefaults().language ?? "") as String ==  "en"{
////            self.btnAddnewAddress.setTitle("AddNewAddress".LocalizableString(localization: "en"), for: .normal)
////        } else{
////            self.btnAddnewAddress.setTitle("AddNewAddress".LocalizableString(localization: "da"), for: .normal)
////        }
//        
//        
//        addressType = "1"
//        self.isAddressSelected = true
//        self.btnSameAsregistered.isSelected = false
//        let acController = GMSAutocompleteViewController()
//        acController.delegate = self
//        present(acController, animated: true, completion: nil)
//    }
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
        self.callServiceGetgetSubCategory()
    }
    @IBAction func actionOnBack(_ Sender:Any){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOnOffrPrice(_ Sender:Any){
         if (MyDefaults().language ?? "") as String ==  "en"{
            Util.showAlertWithMessage("What_did_the_item_cost_from_new?_For_used_item.Enter_estimated_price.".LocalizableString(localization: "en"), title: Key_Alert);return
            
        } else{
            Util.showAlertWithMessage("What_did_the_item_cost_from_new?_For_used_item.Enter_estimated_price.".LocalizableString(localization: "da"), title: Key_Alert);return
        }
    }
    @IBAction func actionOnOriginalprice(_ Sender:Any){
       
        
        if (MyDefaults().language ?? "") as String ==  "en"{
            Util.showAlertWithMessage("Your_minimum_price_to_start_your_auction._You_are_not_obligated_to_sell_regardless_of_bid".LocalizableString(localization: "en"), title: Key_Alert);return
        } else{
            Util.showAlertWithMessage("Your_minimum_price_to_start_your_auction._You_are_not_obligated_to_sell_regardless_of_bid".LocalizableString(localization: "da"), title: Key_Alert);return
        }
    }
}
// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension AddPostEditVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.collectionProductImage == collectionView {
             return self.imageArray.count
        }else{
            return self.categoryData.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.collectionProductImage == collectionView {
            let cell: AddPostEditProductImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostEditProductImageCollectionViewCell", for: indexPath) as! AddPostEditProductImageCollectionViewCell
           
            let dict = self.imageArray[indexPath.row]
            if dict["type"] as! String == "url" {
                if dict["isselected"] as? String == "yes"{
                     cell.imgView.image = dict["png"] as? UIImage
                    cell.configureCellImageCategory(cell: cell, image: dict["url"] as! String)
                    cell.btnCross.isHidden = false
                }else{
                     cell.imgView.image = dict["png"] as? UIImage
                     cell.imgView.image = UIImage.init(named: "camerablack")
                     cell.btnCross.isHidden = true
                }
            }else{
                if dict["isselected"] as? String == "yes"{
                     cell.imgView.image = dict["png"] as? UIImage
                    cell.btnCross.isHidden = false
                }else{
                     cell.imgView.image = dict["png"] as? UIImage
                     cell.imgView.image = UIImage.init(named: "camerablack")
                     cell.btnCross.isHidden = true
                }
            }
            cell.btnUpload.tag = indexPath.item
            cell.btnUpload.addTarget(self, action: #selector(didTapOnCamare(_:)), for: .touchUpInside)
            cell.btnCross.tag = indexPath.item
            cell.btnCross.addTarget(self, action: #selector(didTapOnCross(_:)), for: .touchUpInside)
            return cell
            
        }else{
            let cell: EditPostCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditPostCollectionViewCell", for: indexPath) as! EditPostCollectionViewCell
                cell.lblCategoryName.text = self.categoryData[indexPath.row].categoryName
           
            if self.categoryId == self.categoryData[indexPath.row].id {
                self.categoryId = self.categoryData[indexPath.row].id
            cell.reloadCategoryData(categoryImage: self.categoryData[indexPath.row].categoryImage, isSelected: true)
           cell.imgView.layer.borderWidth = 4.0
           cell.imgView.layer.borderColor = UIColor.hexStringToUIColor(hex: "#143649").cgColor
           cell.lblCategoryName.textColor = UIColor.hexStringToUIColor(hex: "#143649")
       }
            
                if self.categoryData[indexPath.row].isSeleted == true {
                    self.categoryData[indexPath.row].isSeleted = false
                    cell.imgView.layer.borderWidth = 4.0
                    cell.imgView.layer.borderColor = UIColor.hexStringToUIColor(hex: "#143649").cgColor
                    cell.lblCategoryName.textColor = UIColor.hexStringToUIColor(hex: "#143649")
                    cell.reloadCategoryData(categoryImage: self.categoryData[indexPath.row].categoryImage, isSelected: true)
                }
                     
               else{
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.collectionProductImage == collectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
       
            let size:CGFloat = (collectionView.frame.size.width - space) / 4.0
            return CGSize(width: size, height: 72.0)
        }else{
             let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
             let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 8.0)
             let size:CGFloat = (collectionView.frame.size.width - space) / 4
            return CGSize(width: size, height: 112.0)
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
//                   
//                
//                if (MyDefaults().language ?? "") as String ==  "en"{
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
extension AddPostEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate,getSelectAddtPostPopUpSubCategory,getSelectAddPostEditProperty {
    
    
    func delegatSelectAddPostEditProperty(dict: [String : Any], index: Int) {
//        self.propertyName = dict["property_name"] as! String
//        self.propertyValue = dict["propertValue"] as! String
//
//        self.isPropertySet = false
//        self.arraypropertry = [[String:Any]]()
//        self.arraypropertry.append(dict)
        
        
        self.tabBarController?.tabBar.isHidden = false
   //     var dictValue = [String:Any]()

        self.arraypropertry[index]["propertyValue"] = dict["propertyValue"] as! String
        print(self.arraypropertry)
        self.tblView.reloadData()
        print(dict)
    }
    
    func delegatSelectAddPostSubCategory(Model:ModelSubcategoryDatum,index:Int) {
        self.tabBarController?.tabBar.isHidden = false
        self.arraypropertry = [[String :Any]]()
        self.subcategoryData = [ModelSubcategoryDatum]()
        self.subcategoryData.append(Model)
        
        self.subCategoryId = Model.id
        self.propertyId = Model.id!
        self.txtSubCategory.text = Model.subcategoryName as String
        
        for items in Model.propertyName {
           
            var dict = [String:Any]()
            dict["category"] = items.category
            dict["createdat"] = items.createdAt
            dict["id"] = items.id
            self.propertyId = items.id
            dict["propertyname"] = items.propertyName
            dict["propertyAllValue"] = items.propertyValue
            dict["status"] = items.status
            dict["subcategory"] = items.subcategory
            let getArray = items.propertyValue.components(separatedBy: ",")
            for index in 0..<getArray.count {
                if index == 0 {
                    let name = getArray[0]
                    dict["propertyValue"] = name
                }
               
            }
           self.arraypropertry.append(dict)
        }
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

        print(self.imageArray.count)
            if self.imageArray.count <= 2 {
                if (MyDefaults().language ?? "") as String ==  "en"{
                    self.deleteImageOfCataegoryImage(title: "", message: "You_can_not_delete_auction_first_image".LocalizableString(localization: "en"), Okay: "Okay".LocalizableString(localization: "en"))
                } else {
                    self.deleteImageOfCataegoryImage(title: "", message: "You_can_not_delete_auction_first_image".LocalizableString(localization: "da"), Okay: "Okay".LocalizableString(localization: "da"))
                }
            } else {
                self.imageArray.remove(at: sender.tag)
                self.collectionProductImage.reloadData()
        }
    }
    @objc func didTapOnCategory(_ sender: UIButton) {
           if self.categoryData[sender.tag].isSeleted == false {
               self.categoryData[sender.tag].isSeleted = true
               
            self.txtSubCategory.text = ""
               self.categoryId = self.categoryData[sender.tag].id
           }else{
               self.categoryData[sender.tag].isSeleted = false
            }
            self.collectionCategory.reloadData()
    }
    func deleteImageOfCataegoryImage(title:String, message:String,Okay:String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Okay, style: UIAlertAction.Style.default) {
            UIAlertAction in
           // self.txtOriginalPrice.text = ""
          //  self.txtOfferPrice.text = ""
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
            alert.addAction(UIAlertAction(title: "Dismiss".LocalizableString(localization: "da"), style: .destructive, handler: { (_) in
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
            self.isImageVisible = true
            self.imageArray.append(dict)
            //self.imageArray.reverse()
         picker.dismiss(animated: true, completion: nil)
        
    }
        self.collectionProductImage.reloadData()
    }
}
extension AddPostEditVC: UITextViewDelegate,UITextFieldDelegate {
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
}
extension  AddPostEditVC:UITableViewDelegate,UITableViewDataSource{
//   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    if isPropertySet == true {
//        return self.objActiveAuction.productProperty.count
//     }else{
//        return self.arraypropertry.count
//    }
//}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return self.arraypropertry.count
 }
    
//   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if isPropertySet == true {
//                var cell : AddPostEditTableViewCell?
//               cell = tableView.dequeueReusableCell(withIdentifier: "AddPostEditTableViewCell", for: indexPath) as? AddPostEditTableViewCell
//               cell?.lblValue.text = self.objActiveAuction.productProperty[indexPath.row].propertyName
//               cell?.lblName.text = self.objActiveAuction.productProperty[indexPath.row].propertyValue
//               cell?.btnSubCategory.tag = indexPath.row
//               cell?.btnSubCategory.addTarget(self, action: #selector(clickOnproperty(sender:)), for: .touchUpInside)
//                return cell!
//        }else{
//
//                var cell : AddPostEditTableViewCell?
//                let dict = arraypropertry[indexPath.row]
//                cell = tableView.dequeueReusableCell(withIdentifier: "AddPostEditTableViewCell", for: indexPath) as? AddPostEditTableViewCell
//                cell?.lblValue.text = dict["property_name"] as? String
//                cell?.lblName.text = dict["propertValue"] as? String
//                cell?.btnSubCategory.tag = indexPath.row
//                cell?.btnSubCategory.addTarget(self, action: #selector(clickOnproperty(sender:)), for: .touchUpInside)
//                return cell!
//    }
//
//}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            var cell : AddPostEditTableViewCell?
                 let dict = arraypropertry[indexPath.row]
                 cell = tableView.dequeueReusableCell(withIdentifier: "AddPostEditTableViewCell", for: indexPath) as? AddPostEditTableViewCell
                 cell?.lblValue.text = dict["propertyname"] as? String
                 cell?.lblName.text = dict["propertyValue"] as? String
                 cell?.btnSubCategory.tag = indexPath.row
                 cell?.btnSubCategory.addTarget(self, action: #selector(clickOnproperty(sender:)), for: .touchUpInside)
                 return cell!
    
     
 }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
   }
    @objc func clickOnproperty(sender: UIButton){
            self.popUpGetProperty(index:sender.tag)
    }
    func popUpGetProperty(index:Int)  {
        var getArray = [String]()
        
        self.tabBarController?.tabBar.isHidden = true
        var arrayProper = [[String:Any]]()
        let dict = self.arraypropertry[index]
        print(dict)
        let Property = dict["propertyAllValue"] as? String
        
        if Property != nil {
            getArray = Property!.components(separatedBy: ",")
                for items in getArray {
                var dict = [String:Any]()
                dict["propertyValue"] = items
                arrayProper.append(dict)
            }
           print(arrayProper)
            let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
                let popup : AddpostEditPropertyPopUp = pop.instantiateViewController(withIdentifier: "AddpostEditPropertyPopUp") as! AddpostEditPropertyPopUp
            popup.arraypropertryValue = arrayProper.reversed()
                popup.index = index
                popup.delegate = self
                self.presentOnRoot(with: popup, isAnimated: true)
            }
        }
    
    func callServiceProerty(index:Int) {
        var loading = ""
          if (MyDefaults().language ?? "") as String ==  "en"{
              loading = "Loading".LocalizableString(localization: "en")
          } else{
              loading = "Loading".LocalizableString(localization: "da")
          }
        let parameter: [String: Any] = ["language": MyDefaults().language ?? AnyObject.self,
                                            "property_id":propertyId]
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
                                self.popUpGetProperty(index: index)
                                
                            }
                            } else if status == 500 {
                                   
                                   self.showErrorPopup(message: message, title: ALERTMESSAGE)
                           }
                           }else{
                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                       }
                   
           }
       }
    func callServiceDeleteProduct(imageId:String,index:Int) {
        var loading = ""
          if (MyDefaults().language ?? "") as String ==  "en"{
              loading = "Loading".LocalizableString(localization: "en")
          } else{
              loading = "Loading".LocalizableString(localization: "da")
          }
        
        let parameter: [String: Any] = ["language": MyDefaults().language ?? AnyObject.self,
                                       "image_id":imageId]
      print(parameter)
        HTTPService.callForPostApi(url:getDeleteProductAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                  debugPrint(response)
                //  HideHud()
                  if response.count != nil {
                      let status = response["responseCode"] as! Int
                      let message = response["message"] as! String
                      if status == 200  {
                        self.imageArray.remove(at: index)
                        self.collectionProductImage.reloadData()
                        self.showErrorPopup(message: message, title: ALERTMESSAGE)
                       } else if status == 500 {
                              
                              self.showErrorPopup(message: message, title: ALERTMESSAGE)
                      }
                      }else{
                      self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                  }
              
      }
    }
}
    extension AddPostEditVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
        self.isAddressSelected = true
        MyDefaults().myDefaultAddress = place.name
        forwardGeocoding(address: place.formattedAddress!)
        self.lblAddress.isHidden = false
        self.lblAddress.text = place.formattedAddress!
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
        dismiss(animated: true, completion: nil)
    }
    
}
    class AddPostEditTableViewCell: UITableViewCell {
        @IBOutlet weak var lblValue : UILabel!
        @IBOutlet weak var lblName : UILabel!
        @IBOutlet weak var btnSubCategory : UIButton!
    }
class AddPostEditProductImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btnCross : UIButton!
    @IBOutlet weak var btnUpload : UIButton!
    @IBOutlet weak var imgView : UIImageView!
    func configureCellImageCategory(cell:AddPostEditProductImageCollectionViewCell,image:String)  {
                   
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
}


