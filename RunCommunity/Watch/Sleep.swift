//
//  Sleep.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/22.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation

class Sleep:Codable{
    var id:Int?
    var sleep:Float?
    var deepSleep:Float?
    var date:String?
    
    public init(_ id:Int,_ sleep:Float, _ deepSleep:Float, _ date:String) {
        self.id = id
        self.sleep = sleep
        self.deepSleep = deepSleep
        self.date = date
    }
    var sleepDate:String{
        let shortDate = String(self.date!.suffix(5))
        return shortDate
    }
    var sleepHour:Double{
        return Double(sleep!)
    }
    var deepSleepHour:Double{
        return Double(deepSleep!)
    }
    
    var sSleep:String{
        let a = String(format:"%.1f", sleep!)
        let b = String(format:"%.1f", deepSleep!)
        let c = "淺眠/深眠: "+a+"/"+b
        return c
    }
}

