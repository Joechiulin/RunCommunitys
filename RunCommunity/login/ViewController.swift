//
//  ViewController.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/7.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let userDefault = UserDefaults.standard
    @IBOutlet weak var tfpassword: UITextField!
    @IBOutlet weak var tfaccount: UITextField!
    let currentDate = Date()
    let dataFormatter = DateFormatter()
    
    let url_server = URL(string: common_url+"UserServlet")
    
    @IBOutlet weak var ivGif: UIImageView!
    
    @IBOutlet weak var bLogin: UIButton!
    
    @IBOutlet weak var bAdd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
        dataFormatter.locale = Locale(identifier: "zh_Hant_TW")
        dataFormatter.dateFormat = "YYYY-MM-dd"
        bAdd.clipsToBounds = true
        bAdd.layer.cornerRadius = 5
        bLogin.clipsToBounds = true
        bLogin.layer.cornerRadius = 5
        ivGif.loadGif(name: "devilRun")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    @IBAction func Login(_ sender: Any) {
        checkdata()
    }
    
    func checkdata()  {
        let useraccount = tfaccount.text == nil ? "" : tfaccount.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfpassword.text == nil ? "" : tfpassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if useraccount!.isEmpty || password!.isEmpty {
//            tvresult.text = "Account or password is invalid"
            self.showAlert("輸入格式錯誤","請輸入帳密")
            return
        }
        //        let user = User(account!, password!)
        //        let datas = try?String(bytes: JSONEncoder().encode(user), encoding: .utf8)
        let loginTime = dataFormatter.string(from: currentDate)
        var requestParam = [String: String]()
        requestParam["action"] = "userLogin"
        requestParam["useraccount"] = useraccount!
        requestParam["password"] = password!
        requestParam["time"] = loginTime
        executeTask(url_server!, requestParam, useraccount!, password!)
    }
    
    @IBAction func Addaccount(_ sender: Any) {
        
    }
    
    func executeTask(_ url_server: URL, _ requestParam: [String: String],_ account: String,_ password:String) {
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
                    let bol = String(data: data!, encoding: .utf8)
                    let bol1 = bol?.trimmingCharacters(in: .whitespaces)
                    print(bol1!)
                    if ( bol1 == "true"){
                        DispatchQueue.main.async {
                            self.userDefault.set(account, forKey: "useraccount")
                            self.userDefault.set(account, forKey: "userpassword")
                            self.userDefault.synchronize()
                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabbarview"){
                                self.present(controller, animated: true, completion: nil)
                            }
                        }
                    }
                    else{
                        self.dismiss(animated: true)
                        DispatchQueue.main.async {
                            self.showAlert("帳密錯誤","請確認帳密")
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
    }
    func showAlert(_ title:String,_ message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertError = UIAlertAction(title: "重新輸入", style: .cancel, handler: nil)
        alertController.addAction(alertError)
        self.present(alertController, animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(animated)
    }

    @IBAction func didEndOnExit(_ sender: Any) {
    }
    @IBAction func touchView(_ sender: Any) {
        view.endEditing(true)
    }
    
    func  addKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: Notification) {
        // 能取得鍵盤高度就讓view上移鍵盤高度，否則上移view的1/3高度
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -keyboardHeight 
        } else {
            view.frame.origin.y = -view.frame.height / 2
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
//extension ViewController{
//    func hidekeyboard(){
//        tfaccount.resignFirstResponder()
//        tfpassword.resignFirstResponder()
//    }
//}
