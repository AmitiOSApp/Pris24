//
//  SettingVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 2/8/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tblSetting: UITableView!
    
    // MARK: - Property initialization
    private var arrTitle = ["Notification", "Privacy", "Change Password", "Terms of use", "Report a problem"]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate
extension SettingVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell
        cell?.selectionStyle = .none
        
        cell?.lblTitle.text = arrTitle[indexPath.row]
        
        cell?.imgviewSetting.image = UIImage(named: "setting_icon\(indexPath.row + 1)")

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
