//
//  BloodTVC.swift
//  RunCommunity
//
//  Created by PIG on 2019/4/8.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class BloodTVC: UITableViewController {
    let url_server = URL(string: common_url + "WatchServlet")
    var bloods = [BloodOxygen]()
    var stringDates = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //bloodCell

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        showBlood()
    }
    func showBlood(){
        let userDefault = UserDefaults.standard
        let userAccount = userDefault.string(forKey: "useraccount")
        var requestPara = [String: String]()
        requestPara["action"] = "getBlood"
        requestPara["userAccount"] = userAccount
        watchExecuteTask(url_server!, requestPara) { (data, reponse, error) in
            if error == nil{
                if data != nil{
                    //                print(String(data: data!, encoding: .utf8))
                    if let result = try?JSONDecoder().decode([BloodOxygen].self, from: data!){
                        self.bloods = result
                        //                        self.sortDate()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bloods.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bloodCell", for: indexPath) as! BloodTVCell
        cell.lTitle?.text = bloods[indexPath.row].sDate
        cell.lDetail?.text = bloods[indexPath.row].sBloodOxygen
        let userDefault = UserDefaults.standard
        var bloodLowerLimit:Double?
        if userDefault.double(forKey: "bloodLowerLimit") == 0.0{
            bloodLowerLimit = 60
        }else{
            bloodLowerLimit = userDefault.double(forKey: "bloodLowerLimit")
        }
        let min = CGFloat(bloods[indexPath.row].minBloodOxygen!)
        let minLimit = CGFloat(bloodLowerLimit!)
        if min < minLimit{
            let ivLower = UIImage(named: "lower.png")
            cell.ivLower?.image = ivLower
        }else{
            cell.ivLower?.image = nil
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = tableView.indexPathForSelectedRow?.row, let
            controller = segue.destination as? DetailBloodVC{
            controller.date = bloods[row].date!
        }
    }

 
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(action,indexPath) in
            var requsetParam = [String: Any]()
            requsetParam["action"] = "bloodDelete"
            let userDefault = UserDefaults.standard
            let userAccount = userDefault.string(forKey: "useraccount")
            let detail = Detail(userAccount!, self.bloods[indexPath.row].date!)
            requsetParam["bloodDelete"] = try! String(data: JSONEncoder().encode(detail), encoding: .utf8)
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
        return [delete]
    }
    
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

}
