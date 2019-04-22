//
//  DetailHeartVC.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/26.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit
import Charts

class DetailHeartVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tvHeart: UITableView!
    
    @IBOutlet weak var bPost: UIButton!
    var heartTotalsMax:Double? = 0.0
    
    var heartTotalsMin:Double? = 0.0
    
    var heartAvg:Double? = 0.0
    
    var date:String?
    
    var hearts = [HeartDetail]()
    
    let url_server = URL(string: common_url + "WatchServlet")
    
    @IBOutlet weak var lineChart: LineChartView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvHeart.delegate = self
        tvHeart.dataSource = self
        bPost.clipsToBounds = true
        bPost.layer.cornerRadius = 5
    }
    override func viewWillAppear(_ animated: Bool) {
        setChart()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        setChart()
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "heartCell")! as! HeartDetailTVCell
            
            let a:String = String(format:"%.1f", heartTotalsMax!)
            let b:String = String(format:"%.1f", heartTotalsMin!)
            let c:String = String(format:"%.1f", heartAvg!)
            cell.lHeart.text = "最大值: "+a+"  平均值: "+c+"  最小值: "+b
            let ivHeartBeat = UIImage(named: "heartbeat.png")
            cell.ivHeart.image = ivHeartBeat
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "limitCell")! as! HeartDetailTVCell
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
            let a = String(format:"%.1f", heartUpperLimit!)
            let b = String(format:"%.1f", heartLowerLimit!)
            cell.lLimit.text = "上管制界線: "+a+"  下管制界線: "+b
            let ivLimit = UIImage(named: "limit.png")
            cell.ivLimit.image = ivLimit
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "countCell")! as! HeartDetailTVCell
            
            let a = String(hearts.count)
            cell.lCount.text = "筆數: "+a
            let ivHeartBeat = UIImage(named: "count.png")
            cell.ivCount.image = ivHeartBeat
            return cell
        }
    }
    // Do any additional setup after loading the view.
    
    func setChart(){
        var requestParam = [String: String]()
        requestParam["action"] = "getHeartDetail"
        let userDefault = UserDefaults.standard
        let userAccount = userDefault.string(forKey: "useraccount")
        let heartDetail = Detail(userAccount!, date!)
        requestParam["getHeartDetail"] = try!String(data: JSONEncoder().encode(heartDetail), encoding: .utf8)
        watchExecuteTask(url_server!, requestParam) { (data, response, error) in
            if error == nil{
                if data != nil{
                    if let result = try?JSONDecoder().decode([HeartDetail].self, from: data!){
//                        for heart in self.hearts{
//                            print(heart)
//                        }
                        self.hearts = result
                        
                        DispatchQueue.main.async {
                            setChartValue(self.hearts.count)
                            self.tvHeart.reloadData()
                        }
                    }
                }
            }
        }
        func setChartValue(_ count: Int){
            var dataEntries:[ChartDataEntry] = []
            var heartTotals = [Double]()
            var timeToatals = [Double]()
            var heartSum:Double = 0.0
            for i in (0..<count).reversed(){
                let time = hearts[i].time
                let heart = hearts[i].doubleHeart
                let dataEntry = ChartDataEntry(x: time, y: heart, icon: #imageLiteral(resourceName:"heart"))
                dataEntries.append(dataEntry)
                heartTotals.append(heart)
                timeToatals.append(time)
                heartSum+=heart
            }
            heartTotalsMax = heartTotals.max()
            heartTotalsMin = heartTotals.min()
            heartAvg = heartSum/Double(heartTotals.count)
            let timeTotalsMax = timeToatals.max()!+3
            let timeTotalsmin = timeToatals.min()!-1
            let yAxisMax = heartTotalsMax!+10.0
            let yAxismin = heartTotalsMin!-10.0
            let set1 = LineChartDataSet(entries:dataEntries, label: "心跳")
            set1.drawIconsEnabled = true
            set1.setColor(.black)
            set1.setCircleColor(.black)
            set1.lineWidth = 1
            set1.circleRadius = 4
            set1.drawCircleHoleEnabled = false
            set1.valueFont = .systemFont(ofSize: 9)
            set1.formLineDashLengths = [5, 2.5]
            set1.formLineWidth = 1
            set1.formSize = 15
            let data = LineChartData(dataSet: set1)
            lineChart.rightAxis.enabled = false
            let yAxis = lineChart.leftAxis
            yAxis.axisMaximum = yAxisMax
            yAxis.axisMinimum = yAxismin
            let buttomAxis = lineChart.xAxis
            buttomAxis.axisMaximum = timeTotalsMax
            buttomAxis.axisMinimum = timeTotalsmin
            let userDefault = UserDefaults.standard
            var heartUpperLimit:Double?
            var heartLowerLimit:Double?
            if userDefault.double(forKey: "heartUpperLimit") == 0.0{
                heartUpperLimit = 90
            }else{
                heartUpperLimit = userDefault.double(forKey: "heartUpperLimit")
            }
            if userDefault.string(forKey: "heartLowerLimit") == ""{
                heartLowerLimit = userDefault.double(forKey: "heartLowerLimit")
            }else{
                heartLowerLimit = 60
            }
            let ul = ChartLimitLine(limit: heartUpperLimit!, label: "上界線")
            let ll = ChartLimitLine(limit: heartLowerLimit!, label: "下界線")
            let leftAxis = lineChart.leftAxis
            leftAxis.removeAllLimitLines()
            leftAxis.addLimitLine(ul)
            leftAxis.addLimitLine(ll)
            //            leftAxis.axisMaximum = heartTotalsMax
            //            leftAxis.axisMaximum = heartTotalsmin
            leftAxis.gridLineDashLengths = [5, 5]
            leftAxis.drawLimitLinesBehindDataEnabled = true
            
            ul.lineWidth = 4
            ul.lineDashLengths = [5,5]
            ul.labelPosition = .topRight
            ul.valueFont = .systemFont(ofSize: 10)
            
            ll.lineWidth = 4
            ll.lineDashLengths = [5,5]
            ll.labelPosition = .topRight
            ll.valueFont = .systemFont(ofSize: 10)
            lineChart.xAxis.gridLineDashLengths = [10, 10]
            
            
            //            let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
            //                                       font: .systemFont(ofSize: 12),
            //                                       textColor: .black,
            //                                       insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
            
            self.lineChart.data = data
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? HeartEditVC{
            controller.hearts = self.hearts
        }
    }
    @IBAction func bPost(_ sender: Any) {
        let image = lineChart.getChartImage(transparent: false)
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
    
    
}



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
