//
//  BloodOxygenInsert.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/16.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
class BloodOxygenInsert:Codable{
    var count:Int = 0
    var bloodOxygen:String?
    var userAccount:String?
    public  init(_ count:Int,_ bloodOxygen:String,_ userAccount:String){
        self.count = count
        self.bloodOxygen = bloodOxygen
        self.userAccount = userAccount
    }
    
}
