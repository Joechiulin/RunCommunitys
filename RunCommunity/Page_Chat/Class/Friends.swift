//
//  Friend.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/4/11.
//  Copyright © 2019 PIG. All rights reserved.
//

class  Friends: Codable {
    var id :Int?
    var userAccount :String?
    var friendAccount :String?
    var status :String?
    var timestamp :String?

    public init( _ friendAccount: String? ){
        self.friendAccount = friendAccount
    }
    
    
    
}
