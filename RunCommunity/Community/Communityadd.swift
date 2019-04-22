//
//  Communityadd.swift
//  RunCommunity
//
//  Created by Joe on 2019/3/25.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit
import CoreLocation

class Communityadd: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    let userDefault = UserDefaults.standard
   // let url_server = URL(string: "http://127.0.0.1:8080/ServerConnect_Web/ServerConnectServlet")
    let url_server = URL(string: common_url + "ServerConnectServlet")

    let dateFormatter = DateFormatter() //實體化日期格式化物件
    let currentDate = Date()

    @IBOutlet weak var lbtime: UILabel!
    @IBOutlet weak var lbusername: UILabel!
    @IBOutlet weak var ivuserphoto: UIImageView!
    @IBOutlet weak var ivpick: UIImageView!
    
    @IBOutlet weak var tfte: UITextView!
    var comuser: Comuser?
    

    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        showcomuser()
        addKeyboardObserver()

    }
    @IBAction func btnew(_ sender: Any) {
        let text = tfte.text == nil ? "" : tfte.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let  account = self.userDefault.string(forKey: "useraccount")
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        dateFormatter.dateFormat = "YYYY年MM月dd日"
        let stringDate = dateFormatter.string(from: currentDate)
 
        let community = Comin(text,account!, stringDate)
            
            var requestParam = [String: String]()
            requestParam["action"] = "communityInsert"
            requestParam["community"] = try! String(data: JSONEncoder().encode(community), encoding: .utf8)
            // 有圖才上傳
            if self.image != nil {
                requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
            }
            executeTask(self.url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                DispatchQueue.main.async {
                                    // 新增成功則回前頁
                                    if count != 0 {                                            self.navigationController?.popViewController(animated: true)
                                    } else {
                                        print("insert fail")
                                    }
                                }
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
    }
    
    


    
    
    @IBAction func pickpicture(_ sender: Any) {
        imagePicker(type: .photoLibrary)

    }
    
    func imagePicker(type: UIImagePickerController.SourceType) {
        hideKeyboard()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let RunImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = RunImage
            ivpick.image = RunImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func hideKeyboard() {
        tfte.resignFirstResponder()
      
    }
    @objc func keyboardWillShow(notification: Notification) {
        // 能取得鍵盤高度就讓view上移鍵盤高度，否則上移view的1/3高度
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -keyboardHeight / 2
        } else {
            view.frame.origin.y = -view.frame.height / 3
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
    @objc func showcomuser() {
         let  account = self.userDefault.string(forKey: "useraccount")
   
        var requestParam = [String: String]()
        requestParam["action"] = "getuser"
        requestParam["account"] = account
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")



                    if let result = try? JSONDecoder().decode([String:String].self, from: data!) {
                        DispatchQueue.main.async {
                            self.lbusername.text = result["sqlname"]
                            self.lbtime.text = result["sqldate"]
                        }
                        /* 抓到資料後重刷table view */

                    }
                }
            }
        }
    
        var requesttParame = [String: Any]()
        requesttParame["action"] = "getuserImage"
        requesttParame["account"] = account
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
                    self.ivuserphoto.image = imagedate
                    
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    func  addKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   

//    @IBAction func tuchview(_ sender: Any) {
//        view.endEditing(true)
//    }
   
    @IBAction func touchView(_ sender: Any) {
    view.endEditing(true)
    }
    //    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(true)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
}

extension ViewController{
    func hidekeyboard(){
        tfaccount.resignFirstResponder()
        tfpassword.resignFirstResponder()
    }
}

