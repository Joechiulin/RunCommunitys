//
//  addnewaccount.swift
//  RunCommunity
//
//  Created by Joe on 2019/3/13.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
import UIKit

class Addnewaccount: UIViewController {
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var tfaccount: UITextField!
    
    @IBOutlet weak var tfpassword: UITextField!
    
    @IBOutlet weak var tfpasswordck: UITextField!
    
    @IBOutlet weak var tfphone: UITextField!
    
    @IBOutlet weak var tfmail: UITextField!
    @IBOutlet weak var tvresult: UITextView!
    let url_server = URL(string: "http://127.0.0.1:8080/ServerConnect_Web/ServerConnectServlet")

    var persons : [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btAdd(_ sender: Any) {
        checkdata()
    }
    func checkdata()  {
        let userName = tfaccount.text == nil ? "" : tfaccount.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfpassword.text == nil ? "" : tfpassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordcheck = tfpasswordck.text == nil ?"": tfpasswordck.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = tfphone.text == nil ? "" : tfphone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = tfmail.text == nil ? "" : tfmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
     //   let persons = Person(userName!, password!, phone!, mail!)
        
        
        if userName!.isEmpty || password!.isEmpty {
            tvresult.text = "user name or password is invalid"
            return
        }
        if password != passwordcheck{
            tvresult.text = "密碼確認錯誤"
            return
        }
        if phone!.isEmpty || email!.isEmpty{
            tvresult.text = "phone  or mail is invalid"
            return
        }
        
        //        savedata()
        if password == passwordcheck{
        let persons = Person(userName!, password!, phone!, email!)
            let datas = try?String(bytes: JSONEncoder().encode(persons), encoding: .utf8)
            
        var requestParam = [String: String]()
        
        requestParam["action"] = "insert"
        requestParam["persons"] = datas!
        executeTask(url_server!, requestParam)
        }
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
                    //                    if let result  =
                    
                    let bol = String(data: data!, encoding: .utf8)
                    let bol1 = bol?.trimmingCharacters(in: .whitespaces)
                    print(bol1!)
                    
                    if ( bol1  ==  "true\n"){
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickview")
                        
                        self.present(viewController, animated: false, completion: nil)
                        
                        
                        
                        // 將結果顯示在UI元件上必須轉給main thread
//                        DispatchQueue.main.async {
//                  /         self.showResult(data!)
//                        }}
                        
                    }
                    else{
                        self.dismiss(animated: true)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
    }
}

