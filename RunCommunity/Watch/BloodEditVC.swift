//
//  BloodEditVC.swift
//  RunCommunity
//
//  Created by PIG on 2019/4/9.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class BloodEditVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var bloods = [BloodDetail]()
    let url_server = URL(string: common_url + "WatchServlet")

    @IBOutlet weak var lDwon: UILabel!
    
    @IBOutlet weak var sDown: UISlider!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bloods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bloodEditCell", for: indexPath)
        cell.textLabel?.text = "血氧："+bloods[indexPath.row].sBloodOxygen
        cell.detailTextLabel?.text = "日期： "+bloods[indexPath.row].stime
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            let indexHeart:String = self.bloods[indexPath.row].sBloodOxygen
            let indexTime:String = self.bloods[indexPath.row].stime
            let id:Int = self.bloods[indexPath.row].id!
            self.showAlert(indexTime,indexHeart,id)
        }
        edit.backgroundColor = UIColor.lightGray
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(action,indexPath) in
            var requsetParam = [String: Any]()
            requsetParam["action"] = "bloodDetailEdit"
            let id = self.bloods[indexPath.row].id
//            let userDefault = UserDefaults.standard
//            let userAccount = userDefault.string(forKey: "useraccount")
            let editBlood = EditBlood(id!,-1.0)
            requsetParam["bloodDetailEdit"] = try! String(data: JSONEncoder().encode(editBlood), encoding: .utf8)
            watchExecuteTask(self.url_server!, requsetParam, completionHandler: { (data, reponse, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(bytes: data!, encoding: .utf8){
                            if let count = Int(result){
                                if count != 0{
                                    self.bloods.remove(at: indexPath.row)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    */
    @IBAction func bDownMin(_ sender: Any) {
        lDwon.text = "0.0"
        sDown.value = Float(0.0)
    }
    @IBAction func bDownMid(_ sender: Any) {
        lDwon.text = "45.0"
        sDown.value = Float(45.0)
    }
    @IBAction func bDownMax(_ sender: Any) {
        lDwon.text = "90.0"
        sDown.value = Float(90.0)
    }
    @IBAction func sDown(_ sender: UISlider) {
        let slider = sender.value
        let value = String(format: "%.1f", slider)
        lDwon.text = value
    }
    override func viewWillDisappear(_ animated: Bool) {
        let down = lDwon.text
        let userDefault = UserDefaults.standard
        let downNumber = Double(down!)
        userDefault.set(downNumber, forKey: "bloodLowerLimit")
        userDefault.synchronize()
    }
    func showAlert(_ indextime:String,_ indexHeart:String,_ id:Int){
        let alertController = UIAlertController(title: "請輸入欲修改血氧", message: indextime, preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "血氧: "+indexHeart
        }
        let alertCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let alertOK = UIAlertAction(title: "確定", style: .default) { (action) in
            let b = alertController.textFields!.first!.text
            let bloodOxygen = Double(b!)
//            let userDefault = UserDefaults.standard
//            let userAccount = userDefault.string(forKey: "useraccount")
            let editBlood = EditBlood(id,bloodOxygen!)
            var requsetParam = [String: Any]()
            requsetParam["action"] = "bloodDetailEdit"
            requsetParam["bloodDetailEdit"] = try!String(bytes: JSONEncoder().encode(editBlood), encoding: .utf8)
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
