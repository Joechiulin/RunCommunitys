//
//  person.swift
//  RunCommunity
//
//  Created by Joe on 2019/3/14.
//  Copyright © 2019 PIG. All rights reserved.
//


class  Person: Codable {
    var account :String?
    var password : String?
    var phone : String?
    var email :String?
    
    
    public init(_ account: String, _ password: String, _ phone:String? , _ email : String?){
        self.account = account
        self.password = password
        self.phone = phone
        self.email = email
    }
    
    public init(_ account: String, _ password: String){
        self.account = account
        self.password = password
     
    }
    
}
