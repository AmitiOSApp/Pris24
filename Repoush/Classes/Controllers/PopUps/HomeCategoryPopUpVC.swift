//
//  HomeCategoryPopUpVC.swift
//  Repoush
//
//  Created by mac  on 11/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
protocol getSelectCategory {
    func delegatSelectCategory(array:NSMutableArray)
}
class HomeCategoryPopUpVC: UIViewController {
    @IBOutlet weak var lblCategory : UILabel!
    @IBOutlet weak var tblView : UITableView!
     @IBOutlet weak var lblTitle : UILabel!
     @IBOutlet weak var btnCancel : UIButton!
    var delagate: getSelectCategory!
    var isCategory = false
    var arrayCategory = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
    }
    func changeLanguage(strLanguage:String) {
        self.lblTitle.text = "selectcategory".LocalizableString(localization: strLanguage)
        self.btnCancel.setTitle("Report_Cancel".LocalizableString(localization: strLanguage), for: .normal)
    }
    @IBAction func actionOnCancel(_ Sender : Any){
        self.dismiss(animated: true, completion: nil)
    }
}
extension HomeCategoryPopUpVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        var cell : HomeCategoryTableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "HomeCategoryTableViewCell", for: indexPath) as? HomeCategoryTableViewCell
        let dict = arrayCategory[indexPath.row] as! NSDictionary
        cell?.lblCategoryName.text = dict["category_name"] as? String
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arrayCategory[indexPath.row] as! NSDictionary
        let array = NSMutableArray()
        array.add(dict)
        if self.delagate != nil{
            self.delagate.delegatSelectCategory(array: array)
        }
    }
}
class HomeCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCategoryName : UILabel!
    override func awakeFromNib() {
        
    }
   
}
