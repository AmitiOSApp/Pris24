//
//  AddPostVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/25/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class AddPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var lblPostProduct: UILabel!
    @IBOutlet weak var collectionViewPostImage: UICollectionView!
    @IBOutlet weak var collectionViewCategory: UICollectionView!
    @IBOutlet weak var btnWomen: UIButton!
    @IBOutlet weak var btnKids: UIButton!
    @IBOutlet weak var txfSelling: UITextField!
    @IBOutlet weak var btnSize: UIButton!
    @IBOutlet weak var btnGender: UIButton!
    @IBOutlet weak var txfCondition: UITextField!
    @IBOutlet weak var txfOriginalPrice: UITextField!
    @IBOutlet weak var txfOfferPrice: UITextField!
    @IBOutlet weak var btnDiscountPercent: UIButton!
    @IBOutlet weak var txfBrand: UITextField!
    @IBOutlet weak var txvDescription: CustomTextview!
    @IBOutlet weak var btnRegisteredAddress: UIButton!
    @IBOutlet weak var btnNewAddress: UIButton!
    @IBOutlet weak var viewSize: UIView!
    @IBOutlet weak var tblSize: UITableView!
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var pickerViewGender: UIPickerView!
    @IBOutlet weak var lblNewAddress: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var btnAge: UIButton!

    @IBOutlet weak var btnBackWidthConst: NSLayoutConstraint!
    @IBOutlet weak var imgviewBgHgtConst: NSLayoutConstraint!
    @IBOutlet weak var viewCollectionHgtConst: NSLayoutConstraint!
    @IBOutlet weak var viewSizeHgtConst: NSLayoutConstraint!
    @IBOutlet weak var viewAgeHgtConst: NSLayoutConstraint!
    @IBOutlet weak var viewGenderHgtConst: NSLayoutConstraint!
    @IBOutlet weak var tblSizeHgtConst: NSLayoutConstraint!

    // MARK: - Property initialization
    private enum ActionType: Int {
        case women = 100, kids, size, gender, registeredAddress, newAddress, postNow, age
    }
    var dictProduct = NSDictionary()
    var isEdit = false
    private var categoryId = 1
    private var subcategoryId = ""
    private var arrSubcategory = NSMutableArray()
    private var selectedIndex = 0
    private var arrSize = [String]()
    private var arrAge = [String]()
    private var arrProductImage = [UIImage]()
    private var arrOldImage = NSMutableArray()
    private var discountPercent = ""
    private var latitude = 0.0
    private var longitude = 0.0
    private var isSize = false

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tabBarController?.delegate = self

        if isEdit {
            lblPostProduct.text = "Edit Product"
            setProductDetail()
        }
        else {
            btnBackWidthConst.constant = 0.0
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        viewBG.addGestureRecognizer(tap)

        // Perform Get subcategory API
        getSubcategoryAPI_Call()
    }
    
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUser_Action(_ sender: UIButton) {
        
        resignAllActiveResponder()
        
        if sender.tag == ActionType.women.rawValue {
            btnWomen.isSelected = true
            btnKids.isSelected = false
            
            btnSize.setTitle("Choose", for: .normal)
            viewGenderHgtConst.constant = 0.0

            categoryId = 1
            selectedIndex = 0
            
            // Perform Get subcategory API
            getSubcategoryAPI_Call()
        }
        else if sender.tag == ActionType.kids.rawValue {
            btnWomen.isSelected = false
            btnKids.isSelected = true
            
            btnSize.setTitle("Choose", for: .normal)
            categoryId = 2
            selectedIndex = 0

            viewGenderHgtConst.constant = 48.0

            // Perform Get subcategory API
            getSubcategoryAPI_Call()
        }
        else if sender.tag == ActionType.size.rawValue {
            if arrSize.count > 0 {
                isSize = true
                viewBG.isHidden = false
                viewSize.isHidden = false
                tblSize.reloadData()
            }
        }
        else if sender.tag == ActionType.gender.rawValue {
            viewDatePicker.isHidden = false
            pickerViewGender.isHidden = false
            
            pickerViewGender.reloadAllComponents()
        }
        else if sender.tag == ActionType.registeredAddress.rawValue {
            sender.isSelected = true
            btnNewAddress.isSelected = false
            lblNewAddress.text = ""
        }
        else if sender.tag == ActionType.newAddress.rawValue {
            
            sender.isSelected = true
            btnRegisteredAddress.isSelected = false

            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
        }
        else if sender.tag == ActionType.age.rawValue {
            if arrAge.count > 0 {
                isSize = false
                viewBG.isHidden = false
                viewSize.isHidden = false
                tblSize.reloadData()
            }
        }
        else if sender.tag == ActionType.postNow.rawValue {
            // Check required field validation
            if isRequiredFieldValid() {
                // Perform Post product API
                postProductAPI_Call()
            }
        }
    }
    
    @IBAction func btnSelectImage_Action(_ sender: UIButton) {
        
        if (arrProductImage.count + arrOldImage.count) >= 3 {
            Util.showAlertWithMessage("You can select maximum 3 image", title: ""); return
        }
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        let saveAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func btnDiscount_Action(_ sender: UIButton) {
        calculateDiscount()
    }
    
    @IBAction func btnPicker_Action(_ sender: UIButton) {
        if sender.titleLabel?.text == "Done" {
            let selectedIndex = pickerViewGender.selectedRow(inComponent: 0)
            let strGender = selectedIndex == 0 ? "Male" : "Female"
            btnGender.setTitle(strGender, for: .normal)
            btnGender.setTitleColor(UIColor.black, for: .normal)
        }
        viewDatePicker.isHidden = true
    }
    
    @IBAction func btnCross_Action(_ sender: UIButton) {
        viewBG.isHidden = true
        viewSize.isHidden = true
    }
    
    // MARK: - Private Methods
    private func setProductDetail() {
        
        if dictProduct["category_id"] as? String == "1" {
            btnWomen.isSelected = true
            btnKids.isSelected = false
            
            categoryId = 1
            selectedIndex = 0
        }
        else {
            btnWomen.isSelected = false
            btnKids.isSelected = true
            
            categoryId = 2
            selectedIndex = 0
        }
        
        txfSelling.text = dictProduct["selling"] as? String
        txfOriginalPrice.text = dictProduct["base_price"] as? String
        txfOfferPrice.text = dictProduct["offer_price"] as? String
        btnDiscountPercent.setTitle("\(dictProduct["discount"] ?? 0) %", for: .normal)
        txfBrand.text = dictProduct["brand"] as? String
        txfCondition.text = dictProduct["product_condition"] as? String
        txvDescription.text = dictProduct["description"] as? String
        btnDiscountPercent.setTitleColor(.black, for: .normal)

        if dictProduct["address_type"] as? String == "0" {
            lblNewAddress.text = ""
            btnRegisteredAddress.isSelected = true
            btnNewAddress.isSelected = false
        }
        else {
            btnRegisteredAddress.isSelected = false
            btnNewAddress.isSelected = true
            lblNewAddress.text = dictProduct["address"] as? String
        }

        let strSize = dictProduct["size"] as? String
        if !Util.isValidString(strSize ?? "") {
            viewSizeHgtConst.constant = 0.0
        }
        else {
            btnSize.setTitleColor(.black, for: .normal)
            viewSizeHgtConst.constant = 48.0
            tblSizeHgtConst.constant = CGFloat(arrSize.count * 35)
            btnSize.setTitle(strSize, for: .normal)
        }
        
        let strAge = dictProduct["age"] as? String
        if !Util.isValidString(strAge ?? "") {
            viewAgeHgtConst.constant = 0.0
        }
        else {
            btnAge.setTitleColor(.black, for: .normal)
            viewAgeHgtConst.constant = 48.0
            tblSizeHgtConst.constant = CGFloat(arrAge.count * 35)
            btnAge.setTitle(strAge, for: .normal)
        }
        
        let strGender = dictProduct["gender"] as? String
        if !Util.isValidString(strGender ?? "") {
            viewGenderHgtConst.constant = 0.0
        }
        else {
            btnGender.setTitleColor(.black, for: .normal)
            viewGenderHgtConst.constant = 48.0
            btnGender.setTitle(strGender, for: .normal)
        }
        tblSize.reloadData()
        
        if let arrTemp = dictProduct["product_image"] as? NSArray {
            arrOldImage = NSMutableArray(array: arrTemp)
            collectionViewPostImage.reloadData()
        }
        viewCollectionHgtConst.constant = 90.0
        imgviewBgHgtConst.constant = 310.0
    }

    private func manageSize(_ index: Int) {

        let dictSubcategory = arrSubcategory[index] as? NSDictionary
        let strSize = dictSubcategory!["size"] as? String
        
        let strAge = dictSubcategory!["age"] as? String

        subcategoryId = (dictSubcategory!["id"] as? String)!
        
        arrSize.removeAll()
        arrAge.removeAll()

        if Util.isValidString(strSize ?? "") {
            arrSize = (strSize?.components(separatedBy: ","))!
        }
        
        if Util.isValidString(strAge ?? "") {
            arrAge = (strAge?.components(separatedBy: ","))!
        }
        
        if arrSize.count == 0 {
            viewSizeHgtConst.constant = 0.0
        }
        else {
            viewSizeHgtConst.constant = 48.0
            tblSizeHgtConst.constant = CGFloat(arrSize.count * 35)
        }
        
        if arrAge.count == 0 {
            viewAgeHgtConst.constant = 0.0
        }
        else {
            viewAgeHgtConst.constant = 48.0
            tblSizeHgtConst.constant = CGFloat(arrAge.count * 35)
        }
        tblSize.reloadData()
    }
    
    private func calculateDiscount() {
        var originalPrice = 0
        var offerPrice = 0
        
        if Util.isValidString(txfOriginalPrice.text!) && Util.isValidString(txfOfferPrice.text!) {
            originalPrice = Int(txfOriginalPrice.text ?? "") ?? 0
            offerPrice = Int(txfOfferPrice.text ?? "") ?? 0
            
            if originalPrice > offerPrice {
                var percentage = (offerPrice / (originalPrice / 100))
                if percentage > 0 {
                    percentage = 100 - percentage
                }
                btnDiscountPercent.setTitle("\(percentage) %", for: .normal)
                btnDiscountPercent.setTitleColor(.black, for: .normal)
                
                discountPercent = "\(percentage)"
            }
        }
    }
    
    private func clearFormData() {
        
        arrProductImage.removeAll()
        collectionViewPostImage.reloadData()
        viewCollectionHgtConst.constant = 0.0
        imgviewBgHgtConst.constant = 220.0

        btnWomen.isSelected = true
        btnKids.isSelected = false

        categoryId = 1
        selectedIndex = 0

        collectionViewCategory.reloadData()
        
        manageSize(selectedIndex)
        
        txfSelling.text = ""
        txfCondition.text = ""
        txfOriginalPrice.text = ""
        txfOfferPrice.text = ""
        txfBrand.text = ""
        txvDescription.text = ""

        btnSize.setTitle("Choose", for: .normal)
        viewSizeHgtConst.constant = 0.0
        
        btnSize.setTitle("Choose", for: .normal)
        viewGenderHgtConst.constant = 0.0
        
        btnAge.setTitle("Choose", for: .normal)
        viewAgeHgtConst.constant = 0.0

        btnDiscountPercent.setTitle("Calculated discount %", for: .normal)
        btnDiscountPercent.setTitleColor(.lightGray, for: .normal)

        btnRegisteredAddress.isSelected = true
        btnNewAddress.isSelected = false
        lblNewAddress.text = ""
    }
    
    private func isRequiredFieldValid() -> Bool {
        
        let originalPrice = Int(txfOriginalPrice.text ?? "") ?? 0
        let offerPrice = Int(txfOfferPrice.text ?? "") ?? 0

        if (arrProductImage.count + arrOldImage.count) == 0 {
            Util.showAlertWithMessage("Please select product image", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfSelling.text!) {
            Util.showAlertWithMessage("Please enter what are you selling", title: Key_Alert); return false
        }
        else if viewSizeHgtConst.constant != 0 && btnSize.titleLabel?.text == "Choose" {
            Util.showAlertWithMessage("Please select size", title: Key_Alert); return false
        }
        else if viewAgeHgtConst.constant != 0 && btnAge.titleLabel?.text == "Choose" {
            Util.showAlertWithMessage("Please select age", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfCondition.text!) {
            Util.showAlertWithMessage("Please enter condition of product", title: Key_Alert); return false
        }
        else if viewGenderHgtConst.constant != 0 && btnGender.titleLabel?.text == "Choose" {
            Util.showAlertWithMessage("Please select gender", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfOriginalPrice.text!) {
            Util.showAlertWithMessage("Please enter original price", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfOfferPrice.text!) {
            Util.showAlertWithMessage("Please enter offer price", title: Key_Alert); return false
        }
        else if offerPrice >= originalPrice {
            Util.showAlertWithMessage("Offer price should not be greater than or equal to original price", title: ""); return false
        }
        else if btnNewAddress.isSelected && !Util.isValidString(lblNewAddress.text!) {
            Util.showAlertWithMessage("Please select address", title: Key_Alert); return false
        }
        return true
    }
    
    private func resignAllActiveResponder() {
        if txfSelling.isFirstResponder {
            txfSelling.resignFirstResponder()
        }
        else if txfCondition.isFirstResponder {
            txfCondition.resignFirstResponder()
        }
        else if txfOriginalPrice.isFirstResponder {
            txfOriginalPrice.resignFirstResponder()
        }
        else if txfOfferPrice.isFirstResponder {
            txfOfferPrice.resignFirstResponder()
        }
        else if txfBrand.isFirstResponder {
            txfBrand.resignFirstResponder()
        }
        else if txvDescription.isFirstResponder {
            txvDescription.resignFirstResponder()
        }
    }

    // MARK: - API Methods
    private func getSubcategoryAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_CategoryId : categoryId as AnyObject,
                kAPI_Language   : "en" as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.getSubCategory(postParams), callerObj: self, showHud: true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            if jsonObj["subcategory_data"].arrayObject != nil {
                let arrTemp = jsonObj["subcategory_data"].arrayObject! as NSArray
                self?.arrSubcategory = NSMutableArray(array: arrTemp.reversed())
            }
            
            DispatchQueue.main.async {
                self?.collectionViewCategory.reloadData()
                
                if (self?.arrSubcategory.count)! > 0 {
                    self?.manageSize(0)
                }
            }
        }
    }

    private func postProductAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        var size = ""
        if btnSize.titleLabel?.text != "Choose" {
            size = btnSize.titleLabel!.text!
        }
        
        var gender = ""
        if btnGender.titleLabel?.text != "Choose" {
            gender = btnGender.titleLabel!.text!
        }
        
        var age = ""
        if btnAge.titleLabel?.text != "Choose" {
            age = btnAge.titleLabel!.text!
        }
        
        var addressType = "0"
        var address = LoggedInUser.shared.address
        var latitude = LoggedInUser.shared.latitude
        var longitude = LoggedInUser.shared.longitude
        
        if btnNewAddress.isSelected {
            addressType = "1"
            address = lblNewAddress.text
            latitude = "\(self.latitude)"
            longitude = "\(self.longitude)"
        }

        let postParams: [String: AnyObject] =
            [
                kAPI_UserId           : LoggedInUser.shared.id as AnyObject,
                kAPI_CategoryId       : categoryId as AnyObject,
                kAPI_SubcategoryId    : subcategoryId as AnyObject,
                kAPI_Selling          : txfSelling.text as AnyObject,
                kAPI_Size             : size as AnyObject,
                kAPI_Gender           : gender as AnyObject,
                kAPI_Age              : age as AnyObject,
                kAPI_Condition        : txfCondition.text as AnyObject,
                kAPI_BasePrice        : txfOriginalPrice.text as AnyObject,
                kAPI_OfferPrice       : txfOfferPrice.text as AnyObject,
                kAPI_Discount         : discountPercent as AnyObject,
                kAPI_Brand            : txfBrand.text as AnyObject,
                kAPI_Description      : txvDescription.text as AnyObject,
                kAPI_Address          : address as AnyObject,
                kAPI_AddressType      : addressType as AnyObject,
                "latitude"            : latitude as AnyObject,
                "lognitute"           : longitude as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.uploadImagesWithParams(Networking.Router.postProduct(postParams), imageArray: arrProductImage, strImageKey: kAPI_ProductImage, dictParams: postParams, callerObj: self, showHud: true) { (encodingResult) -> Void in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    guard let result = response.result.value else {
                        return
                    }
                    let jsonObj = JSON(result)
                    
                    if jsonObj[Key_ResponseCode].intValue == 500 {
                        Util.showAlertWithMessage(jsonObj[Key_Message].stringValue, title: Key_Alert)
                        return
                    }
                    DLog(message: "\(result)")
                    
                    DispatchQueue.main.async { [weak self] in
                        let uiAlert = UIAlertController(title: "Repoush", message: "Product added successfully", preferredStyle:UIAlertController.Style.alert)
                        self?.present(uiAlert, animated: true, completion: nil)
                        
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            DispatchQueue.main.async { [weak self] in
                                self?.clearFormData()
                                self?.tabBarController?.selectedIndex = 0
                            }
                        }))
                    }
                }
            case .failure(let encodingError):
                
                let alertController = UIAlertController(title: kAPI_Alert, message: encodingError as? String, preferredStyle: UIAlertController.Style.alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                )
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func editProductAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        var size = ""
        if btnSize.titleLabel?.text != "Choose" {
            size = btnSize.titleLabel!.text!
        }
        
        var gender = ""
        if btnGender.titleLabel?.text != "Choose" {
            gender = btnGender.titleLabel!.text!
        }
        
        var age = ""
        if btnAge.titleLabel?.text != "Choose" {
            age = btnAge.titleLabel!.text!
        }
        
        var addressType = "0"
        var address = LoggedInUser.shared.address
        var latitude = LoggedInUser.shared.latitude
        var longitude = LoggedInUser.shared.longitude
        
        if btnNewAddress.isSelected {
            addressType = "1"
            address = lblNewAddress.text
            latitude = "\(self.latitude)"
            longitude = "\(self.longitude)"
        }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId           : LoggedInUser.shared.id as AnyObject,
                kAPI_ProductId        : dictProduct["id"] as AnyObject,
                kAPI_CategoryId       : categoryId as AnyObject,
                kAPI_SubcategoryId    : subcategoryId as AnyObject,
                kAPI_Selling          : txfSelling.text as AnyObject,
                kAPI_Size             : size as AnyObject,
                kAPI_Gender           : gender as AnyObject,
                kAPI_Age              : age as AnyObject,
                kAPI_Condition        : txfCondition.text as AnyObject,
                kAPI_BasePrice        : txfOriginalPrice.text as AnyObject,
                kAPI_OfferPrice       : txfOfferPrice.text as AnyObject,
                kAPI_Discount         : discountPercent as AnyObject,
                kAPI_Brand            : txfBrand.text as AnyObject,
                kAPI_Description      : txvDescription.text as AnyObject,
                kAPI_Address          : address as AnyObject,
                kAPI_AddressType      : addressType as AnyObject,
                "latitude"            : latitude as AnyObject,
                "lognitute"           : longitude as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.uploadImagesWithParams(Networking.Router.editProduct(postParams), imageArray: arrProductImage, strImageKey: kAPI_ProductImage, dictParams: postParams, callerObj: self, showHud: true) { (encodingResult) -> Void in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    guard let result = response.result.value else {
                        return
                    }
                    let jsonObj = JSON(result)
                    
                    if jsonObj[Key_ResponseCode].intValue == 500 {
                        Util.showAlertWithMessage(jsonObj[Key_Message].stringValue, title: Key_Alert)
                        return
                    }
                    DLog(message: "\(result)")
                    
                    DispatchQueue.main.async { [weak self] in
                        let uiAlert = UIAlertController(title: "Repoush", message: "Product added successfully", preferredStyle: UIAlertController.Style.alert)
                        self?.present(uiAlert, animated: true, completion: nil)
                        
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            DispatchQueue.main.async { [weak self] in
                                
                                if self!.isEdit {
                                    self?.navigationController?.popViewController(animated: true)
                                }
                                else {
                                    self?.clearFormData()
                                    self?.tabBarController?.selectedIndex = 0
                                }
                            }
                        }))
                    }
                }
            case .failure(let encodingError):
                
                let alertController = UIAlertController(title: kAPI_Alert, message: encodingError as? String, preferredStyle: UIAlertController.Style.alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                )
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func deleteProductImageAPI_Call(_ imageId: String) {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_ImageId : imageId as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.deleteProductImage(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
        }
    }

    private func updateProductImageAPI_Call() {
        
        if !isNetworkAvailable { return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_ProductId : dictProduct["id"] as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.updateProductImage(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
        }
    }

    // MARK: - Gesture Handler
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        viewBG.isHidden = true
        viewSize.isHidden = true
    }

}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension AddPostVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewCategory {
            return arrSubcategory.count
        }
        else {
            return (arrOldImage.count + arrProductImage.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewCategory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell
            
            let dictSubcategory = arrSubcategory[indexPath.item] as? NSDictionary
            
            cell?.lblSubcategoryName.text = dictSubcategory!["subcategory_name"] as? String
            
            if indexPath.item == selectedIndex {
                cell?.imgviewBorder.layer.borderColor = colorGreen.cgColor
                cell?.imgviewBorder.layer.borderWidth = 2.0
            }
            else {
                cell?.imgviewBorder.layer.borderColor = UIColor.clear.cgColor
                cell?.imgviewBorder.layer.borderWidth = 0.0
            }
            
            if Util.isValidString(dictSubcategory!["subcategory_image"] as! String) {
                
                let imageUrl = dictSubcategory!["subcategory_image"] as! String
                
                let url = URL.init(string: imageUrl)!
                
                cell?.imgviewSubcategory.kf.indicatorType = .activity
                cell?.imgviewSubcategory.kf.indicator?.startAnimatingView()
                
                let resource = ImageResource(downloadURL: url)
                
                KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        cell?.imgviewSubcategory.image = value.image
                    case .failure( _):
                        cell?.imgviewSubcategory.image = UIImage(named: "product1")
                    }
                    cell?.imgviewSubcategory.kf.indicator?.stopAnimatingView()
                }
            }
            else {
                cell?.imgviewSubcategory.image = UIImage(named: "product1")
            }
            return cell!
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as? ProductImageCell
            
            if indexPath.item < arrOldImage.count {
                
                let dictProductImage = arrOldImage[indexPath.item] as? NSDictionary
                
                if Util.isValidString(dictProductImage!["product_image"] as! String) {
                    
                    let imageUrl = dictProductImage!["product_image"] as! String
                    
                    let url = URL.init(string: imageUrl)
                    
                    cell?.imgviewProduct.kf.indicatorType = .activity
                    cell?.imgviewProduct.kf.indicator?.startAnimatingView()
                    
                    let resource = ImageResource(downloadURL: url!)
                    
                    KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                        switch result {
                        case .success(let value):
                            cell?.imgviewProduct.image = value.image
                        case .failure( _):
                            cell?.imgviewProduct.image = UIImage(named: "dummy_post")
                        }
                        cell?.imgviewProduct.kf.indicator?.stopAnimatingView()
                    }
                }
                else {
                    cell?.imgviewProduct.image = UIImage(named: "dummy_post")
                }
            }
            else {
                cell?.imgviewProduct.image = arrProductImage[arrOldImage.count - indexPath.item]
            }
            
            cell?.crossHandler = {
                if indexPath.item < self.arrOldImage.count {
                    
                    let dictProductImage = self.arrOldImage[indexPath.item] as? NSDictionary
                    self.deleteProductImageAPI_Call(dictProductImage!["id"] as! String)
                    
                    self.arrOldImage.remove(indexPath.item)

                    DispatchQueue.main.async {
                        self.collectionViewPostImage.reloadData()
                        
                        if (self.arrProductImage.count + self.arrOldImage.count) == 0 {
                            self.viewCollectionHgtConst.constant = 0.0
                            self.imgviewBgHgtConst.constant = 220.0
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.arrProductImage.remove(at: self.arrOldImage.count - indexPath.item)
                        self.collectionViewPostImage.reloadData()
                        
                        if (self.arrProductImage.count + self.arrOldImage.count) == 0 {
                            self.viewCollectionHgtConst.constant = 0.0
                            self.imgviewBgHgtConst.constant = 220.0
                        }
                    }
                }
            }
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewCategory {
            selectedIndex = indexPath.item
            collectionViewCategory.reloadData()
            
            manageSize(indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionViewCategory {
            return 0
        }
        else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionViewCategory {
            return 0
        }
        else {
            return 10
        }
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension AddPostVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSize {
            return arrSize.count
        }
        else {
            return arrAge.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SizeCell", for: indexPath) as? SizeCell
        cell?.selectionStyle = .none
        
        if isSize {
            cell?.lblSize.text = arrSize[indexPath.row]
        }
        else {
            cell?.lblSize.text = arrAge[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSize {
            btnSize.setTitle(arrSize[indexPath.row], for: .normal)
            btnSize.setTitleColor(.black, for: .normal)
        }
        else {
            btnAge.setTitle(arrAge[indexPath.row], for: .normal)
            btnAge.setTitleColor(.black, for: .normal)
        }
        viewBG.isHidden = true
        viewSize.isHidden = true
    }
    
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate method
extension AddPostVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Male"
        }
        else {
            return "Female"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
}

// MARK: - UIImagePickerController Delegate
extension AddPostVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            arrProductImage.append(pickedImage)
            
            viewCollectionHgtConst.constant = 90.0
            imgviewBgHgtConst.constant = 310.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.collectionViewPostImage.reloadData()
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - GMSAutocompleteViewControllerDelegate
extension AddPostVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
        
        forwardGeocoding(address: place.formattedAddress!)
        
        self.lblNewAddress.text = place.formattedAddress!
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

// MARK: - UITabBarControllerDelegate
extension AddPostVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex != 1 {
            clearFormData()
        }
    }
}
