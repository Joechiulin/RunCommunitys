//
//  DetailBloodVC.swift
//  RunCommunity
//
//  Created by PIG on 2019/4/8.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit
import Charts
class DetailBloodVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var bPost: UIButton!
    
    @IBOutlet weak var tvBlood: UITableView!
    
    @IBOutlet weak var lineChart: LineChartView!
    
    var bloodTotalsMax:Double? = 0.0
    
    var bloodTotalsMin:Double? = 0.0
    
    var bloodAvg:Double? = 0.0
    
    var date:String?
    
    var bloods = [BloodDetail]()
    
    let url_server = URL(string: common_url + "WatchServlet")
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "bloodCell")! as! HeartDetailTVCell
            
            let a:String = String(format:"%.1f", bloodTotalsMax!)
            let b:String = String(format:"%.1f", bloodTotalsMin!)
            let c:String = String(format:"%.1f", bloodAvg!)
            cell.lHeart.text = "最大值: "+a+"  平均值: "+c+"  最小值: "+b
            let ivHeartBeat = UIImage(named: "bloodOxygen.png")
            cell.ivHeart.image = ivHeartBeat
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "limitCell")! as! HeartDetailTVCell
            let userDefault = UserDefaults.standard
            var bloodLowerLimit:Double?
            if userDefault.double(forKey: "bloodLowerLimit") == 0.0{
                bloodLowerLimit = 60
            }else{
                bloodLowerLimit = userDefault.double(forKey: "bloodLowerLimit")
            }
            let b = String(format:"%.1f", bloodLowerLimit!)
            cell.lLimit.text = "  下管制界線: "+b
            let ivLimit = UIImage(named: "limit.png")
            cell.ivLimit.image = ivLimit
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "countCell")! as! HeartDetailTVCell
            
            let a = String(bloods.count)
            cell.lCount.text = "筆數: "+a
            let ivCount = UIImage(named: "count.png")
            cell.ivCount.image = ivCount
            return cell
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tvBlood.delegate = self
        tvBlood.dataSource = self
        bPost.clipsToBounds = true
        bPost.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setChart()
    }
    func setChart(){
        var requestParam = [String: String]()
        requestParam["action"] = "getBloodDetail"
        let userDefault = UserDefaults.standard
        let userAccount = userDefault.string(forKey: "useraccount")
        let bloodDetail = Detail(userAccount!, date!)
        requestParam["getBloodDetail"] = try!String(data: JSONEncoder().encode(bloodDetail), encoding: .utf8)
        watchExecuteTask(url_server!, requestParam) { (data, response, error) in
            if error == nil{
                if data != nil{
                    if let result = try?JSONDecoder().decode([BloodDetail].self, from: data!){
//                        for heart in self.bloods{
//                            print(heart)
//                        }
                        self.bloods = result
                        
                        DispatchQueue.main.async {
                            self.setChartValue(self.bloods.count)
                            self.tvBlood.reloadData()
                        }
                    }
                }
            }
        }
}
    func setChartValue(_ count: Int){
        var dataEntries:[ChartDataEntry] = []
        var bloodTotals = [Double]()
        var timeToatals = [Double]()
        var bloodSum:Double = 0.0
        for i in (0..<count).reversed(){
            let time = bloods[i].time
            let blood = bloods[i].doubleBlood
            let dataEntry = ChartDataEntry(x: time, y: blood, icon: #imageLiteral(resourceName:"blood"))
            dataEntries.append(dataEntry)
            bloodTotals.append(blood)
            timeToatals.append(time)
            bloodSum+=blood
        }
        bloodTotalsMax = bloodTotals.max()
        bloodTotalsMin = bloodTotals.min()
        bloodAvg = bloodSum/Double(bloodTotals.count)
        let timeTotalsMax = timeToatals.max()!+1
        let timeTotalsmin = timeToatals.min()!-1
        let yAxisMax = bloodTotalsMax!+10.0
        let yAxismin = bloodTotalsMin!-10.0
        let set1 = LineChartDataSet(entries:dataEntries, label: "血氧")
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
        var bloodLowerLimit:Double?
        if userDefault.string(forKey: "bloodLowerLimit") == ""{
            bloodLowerLimit = userDefault.double(forKey: "bloodLowerLimit")
        }else{
            bloodLowerLimit = 60
        }
        let ll = ChartLimitLine(limit: bloodLowerLimit!, label: "下界線")
        let leftAxis = lineChart.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll)
        //            leftAxis.axisMaximum = heartTotalsMax
        //            leftAxis.axisMaximum = heartTotalsmin
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? BloodEditVC{
            controller.bloods = self.bloods
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
    

