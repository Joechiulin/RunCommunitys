//
//  HeartList.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/14.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
class Heart:Codable{
    
    var heart:Float?
    var date:Float?
    
    public init(_ heart:Float,_ date:Float){
        self.heart = heart
        self.date = date
    }
    var sDate:String{
        let timeStampRawData = (date!)/1000
        let timeInterval:TimeInterval = TimeInterval(timeStampRawData)
        let date1 = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var timeRawData = dateFormatter.string(from: date1)
        let weekday = Calendar.current.component(.weekday, from: date1)
        if weekday == 1{
            timeRawData+=" 星期日"
        }else if weekday == 2{
            timeRawData += " 星期一"
        }else if weekday == 3{
            timeRawData += " 星期二"
        }else if weekday == 4{
            timeRawData += " 星期三"
        }else if weekday == 5{
            timeRawData += " 星期四"
        }else if weekday == 6{
            timeRawData += " 星期五"
        }else{
            timeRawData += " 星期六"
        }
        return timeRawData
    }
    var time:Double{
        let timesec = self.date!/1000
        let date = Date(timeIntervalSince1970: TimeInterval(timesec))
        let timeHrMin = Calendar.current.dateComponents([.hour,.minute], from: date)
        let trueTime = Double(timeHrMin.hour!)+Double(timeHrMin.minute!/60)
        return trueTime
    }
    var doubleHeart:Double{
        let doubleHeart = Double(heart!)
        return doubleHeart
    }
}


