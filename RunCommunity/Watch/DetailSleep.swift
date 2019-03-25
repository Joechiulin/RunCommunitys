//
//  DetailSleep.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/22.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
class DetailSleep:Codable{
    
    var userAccount:String?
    var startDate:String?
    var endDate:String?

    
    
    public init(_ userAccount:String,_ startDate:String,_ endDate:String){
        self.userAccount = userAccount
        self.startDate = startDate
        self.endDate = endDate
    }
}
