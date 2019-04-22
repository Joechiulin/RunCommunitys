//
//  HeartList.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/14.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
class Heart:Codable{
    
    var maxHeart:Float?
    var minHeart:Float?
    var date:String?
    
    public init(_ maxHeart:Float,_ minHeart:Float,_ date:String){
        self.maxHeart = maxHeart
        self.minHeart = minHeart
        self.date = date
    }
    var sHeart:String{
        let heart = "最大/最小 心跳: " + String(maxHeart!)+"/"+String(minHeart!)
            return heart
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


