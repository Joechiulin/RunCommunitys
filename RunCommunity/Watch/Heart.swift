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
        let timeStampRawData = (self.date!)/1000
        let timeInterval:TimeInterval = TimeInterval(timeStampRawData)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeRawData = dateFormatter.string(from: date)
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


