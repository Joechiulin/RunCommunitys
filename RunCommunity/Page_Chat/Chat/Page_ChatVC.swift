//
//  Page_ChatVC.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/3/21.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit
import Starscream

class Page_ChatVC: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    var tbvChatMessage = [ChatMessage]()
    let tag = "Page_ChatVC"
    var socket: WebSocket!
    var friend: String!
    var friendName: String!
    var image: UIImage!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    let url_server = "ws://127.0.0.1:8080/RunCommunity2/ChatMessageServlet/"
    let userDefults = UserDefaults.standard
    @IBOutlet var tbvMessage: UITableView!
    @IBOutlet weak var tfMessage: UITextField!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tbvChatMessage.count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvMessage.delegate = self
        tbvMessage.dataSource = self
        getFriendInfo()
        socket = WebSocket(url: URL(string: url_server + userDefults.string(forKey: "userAccount")!)!)
        
        addKeyboardObserver()
        addSocketCallBacks()
        socket.connect()
    }
    
    func getFriendInfo(){
        var reParam = [String: Any]()
        reParam["action"] = "getUserName"
        reParam["account"] = friend!
        executeTask(URL(string: common_url+"FriendsServlet")!, reParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    print("inputUserName: \(String(data: data!, encoding: .utf8)!)")
                    DispatchQueue.main.async {
                        self.friendName = String(data: data!, encoding: .utf8)!
                        self.navigationBar.topItem!.title =  self.friendName
                    }
                    
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
        
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getUserImage"
        requestParam["account"] = friend
        requestParam["imageSize"] = 60
        executeTask(URL(string: common_url+"FriendsServlet")!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    self.image = UIImage(data: data!)
                }
                DispatchQueue.main.async {
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getAllMessage()
    }
    
    @objc func getAllMessage(){
        let url_server = URL(string: common_url + "FindMessageServlet")
        var requestParam = [String: String]()
        requestParam["action"] = "findAllMessage"
        requestParam["sender"] = userDefults.string(forKey: "userAccount")
        requestParam["receiver"] = friend!
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode([ChatMessage].self, from: data!){
                        self.tbvChatMessage = result
                        DispatchQueue.main.async {
                            self.tbvMessage.reloadData()
                            if self.tbvChatMessage.count != 0{
                                let index = IndexPath(row: self.tbvChatMessage.count - 1, section: 0)
                                self.tbvMessage.scrollToRow(at: index, at: .bottom, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btCancel(_ sender: Any) {
        dismiss(animated: true, completion:nil)
    }
    
    // 也可使用closure偵測WebSocket狀態
    func addSocketCallBacks() {
        socket.onText = {(text: String) in
            if let chatMessage = try? JSONDecoder().decode(ChatMessage.self, from: text.data(using: .utf8)!) {
                // 接收到聊天訊息，若發送者與目前聊天對象相同，就將訊息顯示在TextView
                self.tbvChatMessage.append(chatMessage)
                self.tbvMessage.reloadData()
                if self.tbvChatMessage.count != 0 {
                    self.tbvMessage.scrollToRow(at: IndexPath(row: self.tbvChatMessage.count - 1, section: 0), at: .bottom,animated: false)
                }
            }
            //            print("\(self.tag) got some text: \(text)")
        }
    }
    
    @IBAction func clickSend(_ sender: Any) {
        let message = tfMessage.text
        if message == nil || message!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        let sender = self.userDefults.string(forKey: "userAccount")
        let chatMessage = ChatMessage(type: "chat", sender: sender!, receiver: friend!, message: message!)
        if let jsonData = try? JSONEncoder().encode(chatMessage) {
            let text = String(data: jsonData, encoding: .utf8)
            self.socket.write(string: text!)
            // debug用
            print("\(tag) send messages: \(text!)")
            tbvChatMessage.append(chatMessage)
            tbvMessage.reloadData()
            
            if self.tbvChatMessage.count > 0 {
                tbvMessage.scrollToRow(at: IndexPath(row: self.tbvChatMessage.count - 1, section: 0), at: .bottom,animated: false)
            }
            print(tbvChatMessage.count)
            
            tfMessage.text = nil
        }
        
        var requestParam = [String: String]()
        let url_server = URL(string: common_url + "FindMessageServlet")
        requestParam["action"] = "insert"
        requestParam["mes"] = try! String(data: JSONEncoder().encode(chatMessage), encoding: .utf8)
        executeTask(url_server!, requestParam) {(data, response, error) in
            if error == nil {
                if data != nil {
                    print(data!)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatMessage = tbvChatMessage[indexPath.row]
        print(chatMessage)
        if chatMessage.sender == self.userDefults.string(forKey: "userAccount") {
            let cell : UserMessageCell
            cell = tableView.dequeueReusableCell(withIdentifier: "UserMessageCell",for: indexPath) as! UserMessageCell
            cell.tvUserMessage?.text = tbvChatMessage[indexPath.row].message
            return cell
        }else{
            let cell : FriendMessageCell
            cell = tableView.dequeueReusableCell(withIdentifier: "FriendMessageCell",for: indexPath) as! FriendMessageCell
            //            cell.ivFriendImage.image = UIImage(named: "chat")
            //            cell.tvFriendName?.text = tbvChatMessage[indexPath.row].sender
            cell.tvFriendMessage?.text = tbvChatMessage[indexPath.row].message
            cell.ivFriendImage.image = image
            cell.tvFriendName.text = friendName
            cell.ivFriendImage.layer.cornerRadius = cell.ivFriendImage.frame.width/2
            return cell
        }
    }
    
    
    
    
    @IBAction func didEndOnExit(_ sender: Any) {
    }
    
}

extension Page_ChatVC {
    func addKeyboardObserver() {
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
}
