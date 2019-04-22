//
//  watchTableViewController.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/10.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class HeartTVC: UITableViewController {
    let url_server = URL(string: common_url + "WatchServlet")
    var hearts = [Heart]()
    var stringDates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUserAccount()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showHeart()
    }
//    func setUserAccount(){
//        let userDefault = UserDefaults.standard
//        userDefault.set("pig200a", forKey: "userAccount")
//        userDefault.synchronize()
//    }
    
    func showHeart(){
        let userDefault = UserDefaults.standard
        let userAccount = userDefault.string(forKey: "useraccount")
        var requestPara = [String: String]()
        requestPara["action"] = "getHeart"
        requestPara["userAccount"] = userAccount
        watchExecuteTask(url_server!, requestPara) { (data, reponse, error) in
            if error == nil{
                if data != nil{
//                print(String(data: data!, encoding: .utf8))
                    if let result = try?JSONDecoder().decode([Heart].self, from: data!){
                        self.hearts = result
//                        self.sortDate()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //        print(hearts.count)
        return hearts.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "heartCell", for: indexPath) as! HeartTVCell
        cell.lTitle?.text = hearts[indexPath.row].sDate
        cell.lDetail?.text = hearts[indexPath.row].sHeart
        //
        

        //
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
        let max = CGFloat(hearts[indexPath.row].maxHeart!)
        let maxLimit = CGFloat(heartUpperLimit!)
        if max > maxLimit{
            let ivUpper = UIImage(named: "upper.png")
            cell.ivUpper?.image = ivUpper
        } else {
             cell.ivUpper?.image = nil
        }
        let min = CGFloat(hearts[indexPath.row].minHeart!)
        let minLimit = CGFloat(heartLowerLimit!)
        if min < minLimit{
            let ivLower = UIImage(named: "lower.png")
            cell.ivLower?.image = ivLower
        }else{
                cell.ivLower?.image = nil
        }
//        print("maxLimit", maxLimit, max, min)

        return cell
    }
//    func sortDate() -> [String]{
//        for heart in self.hearts {
//            if !(stringDates.contains(heart.sDate)){
//                stringDates.append(heart.sDate)
//            }
//        }
//        stringDates.sort{ $0 > $1 }
//        return stringDates
//    }
//    func sortHeart() -> String {
//        for heart in self.hearts{
//            doubleHearts.append(heart.doubleHeart)
//        }
//        let max = String(doubleHearts.max()!)
//        let min = String(doubleHearts.min()!)
//
//        let detail =
//        return ""
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = tableView.indexPathForSelectedRow?.row, let
            controller = segue.destination as? DetailHeartVC{
            controller.date = hearts[row].date!
        }
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
          let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(action,indexPath) in
            var requsetParam = [String: Any]()
            requsetParam["action"] = "heartDelete"
            let userDefault = UserDefaults.standard
            let userAccount = userDefault.string(forKey: "useraccount")
            let detail = Detail(userAccount!, self.hearts[indexPath.row].date!)
            requsetParam["heartDelete"] = try! String(data: JSONEncoder().encode(detail), encoding: .utf8)
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
        return [delete]
    }
}
