//
//  watchTableViewController.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/10.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class HeartTVC: UITableViewController {
    let url_server = URL(string: common_url_watch + "WatchServlet")
    var hearts = [Heart]()
    var stringDates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        setUserAccount()
        showHeart()
    }
    func setUserAccount(){
        let userDefault = UserDefaults.standard
        userDefault.set("pig200a", forKey: "userAccount")
        userDefault.synchronize()
    }
    
    func showHeart(){
        let userDefault = UserDefaults.standard
        let userAccount = userDefault.string(forKey: "userAccount")
        var requestPara = [String: String]()
        requestPara["action"] = "getHeart"
        requestPara["UserAccount"] = userAccount
        watchExecuteTask(url_server!, requestPara) { (data, reponse, error) in
            if error == nil{
                if data != nil{
                    //                    print(String(data: data!, encoding: .utf8))
                    if let result = try?JSONDecoder().decode([Heart].self, from: data!){
                        self.hearts = result
                        self.sortHeart()
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
        return stringDates.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "heartCell", for: indexPath)
        
        cell.textLabel?.text = stringDates[indexPath.row]
        return cell
    }
    func sortHeart() -> [String]{
        for heart in self.hearts {
            if !(stringDates.contains(heart.sDate)){
                stringDates.append(heart.sDate)
            }
        }
        stringDates.sort{ $0 > $1 }
        return stringDates
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
            controller = segue.destination as? detailChartVC{
            controller.heart = stringDates[row]
        }
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
          let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(action,indexPath) in
            var requsetParam = [String: Any]()
            requsetParam["action"] = "heartDelete"
            let userDefault = UserDefaults.standard
            let userAccount = userDefault.string(forKey: "userAccount")
            let heartDetail = Detail(userAccount!, self.stringDates[indexPath.row])
            requsetParam["heartDelete"] = try! String(data: JSONEncoder().encode(heartDetail), encoding: .utf8)
            watchExecuteTask(self.url_server!, requsetParam, completionHandler: { (data, reponse, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(bytes: data!, encoding: .utf8){
                            if let count = Int(result){
                                if count != 0{
                                        self.stringDates.remove(at: indexPath.row)
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
//
//        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            var requsetParam = [String: String]()
//            requsetParam["action"] = "heartDelete"
//            let userDefault = UserDefaults.standard
//            let userAccount = userDefault.string(forKey: "userAccount")
//            let heartDetail = Detail(userAccount!, self.stringDates[indexPath.row])
//            requsetParam["heartDelete"] = try! String(data: JSONEncoder().encode(heartDetail), encoding: .utf8)
//            executeTask(self.url_server!, requsetParam, completionHandler: { (data, reponse, error) in
//                if error == nil {
//                    if data != nil {
//                        if let result = String(bytes: data!, encoding: .utf8){
//                            if let count = Int(result){
//                                if count != 0{
//                                    self.hearts.remove(at: indexPath.row)
//                                    DispatchQueue.main.async {
//                                        tableView.deleteRows(at: [indexPath], with: .fade)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }else{
//                    print(error!.localizedDescription)
//                }
//            })
//
//        }
//        return [delete]
    }
    
}
