//
//  UploadViewController.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/29.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tvHeart: UITableView!
    
    let url_server = URL(string: common_url + "WatchServlet")
    
    @objc var hrs = [FitnessHR]()
    var hearts = [HeartUpLoad]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hearts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upLoadCell")!
        cell.textLabel?.text = "💗: "+hearts[indexPath.row].heartBeat!
        cell.detailTextLabel?.text = "日期: "+hearts[indexPath.row].twTime!
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.hearts.remove(at: indexPath.row)
            self.tvHeart.deleteRows(at: [indexPath], with: .fade)
        }
    }
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            self.hearts.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//        return [delete]
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tvHeart.delegate = self
        tvHeart.dataSource = self
        // Do any additional setup after loading the view.
    }
    func getData(){
        for hr in self.hrs{
            let userdefault = UserDefaults.standard
            let userAccount = userdefault.string(forKey: "userAccount")
            let numberFormatter = NumberFormatter()
            let a  = numberFormatter.string(from: hr.pulse)
            let b = hr.timestamp as! Double
            let c = b - 28800
            let timeInterval = Date(timeIntervalSince1970: c)
            let timeInterval1 = Date(timeIntervalSince1970: b)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let timeStamp = dateFormatter.string(from: timeInterval)
            let twTime = dateFormatter.string(from: timeInterval1)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.string(from: timeInterval)
            let heart = HeartUpLoad(0, userAccount!, a!, "-1", "-1", "-1",date,timeStamp,twTime)
            hearts.append(heart)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func upLoad(_ sender: Any) {
        
        var requestParam = [String:Any]()
        requestParam["action"] = "heartInsert"
        requestParam["heartInsert"] = try!String(data: JSONEncoder().encode(hearts), encoding: .utf8)
        executeTask(url_server!, requestParam) { (data, reponse, error) in
            if error == nil{
                if data != nil{
                    if let count = String(bytes: data!, encoding: .utf8){
                        if let count = Int(count){
                            if count != 0{
                                DispatchQueue.main.async {
                                    if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Watch"){
                                        self.present(controller,animated: true, completion: nil)
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
}


