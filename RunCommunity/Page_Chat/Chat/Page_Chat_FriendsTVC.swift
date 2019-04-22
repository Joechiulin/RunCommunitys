//
//  Page_ChatTVC.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/3/21.
//  Copyright © 2019 PIG. All rights reserved.
//
import UIKit
import Foundation

class Page_Chat_FriendsTVC: UITableViewController {
    let userDefaults = UserDefaults.standard
    let tag = "Page_Chat_FriendsTVC"
    let url_server = URL(string: common_url+"FriendsServlet")
    var user: String!
    var friendList = [Friends]()
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        user = self.userDefaults.string(forKey: "useraccount")
        tableViewAddRefreshControl()
    }
    
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(showAllFriends), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        showAllFriends()
    }
    
    @objc func showAllFriends() {
        var requestParam = [String:String]()
        requestParam["action" ] = "getAllFriend"
        requestParam["account"] = userDefaults.string(forKey: "userAccount")
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode([Friends].self, from: data!) {
                        self.friendList = result
                        DispatchQueue.main.async {
                            if let control = self.tableView.refreshControl {
                                if control.isRefreshing {
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
    
    
    @IBAction func btSearch(_ sender: Any) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "searchFriendsTVC"){
            self.present(controller,animated: true, completion: nil)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "friendCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! Page_FriendCell
        let friend = friendList[indexPath.row]
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getUserImage"
        requestParam["account"] = friend.friendAccount
        requestParam["imageSize"] = cell.imageFriendPhoto.frame.width
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    self.image = UIImage(data: data!)
                }
                DispatchQueue.main.async {
                    cell.imageFriendPhoto.image = self.image
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        var reParam = [String: Any]()
        reParam["action"] = "getUserName"
        reParam["account"] = friend.friendAccount
        executeTask(url_server!, reParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    print("inputUserName: \(String(data: data!, encoding: .utf8)!)")
                    DispatchQueue.main.async {
                        cell.lbFriendName.text = String(data: data!, encoding: .utf8)!
                    }
                    
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            let friend = friendList[indexPath.row]
            let destination = segue.destination as! Page_ChatVC
            destination.friend = friend.friendAccount
        }
    }
    
}
