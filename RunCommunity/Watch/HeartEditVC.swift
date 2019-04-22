//
//  HealthEditVC.swift
//  RunCommunity
//
//  Created by PIG on 2019/4/6.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class HeartEditVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var hearts = [HeartDetail]()
    let url_server = URL(string: common_url + "WatchServlet")
    
    @IBOutlet weak var sUp: UISlider!
    @IBOutlet weak var sDown: UISlider!
    @IBOutlet weak var lUp: UILabel!
    @IBOutlet weak var lDown: UILabel!
    
    @IBOutlet weak var vUp: UIView!
    
    @IBOutlet weak var vDown: UIView!
    
    @IBOutlet var vHeartEdit: UIView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hearts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "heartEditCell", for: indexPath)
        cell.textLabel?.text = "心跳："+hearts[indexPath.row].sheart
        cell.detailTextLabel?.text = "日期： "+hearts[indexPath.row].stime
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            let indexHeart:String = self.hearts[indexPath.row].sheart
            let indexTime:String = self.hearts[indexPath.row].stime
            let id:Int = self.hearts[indexPath.row].id!
            self.showAlert(indexTime,indexHeart,id)
        }
        edit.backgroundColor = UIColor.lightGray
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(action,indexPath) in
            var requsetParam = [String: Any]()
            let id = self.hearts[indexPath.row].id
            requsetParam["action"] = "heartDetailEdit"
//            let userDefault = UserDefaults.standard
//            let userAccount = userDefault.string(forKey: "useraccount")
            let editDetail = EditHeart(id!, -1.0)
            requsetParam["heartDetailEdit"] = try! String(data: JSONEncoder().encode(editDetail), encoding: .utf8)
            watchExecuteTask(self.url_server!, requsetParam, completionHandler: { (data, reponse, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(bytes: data!, encoding: .utf8){
                            if let count = Int(result){
                                if count != 0{
                                    self.hearts.remove(at: indexPath.row)
                                    DispatchQueue.main.async {
                                        tableView.deleteRows(at: [indexPath], with: .fade)
                                    }
                                }
                            }
                        }
                    }
                }else{
                    print(error!.localizedDescription)
                }
            })
        })
        return [delete, edit]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLimitInit()
        vHeartEdit.addSubview(vUp)
        vHeartEdit.addSubview(vDown)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func bUpMax(_ sender: Any) {
        lUp.text = "220.0"
        sUp.value = Float(220.0)
    }
    
    @IBAction func bUpMid(_ sender: Any) {
        lUp.text = "155.0"
        sUp.value = Float(155.0)
    }
    
    @IBAction func bUpLow(_ sender: Any) {
        lUp.text = "90.0"
        sUp.value = Float(90.0)
    }
    
    @IBAction func bDownMax(_ sender: Any) {
        lDown.text = "90.0"
        sDown.value = Float(90.0)
    }
    
    @IBAction func bDownMid(_ sender: Any) {
        lDown.text = "60.0"
        sDown.value = Float(60.0)
    }
    
    @IBAction func bDownLow(_ sender: Any) {
        lDown.text = "0.0"
        sDown.value = Float(0.0)
    }
    
    
    @IBAction func aUp(_ sender: UISlider) {
        let slider = sender.value
        let value = String(format: "%.1f", slider)
        lUp.text = value
    }
    @IBAction func aDown(_ sender: UISlider) {
        let slider = sender.value
        let value = String(format: "%.1f", slider)
        lDown.text = value
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func setLimitInit(){
        let userDefault = UserDefaults.standard
        var heartUpperLimit:Double?
        var heartLowerLimit:Double?
        if userDefault.double(forKey: "heartUpperLimit") == 0.0{
            heartUpperLimit = 90
        }else{
            heartUpperLimit = userDefault.double(forKey: "heartUpperLimit")
        }
        if userDefault.double(forKey: "heartLowerLimit") == 0.0{
            heartLowerLimit = 60
        }else{
            heartLowerLimit = userDefault.double(forKey: "heartLowerLimit")
        }
        let up = String(format: "%.1f", heartUpperLimit!)
        let down = String(format: "%.1f", heartLowerLimit!)
        lUp.text = up
        lDown.text = down
        sUp.value = Float(heartUpperLimit!)
        sDown.value = Float(heartLowerLimit!)
    }
    override func viewWillDisappear(_ animated: Bool) {
        let up = lUp.text
        let down = lDown.text
        let userDefault = UserDefaults.standard
        let upNumber = Double(up!)
        let downNumber = Double(down!)
        userDefault.set(upNumber, forKey: "heartUpperLimit")
        userDefault.set(downNumber, forKey: "heartLowerLimit")
        userDefault.synchronize()
    }
    func showAlert(_ indextime:String,_ indexHeart:String,_ id:Int){
        let alertController = UIAlertController(title: "請輸入欲修改心跳", message: indextime, preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "心跳: "+indexHeart
        }
        let alertCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let alertOK = UIAlertAction(title: "確定", style: .default) { (action) in
            let h = alertController.textFields!.first!.text
            let heart = Double(h!)
//            let userDefault = UserDefaults.standard
//            let userAccount = userDefault.string(forKey: "useraccount")
            let editHeart = EditHeart(id, heart!)
            var requsetParam = [String: Any]()
            requsetParam["action"] = "heartDetailEdit"
            requsetParam["heartDetailEdit"] = try!String(bytes: JSONEncoder().encode(editHeart), encoding: .utf8)
            watchExecuteTask(self.url_server!, requsetParam, completionHandler: { (data, reponse, error) in
                if error == nil{
                    if data != nil{
                        if let result = String(bytes: data!, encoding: .utf8){
                            if let count = Int(result){
                                if count != 0{
                                    DispatchQueue.main.async {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            })
        }
        alertController.addAction(alertOK)
        alertController.addAction(alertCancel)
        self.present(alertController,animated: true, completion: nil)
        
    }
    
}
