//
//  Detail.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/17.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
class Detail:Codable{
    
    var userAccount:String?
    var time:String?
    
    public init(_ userAccount:String,_ time:String){
        self.userAccount = userAccount
        self.time = time
    }
}
