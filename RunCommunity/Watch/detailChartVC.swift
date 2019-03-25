//
//  detailChartVC.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/16.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit
import Charts

class detailChartVC: UIViewController {
    
    @IBOutlet weak var lineChart: LineChartView!
    
    
    var heart:String?
    var hearts = [Heart]()
    let url_server = URL(string: common_url_watch + "WatchServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart()
        
        // Do any additional setup after loading the view.
    }
    func setChart(){
        var requestParam = [String: String]()
        requestParam["action"] = "getHeartDetail"
        let userDefault = UserDefaults.standard
        let userAccount = userDefault.string(forKey: "userAccount")
        let startUnit = heart!.index(heart!.startIndex, offsetBy: 0)
        let endUnit = heart!.index(startUnit, offsetBy: 10)
        let realHeart = heart![startUnit..<endUnit]
        let heartDetail = Detail(userAccount!, String(realHeart))
        requestParam["getHeartDetail"] = try!String(data: JSONEncoder().encode(heartDetail), encoding: .utf8)
        watchExecuteTask(url_server!, requestParam) { (data, response, error) in
            if error == nil{
                if data != nil{
                    if let result = try?JSONDecoder().decode([Heart].self, from: data!){
                        self.hearts = result
                        DispatchQueue.main.async {
                            setChartValue(self.hearts.count)
                        }
                    }
                }
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
        func setChartValue(_ count: Int){
//            let values = (0..<count).map { (i) -> ChartDataEntry in
//                let x = hearts[i].time
//                let y = hearts[i].doubleHeart
//                return ChartDataEntry(x: x, y: y)
//            }
//            let set1 = LineChartDataSet(entries: values, label: "HeartBeat")
//            let data = LineChartData(dataSet: set1)
//            self.lineChart.data = data
            var dataEntries:[ChartDataEntry] = []
            for i in (0..<count).reversed(){
                let time = hearts[i].time
                let heart = hearts[i].doubleHeart
                let dataEntry = ChartDataEntry(x: time, y: heart)
                dataEntries.append(dataEntry)
            }
            let set1 = LineChartDataSet(entries: dataEntries, label: "HeartBeat")
            let data = LineChartData(dataSet: set1)
            self.lineChart.data = data
        }
        
    }
}
