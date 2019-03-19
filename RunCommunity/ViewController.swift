//
//  ViewController.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/7.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tfpassword: UITextField!
    @IBOutlet weak var tfaccount: UITextField!
    let url_server = URL(string: "http://127.0.0.1:8080/ServerConnect_Web/ServerConnectServlet")

    @IBOutlet weak var tvresult: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func Login(_ sender: Any) {
        checkdata()
    }
    
    func checkdata()  {
        let userName = tfaccount.text == nil ? "" : tfaccount.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfpassword.text == nil ? "" : tfpassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if userName!.isEmpty || password!.isEmpty {
            tvresult.text = "user name or password is invalid"
            return
        }
        let persons = Person(userName!, password!)
        let datas = try?String(bytes: JSONEncoder().encode(persons), encoding: .utf8)
        
        //        savedata()
        var requestParam = [String: String]()
        requestParam["data"] = datas!
        requestParam["action"] = "login"
        executeTask(url_server!, requestParam)
    }
    @IBAction func Addaccount(_ sender: Any) {
        
    }
    func executeTask(_ url_server: URL, _ requestParam: [String: String]) {
        // 將輸出資料列印出來除錯用
        print("output: \(requestParam)")
        
        let jsonData = try! JSONEncoder().encode(requestParam)
        var request = URLRequest(url: url_server)
        request.httpMethod = "POST"
        // 不使用cache
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        // 請求參數為JSON data，無需再轉成JSON字串
        request.httpBody = jsonData
        let session = URLSession.shared
        // 建立連線並發出請求，取得結果後會呼叫closure執行後續處理
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print(data!)
                    
                    let bol = String(data: data!, encoding: .utf8)
                    let bol1 = bol?.trimmingCharacters(in: .whitespaces)
                    print(bol1!)
                    
                    if ( bol1 == "\"true\""){
//                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarview")
                         DispatchQueue.main.async {if let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabbarview"){
                          
                            self.present(controller, animated: true, completion: nil)
                            }}
//                        self.present(viewController, animated: false, completion: nil)
                        // 將結果顯示在UI元件上必須轉給main thread
                        }
                    else{
                        self.dismiss(animated: true)
                        DispatchQueue.main.async {
                            self.tvresult.text.append("帳號錯誤")
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
    }
    
}

