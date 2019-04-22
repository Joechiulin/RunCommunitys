//
//  Community.swift
//  RunCommunity
//
//  Created by Joe on 2019/3/15.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit



class Community: UITableViewController {
    
    let userDefault = UserDefaults.standard


    var community = [Comm]()
//    let url_server = URL(string: common_url + "SpotServlet")
   // let url_server = URL(string: "http://127.0.0.1:8080/ServerConnect_Web/ServerConnectServlet")
    let url_server = URL(string: common_url + "ServerConnectServlet")
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
    }
    
    /** tableView加上下拉更新功能 */
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllSpots), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllSpots()
    }
    
    @objc func showAllSpots() {
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                   
                    
                    if let result = try? JSONDecoder().decode([Comm].self, from: data!) {
                        self.community = result
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
   
    
    /* UITableViewDataSource的方法，定義表格的區塊數，預設值為1 */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return community.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellId = "communitycell"
        // tableViewCell預設的imageView點擊後會改變尺寸，所以建立UITableViewCell子類別SpotCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! Communitycell
        let spot = community[indexPath.row]
        
        // 尚未取得圖片，另外開啟task請求
        var requesttParam = [String: Any]()
        requesttParam["action"] = "getImage"
        requesttParam["id"] = spot.id
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requesttParam["imageSize"] = cell.frame.width / 2
        var image: UIImage?
        executeTask(url_server!, requesttParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {
                    cell.imimage.image = image
                   cell.imimage.contentMode = .scaleAspectFit

                }
            } else {
                print(error!.localizedDescription)
            }
            
        }
//        let  account = self.userDefault.string(forKey: "account")
        
        var requestParama = [String: String]()
        requestParama["action"] = "getuser"
        requestParama["account"] = spot.account
        executeTask(url_server!, requestParama) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    
                    
                    if let result = try? JSONDecoder().decode([String:String].self, from: data!) {
                        DispatchQueue.main.async {
                            
                            cell.lbusername.text = result["sqlname"]
                        }
                        /* 抓到資料後重刷table view */
                        
                    }
                }
            }
        }
        
        var requesttParame = [String: Any]()
        requesttParame["action"] = "getuserImage"
        requesttParame["account"] = spot.account
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requesttParame["imageSize"] = 1
        var imagedate: UIImage?
        executeTask(url_server!, requesttParame) { (image, response, error) in
            if error == nil {
                if image != nil {
                    imagedate = UIImage(data: image!)
                }
                if imagedate == nil {
                    imagedate = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {
                    cell.ivuser.image = imagedate
                    
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        let datest = String(spot.date)

        let like = String(spot.likes)
        cell.tftext.text = spot.text
        cell.lblike.text = like
        cell.lbdate.text = datest
        return cell
    }
    
    @IBAction func btlike(_ sender: UIButton) {
        sender.isSelected.toggle()

        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point){
        print(community[indexPath.row])
            let spot = community[indexPath.row]
            let id = spot.id
            let like = spot.likes  + 1
            
            
            
        var requestParam = [String: String]()
            requestParam["action"] = "communitylike"
            requestParam["id"] = String(id)
            requestParam["like"] = String(like)
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        // 將輸入資料列印出來除錯用
                        print("input: \(String(data: data!, encoding: .utf8)!)")
                        
                        
                        
                        
                    }
                }
            }
        }
    }
    
    
}
