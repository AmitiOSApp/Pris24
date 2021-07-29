//
//  AddpostEditPropertyPopUp.swift
//  Repoush
//
//  Created by Apple on 30/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//


import UIKit
protocol getSelectAddPostEditProperty {
    func delegatSelectAddPostEditProperty(dict:[String:Any],index:Int)
    func delegatcancelAddPostEditProperty()
}
class AddpostEditPropertyPopUp: UIViewController {
@IBOutlet weak var tblView:UITableView!
    var propertyData : ModelPropertyObjDatum!
        var delegate : getSelectAddPostEditProperty!
    var isCategorySelected = true
    var arrayProperty = [[String:Any]]()
    
    var arraypropertryValue = [[String:Any]]()
    var propertyId = ""
    var index : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.transform = CGAffineTransform(scaleX: 1, y: -1)
     //  self.setUI()
        // Do any additional setup after loading the view.
    }
    @IBAction func actionOnCross(_ sender: Any){
        
        if self.delegate != nil {
            self.delegate.delegatcancelAddPostEditProperty()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    func setUI()  {
       // let propertyValue = self.propertyData.propertyValue
        let property = self.propertyData.propertyValue.components(separatedBy: ",")
        for items in property {
            var dict = [String:Any]()
            dict["propertyValue"] = items as String
            dict["id"] = propertyData.id as String
            dict["property_name"] = propertyData.propertyName as String
            dict["subcategory"] = propertyData.subcategory as String
            dict["category"] = propertyData.category as String
            self.arrayProperty.append(dict)
        }
    }
}
extension  AddpostEditPropertyPopUp:UITableViewDelegate,UITableViewDataSource{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.arraypropertryValue.count
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : AddPostEditPropertyPopVC?
        cell = tableView.dequeueReusableCell(withIdentifier: "AddPostEditPropertyPopVC", for: indexPath) as? AddPostEditPropertyPopVC

        let dict = self.arraypropertryValue[indexPath.row]
        cell?.lblSubcategory.text = dict["propertyValue"] as? String
        cell?.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    
    return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arraypropertryValue[indexPath.row]
        if self.delegate != nil {
        self.dismiss(animated: true, completion: nil)
        self.delegate.delegatSelectAddPostEditProperty(dict: dict, index: index)
        }
        
        
   }
}
class AddPostEditPropertyPopVC: UITableViewCell {
    @IBOutlet weak var lblSubcategory : UILabel!
    
}
