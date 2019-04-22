//
//  RuninsertiVC.swift
//  RunCommunity
//
//  Created by Joe on 2019/4/14.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class RuninsertiVC: UIViewController,UIImagePickerControllerDelegate
,UINavigationControllerDelegate {
    let url_server = URL(string: common_url + "ServerConnectServlet")

    
    let userDefault = UserDefaults.standard
   // let url_server = URL(string: "http://127.0.0.1:8080/ServerConnect_Web/ServerConnectServlet")
    @IBOutlet weak var lbpace: UILabel!
    @IBOutlet weak var lbdistance: UILabel!
    @IBOutlet weak var lbtime: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var mapvw: UIView!
    @IBOutlet weak var testfl: UITextView!
    @IBOutlet weak var datelb: UILabel!
    @IBOutlet weak var namelb: UILabel!
    @IBOutlet weak var userimage: UIImageView!
    var imagepick: UIImage?
    let currentDate = Date()
    let dateFormatter = DateFormatter() //實體化日期格式化物件
    var distance:String = ""
    var time:String = ""
    var pace:String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showcomuser()
        showrundetal()
        runimagetake()
    }
    @IBAction func insertbutton(_ sender: Any) {
        
        let text = testfl.text == nil ? "" : testfl.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let  account = self.userDefault.string(forKey: "useraccount")
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        dateFormatter.dateFormat = "YYYY年MM月dd日"
        let date = dateFormatter.string(from: currentDate)
        
        let community = Comin(text,account!, date)
        
        var requestParam = [String: String]()
        requestParam["action"] = "communityInsert"
        requestParam["community"] = try! String(data: JSONEncoder().encode(community), encoding: .utf8)
        // 有圖才上傳
        imagepick = takeSnapshotOfView(view: mapvw)
     //   imagepick = self.image.image
        if self.imagepick != nil {
            requestParam["imageBase64"] = self.imagepick!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
        executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {
                                    self.dismiss(animated: true, completion: nil)
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
    func takeSnapshotOfView(view:UIView) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: view.frame.size.width, height: view.frame.size.height))
        view.drawHierarchy(in: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func showrundetal()  {
        lbtime.text = time
        lbdistance.text = distance
        lbpace.text = pace
    }
    
    func runimagetake()  {
        let  account = self.userDefault.string(forKey: "useraccount")
        var requesttParame = [String: Any]()
        requesttParame["action"] = "getrunImage"
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
                    self.image.image = imagedate
                    
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func pickimagebutton(_ sender: Any) {
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
            imagepick = RunImage
            image.image = RunImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func hideKeyboard() {
        testfl.resignFirstResponder()
        
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
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        dateFormatter.dateFormat = "YYYY年MM月dd日"
        let stringDate = dateFormatter.string(from: currentDate)
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
                            self.namelb.text = result["sqlname"]
                            self.datelb.text = stringDate
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
                    self.userimage.image = imagedate
                    
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}
