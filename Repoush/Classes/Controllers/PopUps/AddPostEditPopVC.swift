//
//  AddPostEditPopVC.swift
//  Repoush
//
//  Created by Apple on 30/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
protocol getSelectAddtPostPopUpSubCategory {
    func delegatSelectAddPostSubCategory(Model:ModelSubcategoryDatum,index:Int)
    func delegatcancelAddPostSubCategory()
    
}
class AddPostEditPopVC: UIViewController {
@IBOutlet weak var tblView:UITableView!
        var subcategoryData = [ModelSubcategoryDatum]()
        var delegate : getSelectAddtPostPopUpSubCategory!
    var index : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.transform = CGAffineTransform(scaleX: 1, y: -1)

        // Do any additional setup after loading the view.
    }
    @IBAction func actionOnCross(_ sender: Any){
        //self.dismiss(animated: true, completion: nil)
        if self.delegate != nil {
            self.delegate.delegatcancelAddPostSubCategory()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
}
extension  AddPostEditPopVC:UITableViewDelegate,UITableViewDataSource{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subcategoryData.count
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : AddPostEditSubcategoryPopVC?
        cell = tableView.dequeueReusableCell(withIdentifier: "AddPostEditSubcategoryPopVC", for: indexPath) as? AddPostEditSubcategoryPopVC
        cell?.lblSubcategory.text = self.subcategoryData[indexPath.row].subcategoryName
        cell?.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let obj = self.subcategoryData[indexPath.row]
        
        print(obj)
       
        if self.delegate != nil {
            self.dismiss(animated: true, completion: nil)
            //self.delegate.delegatSelectAddPostSubCategory(Model: self.subcategoryData[indexPath.row])
        
            self.delegate.delegatSelectAddPostSubCategory(Model: self.subcategoryData[indexPath.row], index: index)
        }
        
   }
}
class AddPostEditSubcategoryPopVC: UITableViewCell {
    @IBOutlet weak var lblSubcategory : UILabel!
    
}
