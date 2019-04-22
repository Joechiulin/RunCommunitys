//
//  Page_Chat_SearchFriendTVC.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/4/9.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class Page_Chat_SearchFriendTVC: UITableViewController {
    let url_server = URL(string: common_url+"FriendsServlet")
    var users = [User]()
    var image: UIImage?
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
    }
    
    @IBAction func btCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(showAllUsers), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllUsers()
    }
    
    @objc func showAllUsers() {
        
        var requestParam = [String: String]()
        requestParam["action"] = "getAllUser"
        requestParam["account"] = userDefaults.string(forKey: "useraccount")
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode([User].self, from: data!) {
                        self.users = result
                        DispatchQueue.main.async {
                            if let control = self.tableView.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            /* 抓到資料後重刷table view */
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "searchFriendCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! Page_SearchFriendCell
        let user = users[indexPath.row]
        var requestParam = [String: Any]()
        requestParam["action"] = "getUserImage"
        requestParam["account"] = user.account
        requestParam["imageSize"] = cell.frame.width / 4
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    self.image = UIImage(data: data!)
                }
                DispatchQueue.main.async {
                    cell.ivUserPhoto.image = self.image
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        cell.lbUserAccount.text = user.account
        cell.lbUserName.text = user.username
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetail" {
            /* indexPath(for:)可以取得UITableViewCell的indexPath */
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let user = users[indexPath!.row]
            let Page_Chat_PersonalVC = segue.destination as! Page_Chat_PersonalVC
            Page_Chat_PersonalVC.user = user
            
        }
        
        //        let controller = segue.destination as? Page_Chat_PersonalVC
        //        if let row = tableView.indexPathForSelectedRow?.row {
        //            controller?.user = users[row]
        //        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
