//
//  InsertTVC.swift
//  RunCommunity
//
//  Created by PIG on 2019/4/13.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class InsertTVC: UITableViewController {
    @IBOutlet weak var tfHeartBeat: UITextField!
    @IBOutlet weak var tfBloodOxygen: UITextField!
    @IBOutlet weak var tfSleep: UITextField!
    @IBOutlet weak var tfDeepSleep: UITextField!
    @IBOutlet weak var bSubmit: UIButton!
     let url_server = URL(string: common_url + "WatchServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bSubmit.clipsToBounds = true
        bSubmit.layer.cornerRadius = 5
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.allowsSelection.self = false
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    func getInfo(){
        let heartBeat = tfHeartBeat.text == nil || tfHeartBeat.text!.isEmpty ? "-1":
            tfHeartBeat.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //        let heartBeat = Float(h)
        let bloodOxygen = tfBloodOxygen.text == nil || tfBloodOxygen.text!.isEmpty ? "-1":
            tfBloodOxygen.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let sleep = tfSleep.text == nil || tfSleep.text!.isEmpty ? "-1":
            tfSleep.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //            String((Int(tfSleep.text!.trimmingCharacters(in: .whitespacesAndNewlines))!)*3600000)
        let deepSleep = tfDeepSleep.text == nil || tfDeepSleep.text!.isEmpty ? "-1":   tfDeepSleep.text!.trimmingCharacters(in: .whitespacesAndNewlines)//            String((Int(tfDeepSleep.text!.trimmingCharacters(in: .whitespacesAndNewlines))!)*3600000)
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
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.selectionStyle = .none
//        return cell
//    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func touchCell0(_ sender: Any) {
        tableView.endEditing(true)
    }
    @IBAction func bGetInfo(_ sender: Any) {
        getInfo()
    }
}
