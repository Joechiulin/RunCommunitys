//
//  SleepInsert.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/16.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
class SleepInsert:Codable{
    var count:Int = 0
    var sleep:String?
    var deepSleep:String?
    var userAccount:String?
    public  init(_ count:Int,_ sleep:String,_ deepSleep:String,_ userAccount:String){
        self.count = count
        self.sleep = sleep
        self.deepSleep = deepSleep
        self.userAccount = userAccount
    }
    
}
