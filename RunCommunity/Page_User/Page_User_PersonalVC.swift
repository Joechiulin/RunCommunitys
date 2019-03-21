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
    @IBOutlet weak var lbUserAge: UILabel!
    @IBOutlet weak var lbTotalTime: UILabel!
    @IBOutlet weak var lbTotalDistance: UILabel!
    @IBOutlet weak var lbTotalCalories: UILabel!
    
    let url_server = URL(string: "http://127.0.0.1:8080/ExIosLogin/UserPersonalPage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btUserPhoto.layer.cornerRadius=self.btUserPhoto.frame.size.width / 2;
        self.btUserPhoto.clipsToBounds = true;
        
        //假資料測試用
        let account = "a123"
        var requestParam = [String: String]()
        requestParam["account"] = account
        executeTask(url_server!, requestParam)
    }
    
    func executeTask(_ url_server: URL, _ requestParam: [String: String]) {
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
        if let result = try? JSONDecoder().decode([String: String].self, from: jsonData) {
            let account = result["sqlaccount"]!
            let userName = result["sqluserName"]!
            let userAge = result["sqluserAge"]!
            let totalTime = result["sqltotalTime"]!
            let totalDistance = result["sqltotalDistance"]!
            let totalCalories = result["sqltotalCalories"]!
            
            lbUserName.text = userName
            lbUserAge.text = userAge
            lbTotalTime.text = totalTime
            lbTotalDistance.text = totalDistance
            lbTotalCalories.text = totalCalories
            
            self.userDefault.set(userName, forKey: "username")
            self.userDefault.synchronize()
        } else {
            
        }
    }
    
}
