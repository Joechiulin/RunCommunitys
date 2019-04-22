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
    var date:String?
    var hearts = [HeartDetail]()
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
        let heartDetail = Detail(userAccount!, date!)
        requestParam["getHeartDetail"] = try!String(data: JSONEncoder().encode(heartDetail), encoding: .utf8)
        watchExecuteTask(url_server!, requestParam) { (data, response, error) in
            if error == nil{
                if data != nil{
                    if let result = try?JSONDecoder().decode([HeartDetail].self, from: data!){
                        for heart in self.hearts{
                            print(heart)
                        }
                        self.hearts = result
                        
                        DispatchQueue.main.async {
                            setChartValue(self.hearts.count)
                        }
                    }
                }
            }
        }
        func setChartValue(_ count: Int){
            var dataEntries:[ChartDataEntry] = []
            for i in (0..<count).reversed(){
                let time = hearts[i].time
                let heart = hearts[i].doubleHeart
                let dataEntry = ChartDataEntry(x: time, y: heart)
                dataEntries.append(dataEntry)
            }
            let set1 = LineChartDataSet(entries:dataEntries, label: "HeartBeat")
            let data = LineChartData(dataSet: set1)
            self.lineChart.data = data
        }
        
    }
}
