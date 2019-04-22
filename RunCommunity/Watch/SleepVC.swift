//
//  SleepVC.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/22.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit
import Charts

class SleepVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var lDown: UILabel!
    
    @IBOutlet weak var sDown: UISlider!
    
    
    @IBOutlet weak var bcSleep: BarChartView!
    
    @IBOutlet weak var tvSleep: UITableView!
    
    @IBOutlet weak var tvSleepEdit: UITableView!
    
    @IBOutlet weak var bPost: UIButton!
    
    let url_server = URL(string: common_url + "WatchServlet")
    
    var sleeps = [Sleep]()
    
    var stringDates = [String]()
    
    var sleepTotalsMax:Double? = 0.0
    
    var sleepTotalsMin:Double? = 0.0
    
    var sleepAvg:Double? = 0.0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case tvSleep:
            numberOfRow = 3
        case tvSleepEdit:
            numberOfRow = sleeps.count
        default:
            print("somethingWrong")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tvSleep:
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "sleepCell")! as! HeartDetailTVCell
                
                let a:String = String(format:"%.1f", sleepTotalsMax!)
                let b:String = String(format:"%.1f", sleepTotalsMin!)
                let c:String = String(format:"%.1f", sleepAvg!)
                cell.lHeart.text = "最大值: "+a+"  平均值: "+c+"  最小值: "+b
                let ivSleep = UIImage(named: "sleep.png")
                cell.ivHeart.image = ivSleep
                return cell
            }else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "limitCell")! as! HeartDetailTVCell
                let userDefault = UserDefaults.standard
                var sleepLowerLimit:Double?
                if userDefault.double(forKey: "sleepLowerLimit") == 0.0{
                    sleepLowerLimit = 3.0
                }else{
                    sleepLowerLimit = userDefault.double(forKey: "sleepLowerLimit")
                }
                let b = String(format:"%.1f", sleepLowerLimit!)
                cell.lLimit.text = "  下管制界線: "+b
                let ivLimit = UIImage(named: "limit.png")
                cell.ivLimit.image = ivLimit
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "countCell")! as! HeartDetailTVCell
                
                let a = String(sleeps.count)
                cell.lCount.text = "天數: "+a
                let ivCount = UIImage(named: "count.png")
                cell.ivCount.image = ivCount
                return cell
            }
        case tvSleepEdit:
            let cell = tableView.dequeueReusableCell(withIdentifier: "sleepEditCell")! as! SleepTVCell
            cell.lTitle.text = sleeps[indexPath.row].sSleep
            cell.lSubtitle.text = "日期: "+sleeps[indexPath.row].sleepDate
            return cell
        default:
            print("wrong2")
        }
        return UITableViewCell()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addKeyboardObserver()
        bPost.clipsToBounds = true
        bPost.layer.cornerRadius = 5
        tvSleep.dataSource = self
        tvSleep.delegate = self
        tvSleepEdit.dataSource = self
        tvSleepEdit.delegate = self
        
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        showSleep()
        
    }
    
    
    func showSleep(){
        let userDefault = UserDefaults.standard
        let userAccount = userDefault.string(forKey: "useraccount")
        var requestPara = [String: String]()
        requestPara["action"] = "getSleep"
        requestPara["UserAccount"] = userAccount
        let today = Date()
        let datefromatter = DateFormatter()
        datefromatter.dateFormat = "yyyy-MM-dd"
        let endDate = datefromatter.string(from: today)+" 23:59:59"
        let date_subtract6d = Calendar.current.date(byAdding: .day, value: -6, to: today)
        let startDate = datefromatter.string(from: date_subtract6d!)+" 00:00:01"
        let detailSleep = DetailSleep(userAccount!, startDate, endDate)
        requestPara["getSleep"] = try!String(bytes: JSONEncoder().encode(detailSleep), encoding: .utf8)
        watchExecuteTask(url_server!, requestPara) { (data, reponse, error) in
            if error == nil{
                if data != nil{
                    //        print(String(data: data!, encoding: .utf8))
                    if let result = try?JSONDecoder().decode([Sleep].self, from: data!){
                        
                        self.sleeps = result
                        //                        self.sleeps.sort(by: { (sleep1, sleep2) -> Bool in
                        //                            return UIContentSizeCategory(rawValue: sleep1.date!)>UIContentSizeCategory(rawValue: sleep2.date!)
                        //                        })
                        DispatchQueue.main.async {
                            self.setChartValue(self.sleeps.count)
                            self.tvSleep.reloadData()
                            self.tvSleepEdit.reloadData()
                        }
                    }
                }
            }
        }
    }
    func setChartValue(_ count: Int){
        var dataEntries:[BarChartDataEntry] = []
        var dataEntries1:[BarChartDataEntry] = []
        var sleepTotals = [Double]()
        var sleepSum:Double = 0.0
        var dates = [String]()
        for i in (0..<count){
            let date = sleeps[i].sleepDate
            let sleep = sleeps[i].sleepHour
            let deepSleep = sleeps[i].deepSleepHour
            dates.append(date)
            let dataEntry = BarChartDataEntry(x: Double(i), y:sleep)
            dataEntries.append(dataEntry)
            let dataEntry1 = BarChartDataEntry(x: Double(i), y: deepSleep)
            dataEntries1.append(dataEntry1)
            sleepTotals.append(deepSleep)
            sleepSum+=deepSleep
        }
        sleepTotalsMax = sleepTotals.max()
        sleepTotalsMin = sleepTotals.min()
        sleepAvg = sleepSum/Double(sleepTotals.count)
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "淺眠")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "深眠")
        let userDefault = UserDefaults.standard
        var sleepLowerLimit:Double?
        if userDefault.double(forKey: "sleepLowerLimit") == 0.0{
            sleepLowerLimit = 3.0
        }else{
            sleepLowerLimit = userDefault.double(forKey: "sleepLowerLimit")
        }
        let ll = ChartLimitLine(limit: sleepLowerLimit!, label: "下界線")
        let leftAxis = bcSleep.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll)
        let dataSets:[BarChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        let chartData = BarChartData(dataSets: dataSets)
        let groupCount = self.sleeps.count
        let start = -0.5
        chartData.barWidth = barWidth
        bcSleep.xAxis.axisMinimum = Double(start)
        let gs = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        bcSleep.xAxis.axisMaximum = Double(start) + gs*Double(groupCount)
        chartData.groupBars(fromX: Double(start), groupSpace: groupSpace, barSpace: barSpace)
        bcSleep.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        bcSleep.xAxis.granularity = 1
        bcSleep.notifyDataSetChanged()
        bcSleep.data = chartData
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    //        func sortDate() -> [String]{
    //                for heart in self.hearts {
    //                    if !(stringDates.contains(heart.sDate)){
    //                        stringDates.append(heart.sDate)
    //                    }
    //                }
    //                stringDates.sort{ $0 > $1 }
    //                return stringDates
    //            }
    @IBAction func bPost(_ sender: Any) {
        let image = bcSleep.getChartImage(transparent: false)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        showMessage()
    }
    func showMessage(){
        let alertController = UIAlertController(title: "儲存成功", message: "快去相簿看看！", preferredStyle: .alert)
        self.present(alertController,animated: true,completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    func showAlert(_ indextime:String,_ indexSleep:String,_ indexDeep:String,_ id:Int,_ row:Int){
        let alertController = UIAlertController(title: "請輸入欲修改睡眠長度", message: indextime, preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "淺眠: "+indexSleep
        }
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "深眠: "+indexDeep
        }
        let alertCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let alertOK = UIAlertAction(title: "確定", style: .default) { (action) in
            let sleep = alertController.textFields?[0].text
            let deepSleep = alertController.textFields?[1].text
            let editSleep = EditSleep(id, sleep!, deepSleep!)
            print(id)
            var requsetParam = [String: Any]()
            requsetParam["action"] = "sleepEdit"
            requsetParam["sleepEdit"] = try!String(bytes: JSONEncoder().encode(editSleep), encoding: .utf8)
            watchExecuteTask(self.url_server!, requsetParam, completionHandler: { (data, reponse, error) in
                if error == nil{
                    if data != nil{
                        if let result = String(bytes: data!, encoding: .utf8){
                            if let count = Int(result){
                                if count != 0{
                                    let sleepChange = (sleep! as NSString).floatValue
                                    let deepChange = (deepSleep! as NSString).floatValue
                                    let editSleepArray = self.sleeps[row]
                                    editSleepArray.sleep = sleepChange
                                    editSleepArray.deepSleep = deepChange
                                    DispatchQueue.main.async {
                                        self.tvSleep.reloadData()
                                        self.tvSleepEdit.reloadData()
                                        self.setChartValue(self.sleeps.count)
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == tvSleep{
            return false
        }else{
            return true}
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            let indexTime = self.sleeps[indexPath.row].date!
            let indexSleep:String = String(format:"%.1f", self.sleeps[indexPath.row].sleep!)
            let indexdeep:String = String(format:"%.1f", self.sleeps[indexPath.row].deepSleep!)
            let id:Int = self.sleeps[indexPath.row].id!
            self.showAlert(indexTime,indexSleep,indexdeep,id,indexPath.row)
        }
        edit.backgroundColor = UIColor.lightGray
         return [edit]
    }
//    func addKeyboardObserver(){
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    @objc func keyboardWillShow(notification: Notification) {
//         if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRect = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRect.height
//            view.frame.origin.y = -keyboardHeight / 2
//        } else {
//            view.frame.origin.y = -view.frame.height / 3
//        }
//    }
//    
//    @objc func keyboardWillHide(notification: Notification) {
//        view.frame.origin.y = 0
//    }

    @IBAction func bDownMin(_ sender: Any) {
        lDown.text = "0.0"
        sDown.value = Float(0.0)
        let userDefault = UserDefaults.standard
        userDefault.set(0.0, forKey: "sleepLowerLimit")
        userDefault.synchronize()
        setChartValue(self.sleeps.count)
        tvSleep.reloadData()
    }
    
    @IBAction func bDownMid(_ sender: Any) {
        lDown.text = "12.0"
        sDown.value = Float(12.0)
        let userDefault = UserDefaults.standard
        userDefault.set(12.0, forKey: "sleepLowerLimit")
        userDefault.synchronize()
        setChartValue(self.sleeps.count)
        tvSleep.reloadData()
    }
    
    @IBAction func bDownMix(_ sender: Any) {
        lDown.text = "24.0"
        sDown.value = Float(24.0)
        let userDefault = UserDefaults.standard
        userDefault.set(24.0, forKey: "sleepLowerLimit")
        userDefault.synchronize()
        setChartValue(self.sleeps.count)
        tvSleep.reloadData()
    }
    
    
    @IBAction func sDown(_ sender: UISlider) {
        let slider = sender.value
        let value = String(format: "%.1f", slider)
        lDown.text = value
        let a = Double(slider)
        let userDefault = UserDefaults.standard
        userDefault.set(a, forKey: "sleepLowerLimit")
        userDefault.synchronize()
        setChartValue(self.sleeps.count)
        tvSleep.reloadData()
    }
    
}
