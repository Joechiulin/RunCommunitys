//
//  Page_User_PersonalVC.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/3/20.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class Page_User_PersonalVC: UIViewController {
    let userDefault = UserDefaults.standard
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var btUserPhoto: UIButton!
    @IBOutlet weak var lbUserCreateDate: UILabel!
    @IBOutlet weak var lbTotalTime: UILabel!
    @IBOutlet weak var lbTotalDistance: UILabel!
    @IBOutlet weak var lbTotalCalories: UILabel!
    let url_server = URL(string: common_url+"UserServlet")
    let url_serverrun = URL(string: common_url + "ServerConnectServlet")
    var Rundetal   = [Runn]()

    override func viewDidLoad() {
        super.viewDidLoad()
        takerundetal()
    
    self.btUserPhoto.layer.cornerRadius=self.btUserPhoto.frame.size.width / 2;
        self.btUserPhoto.clipsToBounds = true;
        
        let account = userDefault.string(forKey: "useraccount")
        
        var requestParam = [String: String]()
        requestParam["action"] = "getUserName"
        requestParam["account"] = account
        executeTasks(url_server!, requestParam)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var photoParam = [String: String]()
        photoParam["action"] = "getImageForUserName"
        photoParam["account"] = userDefault.string(forKey: "useraccount")
        photoTask(url_server!, photoParam)
    }
    func takerundetal(){
        
        var requestParams = [String: String]()

        requestParams = ["action" : "getrundetal"]
        requestParams["account"] = userDefault.string(forKey: "useraccount")
        executeTask(url_serverrun!, requestParams) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("inputtime: \(String(data: data!, encoding: .utf8)!)")
                    
                    
                    
                    if let result = try? JSONDecoder().decode([String:String].self, from: data!) {
                        DispatchQueue.main.async {
                            self.lbTotalDistance.text = result["distance"]
                            self.lbTotalTime.text = result["time"]
                                }
                            }
                    
                    
                    }
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    func executeTasks(_ url_server: URL, _ requestParam: [String: String]) {
        print("output: \(requestParam)")
        let jsonData = try! JSONEncoder().encode(requestParam)
        var request = URLRequest(url: url_server)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if data != nil {
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    DispatchQueue.main.async {
                        self.showDetail(data!)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
    }
    
    func showDetail(_ jsonData: Data) {
        if let result = try? JSONDecoder().decode(User.self, from: jsonData) {
            lbUserName.text = result.username!
            lbUserCreateDate.text = "最後修改時間：\(result.timestamp!)"
            lbTotalTime.text = result.phone
            lbTotalDistance.text = result.email
        }
    }
    
    func photoTask(_ url_server: URL, _ photoParam: [String: String]) {
        print("output: \(photoParam)")
        let jsonData = try! JSONEncoder().encode(photoParam)
        var request = URLRequest(url: url_server)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if data != nil {
                    DispatchQueue.main.async {
                        self.showPhoto(UIImage(data: data!)!)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
    }
    
    func showPhoto(_ image:UIImage){
        btUserPhoto.setImage(image, for: .normal)
    }
}
