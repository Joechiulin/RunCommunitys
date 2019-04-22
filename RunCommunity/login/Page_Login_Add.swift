//
//  Page_Login_Add.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/3/25.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit
import Foundation

class Page_Login_Add: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var ivCreatePhoto: UIImageView!
    @IBOutlet weak var tfCreateAccount: UITextField!
    @IBOutlet weak var tfCreatePassword: UITextField!
    @IBOutlet weak var tfPasswordCheck: UITextField!
    @IBOutlet weak var tfCreateUserName: UITextField!
    @IBOutlet weak var tfCreatePhone: UITextField!
    @IBOutlet weak var tfCreateEmail: UITextField!
    @IBOutlet weak var tvResult: UITextView!
    
    var createPhoto: UIImage?
//    var user : [User]?
    let url_server = URL(string: common_url+"UserServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivCreatePhoto.image = UIImage(named: "headNoImage")
        createPhoto = UIImage(named: "headNoImage")
    }
    
    @IBAction func btAddPhoto(_ sender: Any) {
        imagePicker(type: .photoLibrary)
    }
    
    @IBAction func btCreate(_ sender: Any) {
        tvResult.text = ""
        createUser()
    }
    
    func imagePicker(type: UIImagePickerController.SourceType){
        let imagePickController = UIImagePickerController()
        imagePickController.sourceType = type
        imagePickController.delegate = self
        present(imagePickController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let Photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            createPhoto = Photo
            ivCreatePhoto.image = createPhoto
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func createUser()  {
        let account = tfCreateAccount.text == nil ? "" : tfCreateAccount.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfCreatePassword.text == nil ? "" : tfCreatePassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordCheck = tfPasswordCheck.text == nil ?"": tfPasswordCheck.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let userName = tfCreateUserName.text == nil ? "" : tfCreateUserName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = tfCreatePhone.text == nil ? "" : tfCreatePhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = tfCreateEmail.text == nil ? "" : tfCreateEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if account!.isEmpty || password!.isEmpty {
            tvResult.text = "Account or Password is invalid"
            return
        }
        if password != passwordCheck{
            tvResult.text = "兩次密碼不相同"
            return
        }
        if phone!.isEmpty || email!.isEmpty || userName!.isEmpty{
            tvResult.text = "phone , mail or UserName is invalid"
            return
        }
        
        if password == passwordCheck{
            let user = User(account!, password!, userName!, phone!, email!)
            let datas = try?String(bytes: JSONEncoder().encode(user), encoding: .utf8)
            
            var requestParam = [String: String]()
            
            requestParam["action"] = "userInsert"
            requestParam["user"] = datas!
            requestParam["account"] = account!
            if self.createPhoto != nil {
                requestParam["imageBase64"] = self.createPhoto!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
            }
            executeTask(url_server!, requestParam)
        }
    }
    
    func executeTask(_ url_server: URL, _ requestParam: [String: String]) {
        // 將輸出資料列印出來除錯用
        print("output: OK")
        
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
                    if ( bol1  ==  "1"){
                        DispatchQueue.main.async {
                            self.tvResult.text.append("註冊成功")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.tvResult.text.append("註冊失敗：帳號重複")
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
