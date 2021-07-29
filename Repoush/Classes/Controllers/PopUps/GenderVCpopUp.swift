//
//  GenderVCpopUp.swift
//  Repoush
//
//  Created by Apple on 05/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit


protocol delegateGender {
    func delegatSelecteGender(dict:[String:Any])
}
class GenderVCpopUp: UIViewController {
    @IBOutlet weak var btnOkay : UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    @IBOutlet weak var tblView : UITableView!
    var delagate: delegateGender!
    
    var gender = [["gender":"Male", "genderId":"1","isSelected":true],["gender":"Female", "genderId":"2","isSelected":false]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    func changeLanguage(strLanguage:String) {
       
//        self.btnOkay.setTitle("ChangeEmail".LocalizableString(localization: strLanguage), for: .normal)
//        self.btnCancel.setTitle("ChangeEmail".LocalizableString(localization: strLanguage), for: .normal)
    }
    @IBAction func actionOnCancel(_ Sender : Any){
       
        var dict = [String:Any]()
        dict["gender"] = "Male"
        dict["genderId"] = "1"
        if self.delagate != nil {
            self.dismiss(animated: true, completion: nil)
            self.delagate.delegatSelecteGender(dict: dict)
            
        }
    }
    @IBAction func actionOnkay(_ Sender : Any){
        var dict = [String:Any]()
        for items in self.gender {
            if items["isSelected"] as! Bool == true {
                dict["gender"] = items["gender"] as! String
                dict["genderId"] = items["genderId"] as! String
            } else{
                var dict = [String:Any]()
                dict["gender"] = "Male"
                dict["genderId"] = "1"
            }
            
            if self.delagate != nil {
                self.dismiss(animated: true, completion: nil)
                self.delagate.delegatSelecteGender(dict: dict)
            }
    }
    }
}
extension GenderVCpopUp : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gender.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        var cell : GenderTableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "GenderTableViewCell", for: indexPath) as? GenderTableViewCell
        let dict = gender[indexPath.row]
        let genderName = dict["gender"] as? String
        
        if (MyDefaults().language ?? "") as String ==  "en"{
           cell?.lblCategoryName.text = genderName?.LocalizableString(localization: "en")
        } else{
            cell?.lblCategoryName.text = genderName?.LocalizableString(localization: "da")
        }
        
        if dict["isSelected"] as! Bool == true {
            cell?.imgViewRadio.image = UIImage.init(named: "radio_active")
        }else{
            cell?.imgViewRadio.image = UIImage.init(named: "radio")
        }
       return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for (index, var element) in self.gender.enumerated(){
            if index == indexPath.row{
                element.updateValue(true, forKey: "isSelected")
               // MyDefaults().DefaultSetLanguage = element["languageId"] as? String
                //MyDefaults().DefaultSetLanguage = element["languageId"] as? String
            }else{
                element.updateValue(false, forKey: "isSelected")
            }
            self.gender[index] = element
        }
        self.tblView.reloadData()
    }
}
class GenderTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCategoryName : UILabel!
    @IBOutlet weak var imgViewRadio : UIImageView!
    override func awakeFromNib() {
        
    }
   
}
