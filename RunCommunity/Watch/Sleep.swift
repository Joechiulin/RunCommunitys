//
//  Sleep.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/22.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation

class Sleep:Codable{
    var sleep:Float?
    var deepSleep:Float?
    var date:Float?
    
    public init(_ sleep:Float, _ deepSleep:Float, _ date:Float) {
        self.sleep = sleep
        self.deepSleep = deepSleep
        self.date = date
    }
    var sleepDate:String{
        let dateSec = date!/1000
        let timeInterval = Date(timeIntervalSince1970: TimeInterval(dateSec))
        let sleepMonDay = Calendar.current.dateComponents([.month,.day], from: timeInterval)
        let sleepDate = String(sleepMonDay.month!) + "-" + String(sleepMonDay.day!)
        return sleepDate
    }
    var sleepHour:Double{
        let sleepHour = sleep!/3600000
        return Double(sleepHour)
    }
    var deepSleepHour:Double{
        let deepSleepHour = deepSleep!/3600000
        return Double(deepSleepHour)
    }
    
}

