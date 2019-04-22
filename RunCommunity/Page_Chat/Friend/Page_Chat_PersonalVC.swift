//
//  Page_Chat_PersonalVC.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/4/11.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit
import Starscream

class Page_Chat_PersonalVC: UIViewController {
    var user :User!
    var image :UIImage!
    var socket: WebSocket!
    let url_server = "ws://127.0.0.1:8080/RunCommunity2/FriendsServlet"
    let userDefaults = UserDefaults.standard
    var sender :String!
    let url = URL(string: common_url+"FriendsServlet")
    @IBOutlet weak var ivUserImage: UIImageView!
    @IBOutlet weak var lbUserAccount: UILabel!
    
    @IBOutlet weak var btInvite: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user.username
        lbUserAccount.text = "帳號：\(user.account!)"
        ivUserImage.image = image
//        showImage()
        sender = self.userDefaults.string(forKey: "useraccount")
        socket = WebSocket(url: URL(string: url_server+sender)!)
        socket.connect()
        // Do any additional setup after loading the view.
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getUserImage"
        requestParam["account"] = user.account
        requestParam["imageSize"] = 60
        
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    self.image = UIImage(data: data!)
                }
                DispatchQueue.main.async {
                    self.ivUserImage.image = self.image
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        var reParam = [String:String]()
        reParam["action"] = "checkInvite"
        reParam["userAccount"] = userDefaults.string(forKey: "useraccount")
        reParam["friendAccount"] = user.account!
        executeTask(url!, reParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    let result = try? JSONDecoder().decode(Friends.self, from: data!)
                    if result?.status == "1" {
                        print("check : \(result!.status!)")
                        DispatchQueue.main.async {
                            self.btInvite.isEnabled = false
                            self.btInvite.setTitle("已成為好友", for: .normal)
                        }
                    }else if result?.status == "0"{
                        print("check : \(result!.status!)")
                        DispatchQueue.main.async {
                            self.btInvite.isEnabled = false
                            self.btInvite.setTitle("已發送邀請", for: .normal)
                        }
                    }else{
                        print("check nil")
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    
    @IBAction func btInvite(_ sender: Any) {
        
        var requestParam = [String:String]()
        requestParam["action"] = "inviteFriend"
        requestParam["userAccount"] = userDefaults.string(forKey: "useraccount")
        requestParam["friendAccount"] = user.account!
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    DispatchQueue.main.async {
                      self.viewDidLoad()
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
}
