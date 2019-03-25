//
//  SleepVC.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/22.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit
import Charts

class SleepVC: UIViewController {
    let url_server = URL(string: common_url_watch + "WatchServlet")
    var sleeps = [Sleep]()
    var stringDates = [String]()


    @IBOutlet weak var bcSleep: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        showSleep()
    }

    
    func showSleep(){
        let userDefault = UserDefaults.standard
        let userAccount = userDefault.string(forKey: "userAccount")
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
                    //                    print(String(data: data!, encoding: .utf8))
                    if let result = try?JSONDecoder().decode([Sleep].self, from: data!){
                        self.sleeps = result
                        DispatchQueue.main.async {
                            self.setChartValue(self.sleeps.count)
                        }
                    }
                }
            }
        }
    }
    func setChartValue(_ count: Int){
        var dataEntries:[BarChartDataEntry] = []
        var dataEntries1:[BarChartDataEntry] = []
        var dates = [String]()
        for i in (0..<count).reversed(){
            let date = sleeps[i].sleepDate
            let sleep = sleeps[i].sleepHour
            let deepSleep = sleeps[i].deepSleepHour
            dates.append(date)
            let dataEntry = BarChartDataEntry(x: Double(i), y:sleep)
            dataEntries.append(dataEntry)
            let dataEntry1 = BarChartDataEntry(x: Double(i), y: deepSleep)
            dataEntries1.append(dataEntry1)
        }
        var axisFormat:IAxisValueFormatter?
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Sleep")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "DeepSleep")
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

}
