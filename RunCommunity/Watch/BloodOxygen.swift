//
//  BloodOxygen.swift
//  RunCommunity
//
//  Created by PIG on 2019/4/8.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
class BloodOxygen:Codable{
    
    var maxBloodOxygen:Float?
    var minBloodOxygen:Float?
    var date:String?
    
    public init(_ maxBloodOxygen:Float,_ minBloodOxygen:Float,_ date:String){
        self.maxBloodOxygen = maxBloodOxygen
        self.minBloodOxygen = minBloodOxygen
        self.date = date
    }
    var sBloodOxygen:String{
        let bloodOxygen = "最大/最小 血氧: " + String(maxBloodOxygen!)+"/"+String(minBloodOxygen!)
        return bloodOxygen
    }
    var sDate:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeRawData = dateFormatter.date(from: date!)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .full
        dateFormatter1.locale = Locale(identifier: "zh_TW")
        let fullDate = dateFormatter1.string(from: timeRawData!)
        return fullDate
    }
}
