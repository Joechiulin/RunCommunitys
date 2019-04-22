//
//  HeartUpLoad.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/29.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
class HeartUpLoad:Codable{
    var count:Int = 0
    var userAccount:String?
    var heartBeat:String?
    var bloodOxygen:String?
    var sleep:String?
    var deepSleep:String?
    var date:String?
    var timeStamp:String?
    var twTime:String?
    
    public  init(_ count:Int,_ userAccount:String,_ heartBeat:String,_ bloodOxygen:String,_ sleep:String,_ deepSleep:String,_ date:String,_ timeStamp:String,_ twTime:String){
        self.count = count
        self.userAccount = userAccount
        self.heartBeat = heartBeat
        self.bloodOxygen = bloodOxygen
        self.sleep = sleep
        self.deepSleep = deepSleep
        self.date = date
        self.timeStamp = timeStamp
        self.twTime = twTime
    }
    

}
