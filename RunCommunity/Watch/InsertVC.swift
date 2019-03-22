//
//  InsertViewController.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/10.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class InsertVC: UIViewController {
    let url_server = URL(string: common_url_watch + "WatchServlet")
    
    @IBOutlet weak var svInsert: UIStackView!
    
    @IBOutlet weak var lUser: UILabel!
    
    @IBOutlet weak var tfHeartBeat: UITextField!
    
    @IBOutlet weak var tfBloodOxygen: UITextField!
    
    @IBOutlet weak var tfSleep: UITextField!
    
    @IBOutlet weak var tfDeepSleep: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func stackView(){
        //        svInsert.setCustomSpacing(10, after: lUser)
        //        svInsert.setCustomSpacing(10, after: tfHeartBeat)
        //        svInsert.setCustomSpacing(10, after: tfBloodOxygen)
        //        svInsert.setCustomSpacing(10, after: tfSleep)
        //        svInsert.setCustomSpacing(30, after: tfDeepSleep)
        let userDefault = UserDefaults.standard
        let userAccount = userDefault.string(forKey: "userAccount")
        lUser.text = userAccount
        
    }
    
    @IBAction func bSubmit(_ sender: Any) {
        getInfo()
    }
    
    
    func getInfo(){
        let heartBeat = tfHeartBeat.text == nil || tfHeartBeat.text!.isEmpty ? "-1":
            tfHeartBeat.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //        let heartBeat = Float(h)
        let bloodOxygen = tfBloodOxygen.text == nil || tfBloodOxygen.text!.isEmpty ? "-1":
            tfBloodOxygen.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let sleep = tfSleep.text == nil || tfSleep.text!.isEmpty ? "-1":
            String((Int(tfSleep.text!.trimmingCharacters(in: .whitespacesAndNewlines))!)*3600000)
        let deepSleep = tfDeepSleep.text == nil || tfDeepSleep.text!.isEmpty ? "-1":
            String((Int(tfDeepSleep.text!.trimmingCharacters(in: .whitespacesAndNewlines))!)*3600000)
        var requseParam = [String: Any]()
        let userDefault = UserDefaults.standard
        let userAccount = userDefault.string(forKey: "userAccount")
        let allInsert = AllInsert(0, userAccount!, heartBeat, bloodOxygen, sleep, deepSleep)
        requseParam["action"] = "allInsert"
        requseParam["allInsert"] = try!String(data: JSONEncoder().encode(allInsert), encoding: .utf8)
        executeTask(url_server!, requseParam) { (data, reponse, error) in
            if error == nil{
                if data != nil{
                    if let result  = String(bytes: data!, encoding: .utf8){
                        if let count = Int(result){
                            DispatchQueue.main.async {
                                if count != 0{
                                    self.lUser.text = "success"
                                }else{
                                    self.lUser.text = "fail"
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
