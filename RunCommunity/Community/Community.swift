//
//  Community.swift
//  RunCommunity
//
//  Created by Joe on 2019/3/15.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit



class Community: UITableViewController {
    var community = [Comm]()
//    let url_server = URL(string: common_url + "SpotServlet")
    let url_server = URL(string: "http://127.0.0.1:8080/ServerConnect_Web/ServerConnectServlet")

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
        let cellId = "spotCell"
        // tableViewCell預設的imageView點擊後會改變尺寸，所以建立UITableViewCell子類別SpotCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! Communitycell
        let spot = community[indexPath.row]
        
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = spot.id
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = cell.frame.width / 4
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async { cell.ivuser.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        cell.lbusername.text = spot.name
        cell.lbuserlocation.text = spot.location
        cell.tftext.text = spot.tvtext
        return cell
    }
    
    // 左滑修改與刪除資料
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        // 左滑時顯示Edit按鈕
//        let edit = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
//            let spotUpdateVC = self.storyboard?.instantiateViewController(withIdentifier: "spotUpdateVC") as! SpotUpdateVC
//            let spot = self.spots[indexPath.row]
//            spotUpdateVC.spot = spot
//            self.navigationController?.pushViewController(spotUpdateVC, animated: true)
//        })
//        edit.backgroundColor = UIColor.lightGray
//
//        // 左滑時顯示Delete按鈕
//        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
//            // 尚未刪除server資料
//            var requestParam = [String: Any]()
//            requestParam["action"] = "spotDelete"
//            requestParam["spotId"] = self.spots[indexPath.row].id
//            executeTask(self.url_server!, requestParam
//                , completionHandler: { (data, response, error) in
//                    if error == nil {
//                        if data != nil {
//                            if let result = String(data: data!, encoding: .utf8) {
//                                if let count = Int(result) {
//                                    // 確定server端刪除資料後，才將client端資料刪除
//                                    if count != 0 {
//                                        self.spots.remove(at: indexPath.row)
//                                        DispatchQueue.main.async {
//                                            tableView.deleteRows(at: [indexPath], with: .fade)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    } else {
//                        print(error!.localizedDescription)
//                    }
//            })
//        })
//        return [delete, edit]
//    }
    
    /* 因為拉UITableViewCell與detail頁面連結，所以sender是UITableViewCell */
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "spotDetail" {
//            /* indexPath(for:)可以取得UITableViewCell的indexPath */
//            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
//            let spot = community[indexPath!.row]
//            let detailVC = segue.destination as! SpotDetailVC
//            detailVC.spot = spot
//        }
//    }
//}


    
    

    @IBAction func btlike(_ sender: Any) {
    }
    

}
