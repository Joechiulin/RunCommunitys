//
//  HeartInsert.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/16.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation

class HeartInsert:Codable{
    var count:Int = 0
    var heartBeat:String?
    var userAccount:String?
    public  init(_ count:Int,_ heartBeat:String,_ userAccount:String){
        self.count = count
        self.heartBeat = heartBeat
        self.userAccount = userAccount
    }
    
}
