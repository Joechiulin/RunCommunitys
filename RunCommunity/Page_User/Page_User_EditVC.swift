//
//  Page_User_EditVC.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/4/13.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class Page_User_EditVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var ivUpdatePhoto: UIImageView!
    @IBOutlet weak var lbUserAccount: UILabel!
    @IBOutlet weak var tfUpdatePassword: UITextField!
    @IBOutlet weak var tfPasswordCheck: UITextField!
    @IBOutlet weak var tfUpdateUserName: UITextField!
    @IBOutlet weak var tfUpdatePhone: UITextField!
    @IBOutlet weak var tfUpdateEmail: UITextField!
    @IBOutlet weak var tvResult: UITextView!
    
    var updatePhoto: UIImage?
    let url_server = URL(string: common_url+"UserServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbUserAccount.text = userDefaults.string(forKey: "useraccount")
        
        var photoParam = [String: String]()
        photoParam["action"] = "getImageForUserName"
        photoParam["account"] = userDefaults.string(forKey: "useraccount")
        executeTask(url_server!, photoParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    DispatchQueue.main.async {
                        self.ivUpdatePhoto.image = UIImage(data: data!)
                        self.updatePhoto = UIImage(data: data!)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        var requestParam = [String: String]()
        requestParam["action"] = "getUserInfo"
        requestParam["account"] = userDefaults.string(forKey: "useraccount")
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    let user = try? JSONDecoder().decode(User.self, from: data!)
                    DispatchQueue.main.async {
                        self.tfUpdateUserName.text = user?.username
                        self.tfUpdatePhone.text = user?.phone
                        self.tfUpdateEmail.text = user?.email
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    @IBAction func btAddPhoto(_ sender: Any) {
        imagePicker(type: .photoLibrary)
    }
    
    @IBAction func btDone(_ sender: Any) {
        tvResult.text = ""
        updateUser()
    }
    
    func imagePicker(type: UIImagePickerController.SourceType){
        let imagePickController = UIImagePickerController()
        imagePickController.sourceType = type
        imagePickController.delegate = self
        present(imagePickController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let Photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            updatePhoto = Photo
            ivUpdatePhoto.image = updatePhoto
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUser()  {
        let account = userDefaults.string(forKey: "useraccount")
        let password = tfUpdatePassword.text == nil ? "" : tfUpdatePassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordCheck = tfPasswordCheck.text == nil ?"": tfPasswordCheck.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let userName = tfUpdateUserName.text == nil ? "" : tfUpdateUserName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = tfUpdatePhone.text == nil ? "" : tfUpdatePhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = tfUpdateEmail.text == nil ? "" : tfUpdateEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if password!.isEmpty {
            tvResult.text = "Password is invalid"
            return
        }
        if password != passwordCheck{
            tvResult.text = "密碼確認錯誤"
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
            requestParam["action"] = "userUpdate"
            requestParam["user"] = datas!
            requestParam["account"] = userDefaults.string(forKey: "useraccount")
            if self.updatePhoto != nil {
                requestParam["imageBase64"] = self.updatePhoto!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
            }
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        let bol = String(data: data!, encoding: .utf8)?.trimmingCharacters(in: .whitespaces)
                        if ( bol  ==  "1"){
                            DispatchQueue.main.async {
                                self.tvResult.text.append("修改成功")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.tvResult.text.append("修改失敗")
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    @IBAction func viewTouch(_ sender: Any) {
        view.endEditing(true)
    }
}
