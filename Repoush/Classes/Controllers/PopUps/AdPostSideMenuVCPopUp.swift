//
//  AdPostSideMenuVCPopUp.swift
//  Repoush
//
//  Created by mac  on 16/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
protocol getSideMenu {
    func delegatSideMenuDidSelect(subCategory:[String:Any])
}
class AdPostSideMenuVCPopUp: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    var delagate: getSideMenu!
    
    var subCategory = [[String:Any]]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.transform = CGAffineTransform(scaleX: 1, y: -1)
        // Do any additional setup after loading the view.
    }
    @IBAction func btnCross_Action(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
       }
}
extension AdPostSideMenuVCPopUp : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
         return self.subCategory.count
    }

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddpostSubCategoruTableViewCell", for: indexPath) as? AddpostSubCategoruTableViewCell else { fatalError() }
        let dict = self.subCategory[indexPath.row]
        cell.lblSubcategory.text = dict["subcategory_name"] as? String
       
        cell.btnSubCategory.tag = indexPath.row
        cell.btnSubCategory.addTarget(self, action: #selector(clickOnSubCategory(sender:)), for: .touchUpInside)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
        
    
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

}
   
   
    @objc func clickOnSubCategory(sender: UIButton){
            
        if self.delagate != nil{
            let dict = self.subCategory[sender.tag]
                       // let property = getProperty(index: sender.tag)
            self.delagate.delegatSideMenuDidSelect(subCategory: self.subCategory[sender.tag])
            
        }
    }
}
class AddpostSubCategoruTableViewCell: UITableViewCell {
    @IBOutlet weak var lblSubcategory:UILabel!
    @IBOutlet weak var btnSubCategory:UIButton!
}

