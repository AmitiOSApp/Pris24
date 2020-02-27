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
    @IBOutlet weak var txfDiscountPercent: UITextField!
    @IBOutlet weak var txfBrand: UITextField!
    @IBOutlet weak var txvDescription: CustomTextview!
    @IBOutlet weak var btnRegisteredAddress: UIButton!
    @IBOutlet weak var btnNewAddress: UIButton!
    @IBOutlet weak var viewSize: UIView!
    @IBOutlet weak var tblSize: UITableView!
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var pickerViewGender: UIPickerView!

    @IBOutlet weak var takeImageLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var viewSizeHgtConst: NSLayoutConstraint!
    @IBOutlet weak var viewGenderHgtConst: NSLayoutConstraint!
    @IBOutlet weak var tblSizeHgtConst: NSLayoutConstraint!

    // MARK: - Property initialization
    private enum ActionType: Int {
        case women = 100, kids, size, gender, registeredAddress, newAddress, postNow
    }
    private var categoryId = 1
    private var subcategoryId = ""
    private var arrSubcategory = NSMutableArray()
    private var selectedIndex = 0
    private var arrSize = [String]()
    private var arrProductImage = [UIImage]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Perform Get subcategory API
        getSubcategoryAPI_Call()
    }
    
    // MARK: - Action Methods
    @IBAction func btnUser_Action(_ sender: UIButton) {
        if sender.tag == ActionType.women.rawValue {
            btnWomen.isSelected = true
            btnKids.isSelected = false
            
            viewGenderHgtConst.constant = 0.0

            categoryId = 1
            
            // Perform Get subcategory API
            getSubcategoryAPI_Call()
        }
        else if sender.tag == ActionType.kids.rawValue {
            btnWomen.isSelected = false
            btnKids.isSelected = true
            
            categoryId = 2
            
            viewGenderHgtConst.constant = 40.0

            // Perform Get subcategory API
            getSubcategoryAPI_Call()
        }
        else if sender.tag == ActionType.size.rawValue {
            
            if arrSize.count > 0 {
                let bgView = UIView(frame: appDelegate.window!.bounds)
                bgView.tag = 20000002
                bgView.frame = CGRect.init(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                tap.numberOfTapsRequired = 1
                bgView.addGestureRecognizer(tap)
                
                let frame = appDelegate.window?.convert(viewSize.frame, from: self.view)
                
                viewSize.frame = frame!
                viewSize.frame.size.height = ScreenSize.height
                viewSize.tag = 30000003
                viewSize.isHidden = false
                
                appDelegate.window?.addSubview(bgView)
                appDelegate.window?.addSubview(viewSize)
                
                appDelegate.window!.bringSubviewToFront((viewSize)!)
                bgView.bringSubviewToFront((viewSize)!)
                
                tblSize.reloadData()
            }
        }
        else if sender.tag == ActionType.gender.rawValue {
            viewDatePicker.isHidden = false
            pickerViewGender.isHidden = false
            
            pickerViewGender.reloadAllComponents()
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
        
        if arrProductImage.count >= 3 {
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
        for subview in appDelegate.window!.subviews {
            if subview.tag == 20000002 {
                subview.removeFromSuperview()
            }
            else if subview.tag == 30000003 {
                subview.isHidden = true
            }
        }
    }
    
    // MARK: - Private Methods
    private func manageSize(_ index: Int) {

        let dictSubcategory = arrSubcategory[index] as? NSDictionary
        let strSize = dictSubcategory!["size"] as? String
        
        subcategoryId = (dictSubcategory!["id"] as? String)!
        
        arrSize.removeAll()

        if Util.isValidString(strSize ?? "") {
            arrSize = (strSize?.components(separatedBy: ","))!
        }
        
        if arrSize.count == 0 {
            viewSizeHgtConst.constant = 0.0
        }
        else {
            viewSizeHgtConst.constant = 40.0
            tblSizeHgtConst.constant = CGFloat(arrSize.count * 35)
        }
        tblSize.reloadData()
    }
    
    private func isRequiredFieldValid() -> Bool {
        if arrProductImage.count == 0 {
            Util.showAlertWithMessage("Please select product image", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfSelling.text!) {
            Util.showAlertWithMessage("Please enter what are you selling", title: Key_Alert); return false
        }
        else if viewSizeHgtConst.constant != 0 {
            if btnSize.titleLabel?.text == "Choose" {
                Util.showAlertWithMessage("Please select size", title: Key_Alert); return false
            }
        }
        else if !Util.isValidString(txfCondition.text!) {
            Util.showAlertWithMessage("Please enter condition of product", title: Key_Alert); return false
        }
        else if viewGenderHgtConst.constant != 0 {
            if btnGender.titleLabel?.text == "Choose" {
                Util.showAlertWithMessage("Please select gender", title: Key_Alert); return false
            }
        }
        else if !Util.isValidString(txfOfferPrice.text!) {
            Util.showAlertWithMessage("Please enter offer price", title: Key_Alert); return false
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
        else if txfDiscountPercent.isFirstResponder {
            txfDiscountPercent.resignFirstResponder()
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

        let postParams: [String: AnyObject] =
            [
                kAPI_UserId           : LoggedInUser.shared.id as AnyObject,
                kAPI_CategoryId       : categoryId as AnyObject,
                kAPI_SubcategoryId    : subcategoryId as AnyObject,
                kAPI_Selling          : txfSelling.text as AnyObject,
                kAPI_Size             : size as AnyObject,
                kAPI_Gender           : gender as AnyObject,
                kAPI_Condition        : txfCondition.text as AnyObject,
                kAPI_BasePrice        : txfOriginalPrice.text as AnyObject,
                kAPI_OfferPrice       : txfOfferPrice.text as AnyObject,
                kAPI_Discount         : txfDiscountPercent.text as AnyObject,
                kAPI_Brand            : txfBrand.text as AnyObject,
                kAPI_Description      : txvDescription.text as AnyObject,
                kAPI_Address          : LoggedInUser.shared.address as AnyObject,
                kAPI_Latitude         : LoggedInUser.shared.latitude as AnyObject,
                kAPI_Longitude        : LoggedInUser.shared.longitude as AnyObject,
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

    // MARK: - Gesture Handler
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        for subview in appDelegate.window!.subviews {
            if subview.tag == 20000002 {
                subview.removeFromSuperview()
            }
            else if subview.tag == 30000003 {
                subview.isHidden = true
            }
        }
    }

}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension AddPostVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewCategory {
            return arrSubcategory.count
        }
        else {
            return arrProductImage.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewCategory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell
            
            let dictSubcategory = arrSubcategory[indexPath.item] as? NSDictionary
            
            cell?.lblSubcategoryName.text = dictSubcategory!["subcategory_name"] as? String
            
            if indexPath.item == selectedIndex {
                cell?.imgviewSubcategory.layer.borderColor = UIColor.green.cgColor
                cell?.imgviewSubcategory.layer.borderWidth = 2.0
            }
            else {
                cell?.imgviewSubcategory.layer.borderColor = UIColor.clear.cgColor
                cell?.imgviewSubcategory.layer.borderWidth = 0.0
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
            
            cell?.imgviewProduct.image = arrProductImage[indexPath.item]
            
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
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension AddPostVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSize.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SizeCell", for: indexPath) as? SizeCell
        cell?.selectionStyle = .none
        
        cell?.lblSize.text = arrSize[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnSize.setTitle(arrSize[indexPath.row], for: .normal)
        btnSize.setTitleColor(.black, for: .normal)
        
        for subview in appDelegate.window!.subviews {
            if subview.tag == 20000002 {
                subview.removeFromSuperview()
            }
            else if subview.tag == 30000003 {
                subview.isHidden = true
            }
        }
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
            collectionViewPostImage.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
