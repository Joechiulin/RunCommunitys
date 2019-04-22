//
//  InsertViewController.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/10.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class InsertVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let url_server = URL(string: common_url + "WatchServlet")
    
    @IBOutlet weak var bSubmit: UIButton!
    
    @IBOutlet weak var tvInsert: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bSubmit.clipsToBounds = true
        bSubmit.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "insertHeartCell", for: indexPath)
            return cell
            
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "insertBloodCell", for: indexPath)
            return cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "insertSleepCell", for: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "insertCell", for: indexPath)
            return cell
        }
    }
    func addKeyboardObserve(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: Notification){
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y =  -keyboardHeight/2
        }else{
            view.frame.origin.y = -view.frame.height/3
        }
    }
    @objc func keyboardWillHide(notification: Notification){
        view.frame.origin.y = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

    
    @IBAction func bSubmit(_ sender: Any) {
        getInfo()
    }
    
    
    func getInfo(){
        let heartIndex = IndexPath(row: 0, section: 0)
        let heartCell: InsertTVCell = self.tvInsert.cellForRow(at: heartIndex) as! InsertTVCell
        let heartBeat = heartCell.tfHeartBeat.text == nil || heartCell.tfHeartBeat.text!.isEmpty ? "-1":
            heartCell.tfHeartBeat.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //        let heartBeat = Float(h)
        let bloodIndex = IndexPath(row: 1, section: 0)
        let bloodCell: InsertTVCell = self.tvInsert.cellForRow(at: bloodIndex) as! InsertTVCell
        let bloodOxygen = bloodCell.tfBloodOxygen.text == nil || bloodCell.tfBloodOxygen.text!.isEmpty ? "-1":
            bloodCell.tfBloodOxygen.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let sleepIndex = IndexPath(row: 2, section: 0)
        let sleepCell: InsertTVCell = self.tvInsert.cellForRow(at: sleepIndex) as! InsertTVCell
        let sleep = sleepCell.tfSleep.text == nil || sleepCell.tfSleep.text!.isEmpty ? "-1":
            sleepCell.tfSleep.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            String((Int(tfSleep.text!.trimmingCharacters(in: .whitespacesAndNewlines))!)*3600000)
        let deepIndex = IndexPath(row: 3, section: 0)
        let deepCell: InsertTVCell = self.tvInsert.cellForRow(at: deepIndex) as! InsertTVCell
        let deepSleep = deepCell.tfDeepSleep.text == nil || deepCell.tfDeepSleep.text!.isEmpty ? "-1":   deepCell.tfDeepSleep.text!.trimmingCharacters(in: .whitespacesAndNewlines)//            String((Int(tfDeepSleep.text!.trimmingCharacters(in: .whitespacesAndNewlines))!)*3600000)
        var requseParam = [String: Any]()
        let userDefault = UserDefaults.standard
        let userAccount = userDefault.string(forKey: "useraccount")
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: today)
        let allInsert = AllInsert(0, userAccount!, heartBeat, bloodOxygen, sleep, deepSleep, date)
        requseParam["action"] = "allInsert"
        requseParam["allInsert"] = try!String(data: JSONEncoder().encode(allInsert), encoding: .utf8)
        executeTask(url_server!, requseParam) { (data, reponse, error) in
            if error == nil{
                if data != nil{
                    if let result = String(bytes: data!, encoding: .utf8){
                        if let count = Int(result){
                            DispatchQueue.main.async {
                                if count != 0{
                                self.navigationController?.popViewController(animated: true)
                                }else{
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    @IBAction func returnClose(_ sender: Any) {
    }
    
    @IBAction func touchView(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func addKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
extension InsertVC{
    func hidekeyboard(){
        let heartIndex = IndexPath(row: 0, section: 0)
        let heartCell: InsertTVCell = self.tvInsert.cellForRow(at: heartIndex) as! InsertTVCell
        heartCell.tfHeartBeat.resignFirstResponder()
        let bloodIndex = IndexPath(row: 1, section: 0)
        let bloodCell: InsertTVCell = self.tvInsert.cellForRow(at: bloodIndex) as! InsertTVCell
        bloodCell.tfBloodOxygen.resignFirstResponder()
        let sleepIndex = IndexPath(row: 2, section: 0)
        let sleepCell: InsertTVCell = self.tvInsert.cellForRow(at: sleepIndex) as! InsertTVCell
        sleepCell.tfSleep.resignFirstResponder()
        let deepIndex = IndexPath(row: 3, section: 0)
        let deepCell: InsertTVCell = self.tvInsert.cellForRow(at: deepIndex) as! InsertTVCell
        deepCell.tfDeepSleep.resignFirstResponder()
    }
    
}

