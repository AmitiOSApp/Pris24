//
//  PropertyValuePopUpVC.swift
//  Repoush
//
//  Created by mac  on 16/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//


import UIKit
protocol getPropertySideMenu {
    func delegatPropertySideMenuDidSelect(propertyValue : String)
}
class PropertyValuePopUpVC: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    var delagate: getPropertySideMenu!
     var propertyValue = [String]()
        var property = [[String:Any]]()
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
extension PropertyValuePopUpVC : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return  self.propertyValue.count
    }

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyTableViewCell", for: indexPath) as? PropertyTableViewCell else { fatalError() }
        cell.lblPropertyName.text = self.propertyValue[indexPath.row]
       // cell.btnPropertyName.tag = indexPath.row
        //cell.btnPropertyName.addTarget(self, action: #selector(clickOnProperty(sender:)), for: .touchUpInside)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
   
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delagate != nil {
            self.delagate.delegatPropertySideMenuDidSelect(propertyValue: self.propertyValue[indexPath.row])
        }

    }
}

class PropertyTableViewCell: UITableViewCell {
    @IBOutlet weak var lblPropertyName:UILabel!
    //  @IBOutlet weak var txtPropertyName:UITextField!
    //@IBOutlet weak var btnPropertyName:UIButton!
}
