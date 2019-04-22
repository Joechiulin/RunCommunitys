//
//  BloodDetail.swift
//  RunCommunity
//
//  Created by PIG on 2019/4/8.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
class BloodDetail:Codable{
    var id:Int?
    var bloodOxygen:Float?
    var timeStamp:Double?
    public init (_ id:Int,_ bloodOxygen:Float,_ timeStamp:Double){
        self.id = id
        self.bloodOxygen = bloodOxygen
        self.timeStamp = timeStamp
    }
    var time:Double{
        let timesec = self.timeStamp!/1000
        let date = Date(timeIntervalSince1970: TimeInterval(timesec))
        let timeHrMin = Calendar.current.dateComponents([.hour,.minute], from: date)
        let trueTime = Double(timeHrMin.hour!)+Double(timeHrMin.minute!/60)
        return trueTime
    }
    var doubleBlood:Double{
        let doubleBloodOxygen = Double(bloodOxygen!)
        return doubleBloodOxygen
    }
    var sBloodOxygen:String{
        let a:String = String(format:"%.1f", bloodOxygen!)
        return a
    }
    var stime:String{
        let timesec = self.timeStamp!/1000
        let date = Date(timeIntervalSince1970: TimeInterval(timesec))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let trueTime = dateFormatter.string(from: date)
        return trueTime
    }
    var delete:String{
        let timesec = (self.timeStamp!-28800000)/1000
        let date = Date(timeIntervalSince1970: TimeInterval(timesec))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let trueTime = dateFormatter.string(from: date)
        return trueTime
    }
    
    
}
