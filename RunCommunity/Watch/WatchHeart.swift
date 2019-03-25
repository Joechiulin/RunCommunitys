//
//  WatchHeart.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/10.
//  Copyright © 2019 PIG. All rights reserved.
//
import UIKit
import Foundation

class WatchHeart:Codable{
    var heart:Float?
    var date:Float?
    
    init(heart:Float, date:Float){
        self.heart = heart
        self.date = date
    }
    var sDate:String{
        let timeStampRawData = date!/1000
        let timeInterval:TimeInterval = TimeInterval(timeStampRawData)
        let date1 = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let timeRawData = dateFormatter.string(from: date1)
        return timeRawData 
        }
    func getHeart() -> Float{
        return heart!
    }
    func getdate() -> Float {
        return date!
    }
}
